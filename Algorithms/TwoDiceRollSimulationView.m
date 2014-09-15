//
//  TwoDiceRollSimulationView.m
//  Algorithms
//
//  Created by Scott Carter on 8/21/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "TwoDiceRollSimulationView.h"

#import "Project.h"


/*
 Description:
 
 
 */

// FIXME: None
// TODO: None
#pragma mark -


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Private Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
@interface TwoDiceRollSimulationView() <UIAlertViewDelegate, UITextFieldDelegate, CPTBarPlotDataSource, CPTBarPlotDelegate>

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

@property (nonatomic, strong) CPTBarPlot *rollPlot;
@property (nonatomic, strong) NSMutableArray *annotationMutableArr;


@property (weak, nonatomic) IBOutlet UITextField *numTrialsTextField;

@property (nonatomic) NSInteger numTrials;


// Return data obtained from viewDataForAlgorithmInputs: delegate method
@property (strong, nonatomic) NSDictionary *dataForAlgorithm;

@property (nonatomic) NSInteger maxCount;



@property (weak, nonatomic) IBOutlet UISwitch *clickToShowAnnotationSwitch;


@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation TwoDiceRollSimulationView

// ==========================================================================
// Constants and Defines
// ==========================================================================
//
#pragma mark -
#pragma mark Constants and Defines

// X axis length will be 11 in order to display bar plots for 0-10 (rolls 2-12).
CGFloat const XAxisLength = 11.0;


CGFloat const BarWidth = 0.6f; // 1.0 would leave no space between records

// The width expands around the X point on both sides.  In order to fully see the
// first record, BarInitialX should be >= BarWidth/2.
//
// What about fully seeing last record?
// If XAxisLength is set to hold exactly that # of records, then
// we leave 1.0 - BarInitialX for last record.   Thus we want (1.0 - BarInitialX) >= BarWidth/2
//
// Example:  If BarInitialX = 0.6, then 0.4 >= BarWidth/2.  Thus BarWidth <= 0.8.  In practice,
// this wouldn't leave any room for the right border, so adjust accordingly.
//
CGFloat const BarInitialX = 0.5f;

// We take our max count and multiply by YAxisStretchFactor to leave room for annotations without overlap with plot.
// See configureGraph,
CGFloat const YAxisStretchFactor = 1.2f;


// ==========================================================================
// Instance variables.  Could also be in interface section.
// ==========================================================================
//
#pragma mark -
#pragma mark Instance variables

// None


// ==========================================================================
// Synthesize public properties
// ==========================================================================
//
#pragma mark -
#pragma mark Synthesize public properties

// None


// ==========================================================================
// Synthesize private properties
// ==========================================================================
//
#pragma mark -
#pragma mark Synthesize private properties

// None


// ==========================================================================
// Getters and Setters
// ==========================================================================
//
#pragma mark -
#pragma mark Getters and Setters

- (NSMutableArray *)annotationMutableArr
{
    if(!_annotationMutableArr){
        _annotationMutableArr = [[NSMutableArray alloc] init];
    }
    return _annotationMutableArr;
}



// ==========================================================================
// Actions
// ==========================================================================
//
#pragma mark -
#pragma mark Actions

// None

- (IBAction)switchAction:(UISwitch *)sender {
    [self updateAlgorithmDisplay];
}



// ==========================================================================
// Initializations
// ==========================================================================
//
#pragma mark -
#pragma mark Initializations


// All outlet and action connections have been established.
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.numTrialsTextField.delegate = self;
    
    self.numTrialsTextField.text = @"1000";
    
    // Register for notifications for when drawRect is called by CPTGraphHostingView.
    //
    // We are interested in the very first notification which will allow us to
    // call runAlgorithm.
    //
    // See note to viewDidLayoutSubviews: in DetailViewController.m
    // We need a call to drawRect to let us know when self.hostView has settled bounds.
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(graphHostingViewDrawRectNotification:)
                                                 name:CPTGraphHostingViewDrawRectNotification
                                               object:nil];
    
}


- (void)dealloc
{
    NSLog(@"!!! dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




// Called when we have been added to a super view.
//
// This is the earliest time that we would wish to call runAlgorithm to ensure that our
// viewDataDelegate property inherited from AlgorithmView is setup.
//
// In this particular view, we need to wait even longer (after drawRect is called) to
// ensure that the bounds of self.hostView have settled.
//
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    // If we have been removed from a super view, do nothing.
    if(!self.superview){
        return;
    }
    
    
    // Notify any listeners that we are loaded.
    [[NSNotificationCenter defaultCenter] postNotificationName:CodeSetChangeNotification object:self userInfo:nil];
    
}


- (void)graphHostingViewDrawRectNotification:(NSNotification *)notification
{
    
    // Not interested in further drawRect notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self runAlgorithm];
}


// ==========================================================================
// Protocol methods
// ==========================================================================
//
#pragma mark -
#pragma mark Protocol methods


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NLOG("Clicked button %d",buttonIndex)
    self.numTrialsTextField.text = @"1000";
    
    [self runAlgorithm];
}



#pragma mark - UITextFieldDelegate


// Called when we resign text field as first responder.
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger numTrials = [self.numTrialsTextField.text integerValue];
    
    if(numTrials <= 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid entry" message:@"Specify > 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self runAlgorithm];
}

// We resign text field as first responder if user hits return/done key regardless of whether
// text is present in field.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NLOG("")
    
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 11;  // Roll sums 2 - 12
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSArray *randomArrCountsArr = [[NSArray alloc] initWithArray:self.dataForAlgorithm[@"randomArrCounts"]];
    
    if(fieldEnum == CPTBarPlotFieldBarTip){
        
        // index ranges 0-10, shift to get result for 2-12
        return randomArrCountsArr[index + 2]; // Y Axis
    }
    
    return [NSNumber numberWithUnsignedInteger:index];  // X Axis
}



 

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    
    // Show annotation (reuse) from this delegate method if clickToShowAnnotationSwitch is on.
    if(self.clickToShowAnnotationSwitch.on){
        [self showAnnotation:plot recordIndex:index reuseAnnotation:YES];
    }
}





// ==========================================================================
// Class methods
// ==========================================================================
//
#pragma mark -
#pragma mark Class methods

// None


// ==========================================================================
// Instance methods
// ==========================================================================
//
#pragma mark -
#pragma mark Instance methods

#pragma mark Overrides of base class


// All of chart elements except annotations rotate nicely without the need
// to force a redraw with updateAlgorithmDisplay.   We do call that method
// after a rotate to handle annotations specifically.  To avoid
// a jump in annotation positioning during the transition, we first hide annotations here.
- (void)algorithmViewWillRotate
{
    [self hideAnnotation:self.rollPlot.graph];
}


// Gather input data, ask our delegate for model output.
- (void)runAlgorithm
{
    self.numTrials = [self.numTrialsTextField.text integerValue];
    
    self.dataForAlgorithm = [self.viewDataDelegate viewDataForAlgorithmInputs:@{@"numTrials":[NSNumber numberWithInteger:self.numTrials]}];
    

    [self updateAlgorithmDisplay];
}


// Update display.  Can be called after runAlgorithm or when bounds may have changed.
- (void)updateAlgorithmDisplay
{
    NSArray *randomArrCountsArr = [[NSArray alloc] initWithArray:self.dataForAlgorithm[@"randomArrCounts"]];
    
    
    // Record our max count for plot
    NSInteger maxCount = 0;
    
    for (NSNumber *countNum in randomArrCountsArr) {
        NSInteger count = [countNum integerValue];
        
        if(count > maxCount){
            maxCount = count;
        }
    }
    
    self.maxCount = maxCount;
                    
    [self initPlot];
}




#pragma mark - Chart behavior
-(void)initPlot {
    
    // Since we might re-use self.annotationMutableArr array, we need to empty it here since it
    // might be associated with a previous plot space
    [self.annotationMutableArr removeAllObjects];

    
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    
    // If clickToShowAnnotationSwitch is off, show all annotations.
    if(!self.clickToShowAnnotationSwitch.on){
        [self showAllAnnotations];
    }
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    
    // 2 - Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];  // kCPTSlateTheme, kCPTDarkGradientTheme, kCPTPlainWhiteTheme, kCPTStocksTheme, kCPTPlainBlackTheme
    
    // Provide enough padding on the bottom to allow us to show the X axis labels and
    // a title beneath.  See configureAxes: axisSet.xAxis.titleOffset
    //
    graph.paddingBottom = 60.0f;
    
    // Padding between left side of hostView and border.  Leave room for y axis labels
    //and a title to the left.
    graph.paddingLeft  = 100.0f;
    
    graph.paddingTop    = 50.0; // -1.0f; // Use negative padding to hide border
    graph.paddingRight  = 30.0; // -5.0f; // Use negative padding to hide border
    
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    
    // 4 - Set up title
    NSString *title = @"Rolls of 2 dice";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 30.0f); // -y displacement moves title down a little more from border.
    
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xLength = XAxisLength;
    CGFloat yMin = 0.0f;
    
    CGFloat yLength = (CGFloat)(self.maxCount * YAxisStretchFactor);  // Leave room for annotations without overlap with plot.
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xLength)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yLength)];
}

-(void)configurePlots {
    // 1 - Set up plot
    self.rollPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    self.rollPlot.identifier = @"ROLL";
    
    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5; // Border line width around bars
    
    // 3 - Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = BarInitialX;
    NSArray *plots = @[self.rollPlot];
    
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(BarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += BarWidth;
    }
}

-(void)configureAxes {
    // 1 - Configure styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
    
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor blackColor];
    gridLineStyle.lineWidth = 1.0f;
    
    
    // 2 - Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    // 3 - Configure the x-axis
    CPTAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone; // Set to None to allow us to use custom labels.
    x.title = @"Roll counts (2-12)";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 30.0f; // Shift title down to allow room for X axis labels.
    x.axisLineStyle = axisLineStyle;
    
    
    // ----- For custom x axis labels -----
    //
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    
    x.majorTickLength = 4.0f;  // Length of tick from X axis
    
    // CPTSignNegative: Label below axis.  Tick doesn't show (just space)
    // CPTSignNone:     Label below axis.  Tick shows above axis (not too useful)
    // CPTSignPositive: Label above axis (on top of tick).  Tick shows above axis.
    x.tickDirection = CPTSignNegative;
    
    
    CGFloat hostViewWidth = self.hostView.bounds.size.width;
    CGFloat graphWidth = hostViewWidth - self.hostView.hostedGraph.paddingLeft - self.hostView.hostedGraph.paddingRight;
    CGFloat recordWidth = graphWidth/11.0;
    CGFloat barCenterLeftOffset = recordWidth * BarInitialX;
    
    
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:11];    // 2-12
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:11]; // 2-12
    
    NSInteger locIndex = 0; // Start labeling with first record.
    
    for(NSInteger count = 2; count <= 12; count ++){
        NSString *labelStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        
        // Using initWithContentLayer (instead of initWithText:textStyle:) is more flexible with layout and
        // allows us to finely position the label.
        //
//        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:labelStr textStyle:x.labelTextStyle];
        
        
        
        // Use axisTextStyle & initWithText:   The alternative initWithAttributedText: is below.
        //
        CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:labelStr  style:axisTextStyle];
        
        
        
        // Use an Attributed string for more power.  Note that the width of the attributed string
        // is less than that of the encompassing CPTTextLayer that we initializs with this string.
        //
        // http://www.raywenderlich.com/50151/text-kit-tutorial
        //
//        UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//        
//        UIColor* textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
//        NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
//                                 NSFontAttributeName : font };
//                                 // NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
//        
//        NSAttributedString* attrString = [[NSAttributedString alloc]
//                                          initWithString:labelStr
//                                          attributes:attrs];
//        
//        //NLOG("attrString size width = %f",[attrString size].width)
//        
//        CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithAttributedText:attrString];
        
        
        
        CGSize textSize = [textLayer sizeThatFits];
        
        
        // Calculate the padding needed to center the label under the plot record.
        textLayer.paddingLeft = barCenterLeftOffset - textSize.width/2.0;
        
        
        
        
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithContentLayer:textLayer];
        
        
        
        CGFloat location = locIndex++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = 4.0; // Spacing of label from X axis
        
        label.alignment = CPTTextAlignmentLeft; // CPTTextAlignmentCenter; // CPTTextAlignmentLeft;
        
        
        
        
        
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;    
    x.majorTickLocations = xLocations;
    
    
    
    // 4 - Configure the y-axis
    CPTAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.title = @"# of rolls with count";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -60.0f;  // Shift title to the left to allow room for Y axis labels.
    y.axisLineStyle = axisLineStyle;
    
    
    
    
    // ----- For custom y axis labels -----
    //

    y.majorGridLineStyle = gridLineStyle;
    
    y.labelTextStyle = axisTextStyle;
    
    y.labelOffset = 30.0f; // Positive value shifts labels to left of Y axis
    
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    

    // Need to calculate major and minor increments. Need to make sure:
    // 1. majorIncrement, minorIncrement have a minimum value > 0.
    // 2. majorIncrement is a multiple of minorIncrement
    //
    
    NSInteger minorIncrement = self.maxCount/30;  // Use approx 30 minor ticks if possible.
    
    if(minorIncrement < 1){
        minorIncrement = 1;
    }
    
    // We calculate majorIncrement last to ensure it is a perfect integer multiple of minorIncrement
    NSInteger majorIncrement = minorIncrement * 4;
    
    
    CGFloat yMax = (CGFloat)self.maxCount;
    
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        
        // Need to handle case of small numbers where majorIncrement < maxCount.
        // We will take of this case by annotating the minor increment.
        //
        if ((mod == 0) || (self.maxCount < majorIncrement)) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
    
    
}


-(void)hideAnnotation:(CPTGraph *)graph {
    if (graph.plotAreaFrame.plotArea) {
        for (CPTPlotSpaceAnnotation *annotation in self.annotationMutableArr) {
            [graph.plotAreaFrame.plotArea removeAnnotation:annotation];
        }
        
        [self.annotationMutableArr removeAllObjects];
    }
}


- (void)showAllAnnotations
{
    for(NSUInteger index=0; index <=10; index++) { // counts 2-12
        [self showAnnotation:self.rollPlot recordIndex:index reuseAnnotation:NO];
    }
    
}


// Show a single annotation.
//
// If reuseAnnotation = YES, there is only one active annotation at a time.  This is used by
// CPTBarPlotDelegate delegate method:
// barPlot:barWasSelectedAtRecordIndex:
//
- (void)showAnnotation:(CPTBarPlot *)plot
           recordIndex:(NSUInteger)index
       reuseAnnotation:(BOOL)reuseAnnotation
{
    // 1 - Is the plot hidden?
    if (plot.isHidden == YES) {
        return;
    }
    
    // 2 - Create style, if necessary
    static CPTMutableTextStyle *style = nil;
    if (!style) {
        style = [CPTMutableTextStyle textStyle];
        style.color= [CPTColor yellowColor];
        style.fontSize = 10.0f;
        style.fontName = @"Helvetica-Bold";
    }
    
    // 3 - Create annotation, if necessary
    //
    // If reuseAnnotation == YES, we only create annoation if self.annotationMutableArr is nil.
    //
    CPTPlotSpaceAnnotation *annotation;
    

    
    if(reuseAnnotation && ([self.annotationMutableArr count] > 0)){
        annotation = [self.annotationMutableArr firstObject];
    }
    else {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        
        annotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
        [self.annotationMutableArr addObject:annotation];
    }
    

    
    // 4 - Create number formatter, if needed
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        
        // Exactly 2 digits after decimal point
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        
        [formatter setMinimumIntegerDigits:1]; // Min of 1 digit before decimal point
        
        // Use a space for positive prefix to make numbers align better vertically with negative numbers.
        // [formatter setPositivePrefix:@" "];
    }
    
    // 5 - Create text layer for annotation
    //
    // Note: Currently only supporting single plot.
    
    NSNumber *countNum = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];
    NSInteger count = [countNum integerValue];
    
    // index ranges 0-10, shift to get result for 2-12
    NSArray *calculatedArrPercentagesArr = [[NSArray alloc] initWithArray:self.dataForAlgorithm[@"calculatedArrPercentages"]];
    CGFloat percentageCalculated = [calculatedArrPercentagesArr[index + 2] doubleValue];

    CGFloat percentageRandom = (CGFloat)count/(CGFloat)self.numTrials;
    CGFloat percentageDifference = (percentageCalculated - percentageRandom)/percentageCalculated;
    
    NSString *percentageCalculatedStr = [formatter stringFromNumber:[NSNumber numberWithDouble:(percentageCalculated * 100.0)]];
    NSString *percentageRandomStr = [formatter stringFromNumber:[NSNumber numberWithDouble:(percentageRandom * 100.0)]];
    NSString *percentageDifferenceStr = [formatter stringFromNumber:[NSNumber numberWithDouble:(percentageDifference * 100.0)]];
    
    NSString *annotationStr = [NSString stringWithFormat:@"%ld\nC:%@%%\nR:%@%%\nD:%@%%",(long)count, percentageCalculatedStr, percentageRandomStr, percentageDifferenceStr];
    
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:annotationStr style:style];
    annotation.contentLayer = textLayer;
    
    
    
    // 6 - Get plot index.  No need to do so based on identifier - we only have one plot currently.
    NSInteger plotIndex = 0;
    
    
    // 7 - Get the anchor point for annotation.
    //
    // Annotation is centered around x
    CGFloat x = index + BarInitialX + (plotIndex * BarWidth);
    
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    
    // Get the height of the graph area
    CGFloat hostViewHeight = self.hostView.bounds.size.height;
    CGFloat graphHeight = hostViewHeight - self.hostView.hostedGraph.paddingTop - self.hostView.hostedGraph.paddingTop;
    
    // Calculate the height of the text annotation
    CGFloat textHeight = [textLayer sizeThatFits].height;
    
    // By default the text is centered vertically around the anchor point.  We want to position the anchor point above the
    // top of the bar graph.   To do this we get half of the text height and determine the percentage this represents
    // of the graph height.  We then multiply by the Y axis length (self.maxCount * YAxisStretchFactor) to translate this
    // into a Y coordinate value.
    CGFloat textOffset = textHeight/2/graphHeight * self.maxCount * YAxisStretchFactor;
    
    
    
    CGFloat y = [countNum floatValue] + textOffset;
    //NLOG("viewHeight=%f countNum=%@ maxCount=%d hostViewHeight=%f graphHeight=%f textHeight=%f textOffset=%f  y=%f",self.bounds.size.height, countNum, self.maxCount, hostViewHeight, graphHeight, textHeight, textOffset, y)
    
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    
    annotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    
    
    // 8 - Add the annotation
    [plot.graph.plotAreaFrame.plotArea addAnnotation:annotation];

}


@end













