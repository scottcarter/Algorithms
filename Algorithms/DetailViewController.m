//
//  DetailViewController.m
//  Algorithms
//
//  Created by Scott Carter on 8/15/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "DetailViewController.h"

//#import "MasterViewController.h"

#import "AppDelegate.h"


// Base class for different algorithm views
#import "AlgorithmView.h"

// Interface to algorithm models
#import "AlgorithmModelInterface.h"

#import "ShowCodeViewController.h"
#import "AboutViewController.h"


#import <MessageUI/MessageUI.h>




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
@interface DetailViewController () <DataDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate, AboutPopoverDelegate>

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

// The region that we draw into
@property (strong, nonatomic) IBOutlet UIView *algorithmView;



// Current algorithm name & about
@property (strong, nonatomic) NSString *algorithmName;
@property (strong, nonatomic) NSString *about;

// A pointer to current algorithm view
@property (strong, nonatomic) UIView *currentAlgorithmView;



// An dictionary of our algorithm views, loaded on demand.
@property (strong, nonatomic) NSMutableDictionary *algorithmViewsMutableDict;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *aboutButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *runButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showHeaderButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showImplementationButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *emailCodeButton;



@property (strong, nonatomic) ShowCodeViewController *codeViewController;
@property (strong, nonatomic) AboutViewController *aboutViewController;

@property (strong, nonatomic) UIPopoverController *codeViewPopover;
@property (strong, nonatomic) UIPopoverController *aboutViewPopover;

@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation DetailViewController

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

- (NSMutableDictionary *)algorithmViewsMutableDict
{
    if(!_algorithmViewsMutableDict){
        _algorithmViewsMutableDict = [[NSMutableDictionary alloc] init];
    }
    return _algorithmViewsMutableDict;
}



// ==========================================================================
// Actions
// ==========================================================================
//
#pragma mark -
#pragma mark Actions


- (IBAction)aboutAction:(UIBarButtonItem *)sender {
    [self disableToolbarButtons];
    
    [self.aboutViewController setText:self.about];
    
    [self.aboutViewPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

// Currently our algorithms are automatically run on
// initial load and input changes.
//
//- (IBAction)runAction:(UIBarButtonItem *)sender {
//    if([self.codeViewPopover isPopoverVisible]){
//        [self dismissCodePopover];
//        return;
//    }
//    
//    [self runAlgorithm];
//}


- (IBAction)showHeaderAction:(UIBarButtonItem *)sender {
    if([self.codeViewPopover isPopoverVisible]){
        [self dismissCodePopover];
        return;
    }

    NSString *fileNameBase = [NSString stringWithFormat:@"%@Model_h",self.algorithmName];
    [self showCodePopover:fileNameBase button:sender];
}


- (IBAction)showImplementationAction:(UIBarButtonItem *)sender {
    if([self.codeViewPopover isPopoverVisible]){
        [self dismissCodePopover];
        return;
    }

    NSString *fileNameBase = [NSString stringWithFormat:@"%@Model_mm",self.algorithmName];
    [self showCodePopover:fileNameBase button:sender];
}


// Reference:
// http://www.appcoda.com/ios-programming-create-email-attachment/
//
- (IBAction)emailCodeAction:(UIBarButtonItem *)sender {
    
    NSString *emailTitle = [NSString stringWithFormat:@"C++ code for %@",self.algorithmName];
    NSString *messageBody = [NSString stringWithFormat:@"The C++ code that you requested for %@ is attached.",self.algorithmName];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    NSString *mimeType = @"text/example";
    
    // Get the resource path and read the file using NSData
    NSString *fileNameBase = [NSString stringWithFormat:@"%@Model_h",self.algorithmName];
    NSString *codePath = [[NSBundle mainBundle] pathForResource:fileNameBase ofType:@"txt"];
    NSData *codeData = [NSData dataWithContentsOfFile:codePath];
    
    // Add attachment
    [mc addAttachmentData:codeData mimeType:mimeType fileName:[NSString stringWithFormat:@"%@.h",self.algorithmName]];
    
    
    // Repeat for .cpp file
    fileNameBase = [NSString stringWithFormat:@"%@Model_mm",self.algorithmName];
    codePath = [[NSBundle mainBundle] pathForResource:fileNameBase ofType:@"txt"];
    codeData = [NSData dataWithContentsOfFile:codePath];
    
    [mc addAttachmentData:codeData mimeType:mimeType fileName:[NSString stringWithFormat:@"%@.cpp",self.algorithmName]];
    

    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}



// ==========================================================================
// Initializations
// ==========================================================================
//
#pragma mark -
#pragma mark Initializations

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    // Update the algorithm display after an orientation change to update graphs, etc.
    [self updateAlgorithmDisplay];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // Automatically close popovers on rotation.
    
    if([self.codeViewPopover isPopoverVisible]){
        [self dismissCodePopover];
    }
    
    if([self.aboutViewPopover isPopoverVisible]){
        [self dismissAboutPopover];
    }

    // Notify our algorithm view that we are about to rotate.
    [self algorithmViewWillRotate];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Initiating popovers with button actions.
    //
//    // Display code in popover.
//    if([segue.destinationViewController isMemberOfClass:[ShowCodeViewController class]]) {
//        ShowCodeViewController *codeViewController = (ShowCodeViewController *)segue.destinationViewController;
//        // ...
//    }
//    
//    // Display about in popover
//    else if([segue.destinationViewController isMemberOfClass:[AboutViewController class]]) {
//        AboutViewController *aboutViewController = (AboutViewController *)segue.destinationViewController;
//        // ...
//    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.masterViewController = (MasterViewController *)[[self.splitViewController.viewControllers firstObject] topViewController];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    
    UIStoryboard *storyboard = self.storyboard;
    
    // Get an instance of ShowCodeViewController for popovers
    self.codeViewController = (ShowCodeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ShowCodeViewControllerID"];
    
    self.codeViewPopover = [[UIPopoverController alloc] initWithContentViewController:self.codeViewController];
    self.codeViewPopover.delegate = self;
    
    
    // Get an instance of AboutViewController for popovers
    self.aboutViewController = (AboutViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AboutViewControllerID"];
    self.aboutViewController.aboutPopoverDelegate = self;
    
    self.aboutViewPopover = [[UIPopoverController alloc] initWithContentViewController:self.aboutViewController];
    self.aboutViewPopover.delegate = self;
    
    
    // Load our first algorithm by default.
    [self setupAlgorithmForName:[self firstAlgorithmName]  about:[self firstAlgorithmAbout]];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Note:
    // At this point, the hostView (CPTGraphHostingView) of self.currentAlgorithmView
    // has a bounds that is not yet completely set.
    // On first layout for example, it may be 456.0, later settling to 500.0
    // (difference appears to be the height of the status bar).
    //
    // On a rotate, it may reflect the previous height prior to rotation.
    //
    // Instead of calling runAlgorithm/updateAlgorithmDisplay here, we do so in two places:
    // 1. Call updateAlgorithmDisplay from didRotateFromInterfaceOrientation: in this controller.
    // 2. Call runAlgorithm in the algorithm view as a result of the initial notification of a drawRect: of CPTGraphHostingView
    //
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ==========================================================================
// Protocol methods
// ==========================================================================
//
#pragma mark -
#pragma mark Protocol methods


#pragma mark MFMailComposeViewControllerDelegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark UIPopoverControllerDelegate


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self enableToolbarButtons];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    
    // Take the opportunity to clear out the code web view, so that when we switch
    // between header and implementation files we don't temporarily see the previous view
    // in transition.
    [self.codeViewController clearWebView];
    return YES;
}


#pragma mark Algorithm model interface

- (NSDictionary *)dataForAlgorithmInputs:(NSDictionary *)inputs
{
    return [AlgorithmModelInterface dataForAlgorithmName:self.algorithmName inputs:inputs];
}


#pragma mark AboutPopoverDelegate

- (void)dismissAboutPopover
{
    [self.aboutViewPopover dismissPopoverAnimated:YES];
    
    [self enableToolbarButtons];
}


#pragma mark Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
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



- (void)changeToAlgorithmView:(UIView *)view
{
    if(self.currentAlgorithmView == view){
        return;
    }
    
    
    [self disableToolbarButtons];
    
    
    // Properties that can be animated
    // https://developer.apple.com/library/ios/documentation/windowsviews/conceptual/viewpg_iphoneos/animatingviews/animatingviews.html
    //
    
    
    [UIView transitionWithView:self.currentAlgorithmView
                      duration:2.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        self.currentAlgorithmView.alpha = 0.0;
                        
                        [self.algorithmView layoutIfNeeded];
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView transitionWithView:self.view
                                          duration:2.0
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            [self.algorithmView addSubview:view];
                                            
                                            [self.algorithmView layoutIfNeeded];
                                            
                                        } completion:^(BOOL finished) {
                                            
                                            [self.currentAlgorithmView removeFromSuperview];
                                            self.currentAlgorithmView.alpha = 1.0;
                                            
                                            self.currentAlgorithmView = view;
                                            
                                            [self enableToolbarButtons];
                                        }];
                        
                        
                    }];
    
    
    
}


- (void)disableToolbarButtons
{
    self.aboutButton.enabled = NO;
    self.runButton.enabled = NO;
    self.showHeaderButton.enabled = NO;
    self.showImplementationButton.enabled = NO;
    self.emailCodeButton.enabled = NO;
}

- (void)enableToolbarButtons
{
    self.aboutButton.enabled = YES;
    self.runButton.enabled = YES;
    self.showHeaderButton.enabled = YES;
    self.showImplementationButton.enabled = YES;
    self.emailCodeButton.enabled = YES;
}


- (void)dismissCodePopover
{
    [self.codeViewPopover dismissPopoverAnimated:YES];
    
    [self enableToolbarButtons];
}


- (void)showCodePopover:(NSString *)fileNameBase
             button:(UIBarButtonItem *)button
{
    [self disableToolbarButtons];
    
    NSString *codePath = [[NSBundle mainBundle] pathForResource:fileNameBase ofType:@"txt"];
    NSString *code = [NSString stringWithContentsOfFile:codePath encoding:NSASCIIStringEncoding error:NULL];
    
    // Code needs to be suitable for insertion in HTML
    code = [code stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    code = [code stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    code = [code stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    code = [code stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    
    [self.codeViewController setCode:code];
    
    
    [self.codeViewPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}



// Fetch the first algorithm method name
- (NSString *)firstAlgorithmName
{
    return self.appDelegate.algorithmDatabase[0][@"algorithms"][0][@"algorithmName"];
}


// Fetch the first algorithm method name
- (NSString *)firstAlgorithmAbout
{
    return self.appDelegate.algorithmDatabase[0][@"algorithms"][0][@"about"];
}


#pragma mark Algorithm View Communication

- (void)algorithmViewWillRotate
{
    [self callAlgorithmMethod:@"algorithmViewWillRotate"];
}

- (void)runAlgorithm
{
    [self callAlgorithmMethod:@"runAlgorithm"];
}

- (void)updateAlgorithmDisplay
{
    [self callAlgorithmMethod:@"updateAlgorithmDisplay"];
}



// Helper method for Algorithm View Communication
- (void)callAlgorithmMethod:(NSString *)algorithmMethodName
{
    if(!self.currentAlgorithmView){
        ERROR_LOG(@"Algorithm not implemented for %@",self.title)
        return;
    }
    
    SEL algorithmSelector = NSSelectorFromString(algorithmMethodName);
    
    // http://stackoverflow.com/questions/2217560/getting-name-of-the-class-from-an-instance-in-objective-c
    //
    if(![self.currentAlgorithmView respondsToSelector:algorithmSelector]){
        ERROR_LOG("No such algorithm method %@ for %@",algorithmMethodName, NSStringFromClass([self.currentAlgorithmView class]))
        return;
    }
    
    
    // Disable warning on performSelector
    // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    //
    // We are ignoring the return value, so disabling warning on performSelector is always OK:
    //  http://stackoverflow.com/questions/8855461/did-the-target-action-design-pattern-became-bad-practice-under-arc
    //
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.currentAlgorithmView performSelector:algorithmSelector];
#pragma clang diagnostic pop
    
}




#pragma mark Algorithm Setup

- (void)setupAlgorithmForName:(NSString *)algorithmName about:(NSString *)about
{
    
    self.algorithmName = algorithmName;
    self.about = about;
    
    // Is XIB loaded?
    //
    if(!self.algorithmViewsMutableDict[self.algorithmName]){
        NSString *xib = [NSString stringWithFormat:@"%@View",self.algorithmName];
        
        NSArray *xibViewArr;
        
        
        // Let's make sure algorithm view has been implemented.
        @try {
            // This will trigger awakeFromNib in view we load.
            xibViewArr = [[NSBundle mainBundle] loadNibNamed:xib owner:self options:nil];
        }
        @catch (NSException *exception) {
            ERROR_LOG("Caught exception trying to load %@.xib",xib)
            return;
        }
        @finally {
            ;
        }
        
        
        // Originally used something such as the following (can't add UIView directly to NSArray):
        // (Adding weak pointer to object to Dictionary http://stackoverflow.com/questions/2992315/uiview-as-dictionary-key)
        //
        // self.algorithmViewsMutableDict[<name of XIB>] = [NSValue valueWithNonretainedObject:v]; // Where v is a UIView
        //
        // This is fine for the view that is currently added as a subview (should retain), but not for other
        // views from Nib files (not retained). According to loadNibNamed: docs  "You should retain either
        // the returned array or the objects it contains manually to prevent the nib file objects from being
        // released prematurely."
        //
        // Instead we will add the NSArray returned by loadNibNamed: and grab the UIView from NSArray when needed.
        //
        self.algorithmViewsMutableDict[self.algorithmName] = xibViewArr;

    }
    
    UIView *newView = (UIView *)[self.algorithmViewsMutableDict[self.algorithmName] firstObject];
    
    // Add default drawing view.
    if(!self.currentAlgorithmView){
        
        self.currentAlgorithmView = newView;
        
        // Add ourselves as the delegate to handle data requests from current algorithm view.
        //
        // Note:  It is critical that we do this before adding newView as subView.
        //        Why?  Because we rely on didMoveToSuperview in the subview to trigger and update
        //              which requires that the delegate is setup.
        [(AlgorithmView *)self.currentAlgorithmView setDataDelegate:self];
        
        // This will trigger didMoveToSuperview in subview.
        [self.algorithmView addSubview:newView];
    }
    
    // Swap in the newly selected view
    [self changeToAlgorithmView:newView];
    
    self.title = self.algorithmName;

}





// ==========================================================================
// C methods
// ==========================================================================
//


#pragma mark -
#pragma mark C methods





@end














