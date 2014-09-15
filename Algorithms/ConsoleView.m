//
//  ConsoleView.m
//  Algorithms
//
//  Created by Scott Carter on 8/29/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "ConsoleView.h"

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
@interface ConsoleView () <UIPickerViewDataSource, UIPickerViewDelegate>

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties


@property (weak, nonatomic) IBOutlet UIPickerView *runSelectionPicker;

@property (strong, nonatomic) NSDictionary *runSelectionDict;

@property (nonatomic) NSInteger lastRunSelection;

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation ConsoleView

// ==========================================================================
// Constants and Defines
// ==========================================================================
//
#pragma mark -
#pragma mark Constants and Defines

// None


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

// None


// ==========================================================================
// Actions
// ==========================================================================
//
#pragma mark -
#pragma mark Actions


- (IBAction)runAction:(UIButton *)sender {
    [self runAlgorithm];
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
    
    self.runSelectionPicker.dataSource = self;
    self.runSelectionPicker.delegate = self;
    
    self.lastRunSelection = -1; // Mark as not yet having been processed.
    
}

- (void)dealloc
{
    NSLog(@"!!! dealloc");
}


// Called when we have been added to or removed from a super view.
//
// This is the earliest time that we would wish to call setupInterface/runAlgorithm to ensure that our
// viewDataDelegate property inherited from AlgorithmView is setup.
//
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    
    // If we have been removed from a super view, do nothing.
    if(!self.superview){
        return;
    }
    
    [self setupInterface]; // Get setup information for this view
    
    [self.runSelectionPicker reloadAllComponents]; // Now we can re-init the picker
    
    [self.runSelectionPicker selectRow:0 inComponent:0 animated:NO];
    
    
    // Notify any listeners that we are loaded.
    [[NSNotificationCenter defaultCenter] postNotificationName:CodeSetChangeNotification object:self userInfo:@{@"row":@(0)}];
    
    
    [self runAlgorithm]; // Run algorithm with info from picker.
}


// ==========================================================================
// Protocol methods
// ==========================================================================
//
#pragma mark -
#pragma mark Protocol methods

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.runSelectionDict count];
}


#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.runSelectionDict objectForKey:[NSNumber numberWithInt:(int)row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    // Notify any listeners that our configuration changed.
    [[NSNotificationCenter defaultCenter] postNotificationName:CodeSetChangeNotification object:self userInfo:@{@"row":@(row)}];
    
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


- (void)setupInterface
{
    self.textView.editable = NO;
    
    self.textView.text = @"";
    
    // Key = integer value  object = label
    self.runSelectionDict = [self.viewDataDelegate viewSetupInformation];
}


// Gather input data, ask our delegate for model output.
- (void)runAlgorithm
{
    // Only one component in our picker.  Get the row index and use as our runSelection
    //
    NSInteger runSelection = [self.runSelectionPicker selectedRowInComponent:0];
    
    // If we didn't want to allow consecutive runs of same algorithm, then
    // uncomment the following.
//    if(runSelection == self.lastRunSelection){
//        return;
//    }
    
    self.lastRunSelection = runSelection;
    
    NSDictionary *dataForAlgorithm = [self.viewDataDelegate viewDataForAlgorithmInputs:@{@"runSelection":[NSNumber numberWithInteger:runSelection] }];
    
    NSString *consoleOutput = dataForAlgorithm[@"consoleOutput"];
    
    self.textView.text = [self.textView.text stringByAppendingString:consoleOutput];
    self.textView.text = [self.textView.text stringByAppendingString:@"\n\n\n\n"];
    
    
    
//    // Scroll to bottom
//    NSRange range = NSMakeRange([self.textView.text length] - 1, 1);
//    [self.textView scrollRangeToVisible:range];
//    
    // Alternate method
//    CGRect rect = self.textView.bounds;
//    [self.textView scrollRectToVisible:rect animated:YES];
    
    
    // Following avoids a jump to the top before scrolling to the bottom.
    //
    // Reference: http://stackoverflow.com/questions/19124037/scroll-to-bottom-of-uitextview-erratic-in-ios-7
    //
    [self.textView setScrollEnabled:NO];
    [self.textView scrollRangeToVisible:NSMakeRange([self.textView.text length], 0)];
    [self.textView setScrollEnabled:YES];
    

    
}






@end








