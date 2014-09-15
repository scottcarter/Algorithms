//
//  DetailViewController.m
//  Algorithms
//
//  Created by Scott Carter on 8/15/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "DetailViewController.h"

#import "Project.h"

//#import "MasterViewController.h"

#import "AppDelegate.h"


// Base class for different algorithm views
#import "AlgorithmView.h"

// Interface to algorithm models
#import "AlgorithmModelInterface.h"

#import "ShowCodeViewController.h"
#import "AboutViewController.h"


#import <MessageUI/MessageUI.h>

#import "KxMenu.h"


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
@interface DetailViewController () <ViewDataDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate, AboutPopoverDelegate>

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
@property (strong, nonatomic) NSString *algorithmLabel;
@property (strong, nonatomic) NSString *about;

// A pointer to current algorithm view
@property (strong, nonatomic) UIView *currentAlgorithmView;



// An dictionary of our algorithm views, loaded on demand.
@property (strong, nonatomic) NSMutableDictionary *algorithmViewsMutableDict;



@property (weak, nonatomic) IBOutlet UIBarButtonItem *aboutButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showHeaderButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showImplementationButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *emailCodeButton;


@property (strong, nonatomic) ShowCodeViewController *codeViewController;
@property (strong, nonatomic) AboutViewController *aboutViewController;

@property (strong, nonatomic) UIPopoverController *codeViewPopover;
@property (strong, nonatomic) UIPopoverController *aboutViewPopover;


// File lists for current algorithm
@property (strong, nonatomic) NSArray *headerFiles;
@property (strong, nonatomic) NSArray *implementationFiles;

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




// Reference:
// http://www.appcoda.com/ios-programming-create-email-attachment/
//
- (IBAction)emailCodeAction:(UIBarButtonItem *)sender {
    
    NSString *emailTitle = [NSString stringWithFormat:@"C++ code for selection in %@",self.algorithmLabel];
    NSString *messageBody = [NSString stringWithFormat:@"The C++ code that you requested for selection in %@ is attached.",self.algorithmLabel];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    NSString *mimeType = @"text/example";
    
    
    // Get an array of all header and implementation files.
    NSArray *allCodeFiles = [self.headerFiles arrayByAddingObjectsFromArray:self.implementationFiles];
    
    for (NSString *fileNameBase in allCodeFiles) {
        
        // Get the resource path and read the file using NSData
        NSString *codePath = [[NSBundle mainBundle] pathForResource:fileNameBase ofType:@"txt"];
        NSData *codeData = [NSData dataWithContentsOfFile:codePath];
        
        // Add attachment
        [mc addAttachmentData:codeData mimeType:mimeType fileName:fileNameBase];
    }
    
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}



// ==========================================================================
// Initializations
// ==========================================================================
//
#pragma mark -
#pragma mark Initializations

- (void)dealloc
{
    NSLog(@"!!! dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


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
    
    
    // Toolbar buttons initially disabled.
    [self disableToolbarButtons];
    
    // Show Header button brings up a menu.
    self.showHeaderButton.action = @selector(showHeaderMenu:);
    self.showHeaderButton.target = self;
    
    // Show Implementation button brings up a menu.
    self.showImplementationButton.action = @selector(showImplementationMenu:);
    self.showImplementationButton.target = self;

    
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
    
    
    // Code Set change notification
    //
    // Register for notifications for when a view has executed didMoveToSuperview: (fully loaded, visible)
    // or changed a configuration which affects the selection of which code will be executed.
    // Ex: A picker in the view may allow execution of code in different sets of files.
    //
    // We will use this notification to update the menus for the buttons Show Header, Show Implementation
    //
    // The notification will contain optional configuration information (picker selection, etc) as needed.
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(codeSetChangeNotification:)
                                                 name:CodeSetChangeNotification
                                               object:nil];

    
    // Load our first algorithm by default.
    [self setupAlgorithmForName:[self firstAlgorithmName] label:[self firstAlgorithmLabel] about:[self firstAlgorithmAbout]];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Note for subviews that use CPTGraphHostingView:
    //
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


// A sub view is notifying us that it has either fully loaded or has changed a
// configuration setting that affect the code set to be used.
//
- (void)codeSetChangeNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = (NSDictionary *)notification.userInfo;
    
    self.headerFiles = [AlgorithmModelInterface headerFilesForAlgorithmName:self.algorithmName config:userInfo];
    
    self.implementationFiles = [AlgorithmModelInterface implementationFilesForAlgorithmName:self.algorithmName config:userInfo];
    
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


#pragma mark ViewDataDelegate

- (NSDictionary *)viewDataForAlgorithmInputs:(NSDictionary *)inputs
{
    return [AlgorithmModelInterface viewDataForAlgorithmName:self.algorithmName inputs:inputs];
}


- (NSDictionary *)viewSetupInformation
{
    return [AlgorithmModelInterface viewSetupInfoForAlgorithmName:self.algorithmName];
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
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        self.currentAlgorithmView.alpha = 0.0;
                        
                        [self.algorithmView layoutIfNeeded];
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView transitionWithView:self.view
                                          duration:1.0
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            
                                            // This will trigger didMoveToSuperview in subview.
                                            [self.algorithmView addSubview:view];
                                            
                                            [self.algorithmView layoutIfNeeded];
                                            
                                        } completion:^(BOOL finished) {
                                            
                                            // This will also trigger didMoveToSuperview in subview.
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
    self.showHeaderButton.enabled = NO;
    self.showImplementationButton.enabled = NO;
    self.emailCodeButton.enabled = NO;
}

- (void)enableToolbarButtons
{
    self.aboutButton.enabled = YES;
    self.showHeaderButton.enabled = YES;
    self.showImplementationButton.enabled = YES;
    self.emailCodeButton.enabled = YES;
}


- (void)dismissCodePopover
{
    [self.codeViewPopover dismissPopoverAnimated:YES];
    
    [self enableToolbarButtons];
}


// Note:
// In order to get runtime read access to a file, it must be included in the Resource Bundle.
// For .mm or .cpp files, as soon as they are added to the Resource Bundle, they are automatically added
// to Target Membership of our app.   What gets copied upon installation
// is the corresponding object file, not the .mm or .cpp file itself.
//
// In order to get runtime access to selected header and implementation files, we create links in
// a Source subdirectory to our source file using the filename with .txt appended.  These links are then
// added to the Resource Bundle.  The links are useful as we do not then need to keep 2 copies
// of the same source file (one for compiling and one with a .txt extension for reading).
//
// Upon installation, the links are resolved into text files which
// can then be read by the app at runtime.
//
//
- (void)showCodePopover:(NSString *)fileNameBase
             button:(UIBarButtonItem *)button
{
    [self disableToolbarButtons];
    
    NSString *codePath = [[NSBundle mainBundle] pathForResource:fileNameBase ofType:@"txt"];
    NSString *code = [NSString stringWithContentsOfFile:codePath encoding:NSUTF8StringEncoding error:NULL];
    
    // Code needs to be suitable for insertion in HTML
    code = [code stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    code = [code stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    code = [code stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    code = [code stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    
    [self.codeViewController setCode:code];
    
    
    [self.codeViewPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}



// Fetch the first algorithm method label
- (NSString *)firstAlgorithmLabel
{
    return self.appDelegate.algorithmDatabase[0][@"algorithms"][0][@"algorithmLabel"];
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


// Reference:
// https://github.com/kolyvan/kxmenu
//
// Search for "Scott" in KxMenu.m for my updates.
//
- (void)showHeaderMenu:(UIBarButtonItem *)sender
{
    
    NSMutableArray *menuItemsMutableArr = [[NSMutableArray alloc] init];
    
    [menuItemsMutableArr addObject:[KxMenuItem menuItem:@"Select file "
                                        image:nil
                                       target:nil
                                       action:NULL]];
    
    
    for (NSString *file in self.headerFiles) {
        [menuItemsMutableArr addObject:[KxMenuItem menuItem:file
                                            image:nil
                                           target:self
                                           action:@selector(showHeader:)]];
    }
    
    NSArray *menuItems = [NSArray arrayWithArray:menuItemsMutableArr];
    
    
    // Highlight the first title item
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:0/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    
    // Can't get the barButton frame directly.
    // Reference:
    // http://stackoverflow.com/questions/14318368/uibarbuttonitem-how-can-i-find-its-frame
    UIView *buttonView = (UIView *)[sender performSelector:@selector(view)];
    
    // Alternative approach
    //UIView *buttonView = [sender valueForKey:@"view"];
    
    
    // Get the frame of the button and shift it down a little for the menu view reference.
    CGRect menuReferenceRect =  CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y, buttonView.frame.size.width, buttonView.frame.size.height + 60.0);
    
    [KxMenu showMenuInView:self.view
                  fromRect:menuReferenceRect
                 menuItems:menuItems];
    
}



- (void)showHeader:(KxMenuItem *)menuItem
{
    if([self.codeViewPopover isPopoverVisible]){
        [self dismissCodePopover];
        return;
    }
    
    [self showCodePopover:menuItem.title button:self.showHeaderButton];
}



- (void)showImplementationMenu:(UIBarButtonItem *)sender
{
    NSMutableArray *menuItemsMutableArr = [[NSMutableArray alloc] init];
    
    [menuItemsMutableArr addObject:[KxMenuItem menuItem:@"Select file "
                                                  image:nil
                                                 target:nil
                                                 action:NULL]];
    
    
    for (NSString *file in self.implementationFiles) {
        [menuItemsMutableArr addObject:[KxMenuItem menuItem:file
                                                      image:nil
                                                     target:self
                                                     action:@selector(showImplementation:)]];
    }
    
    NSArray *menuItems = [NSArray arrayWithArray:menuItemsMutableArr];
    
    
    // Highlight the first title item
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:0/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    
    UIView *buttonView = (UIView *)[sender performSelector:@selector(view)];
    
    
    // Get the frame of the button and shift it down a little for the menu view reference.
    CGRect menuReferenceRect =  CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y, buttonView.frame.size.width, buttonView.frame.size.height + 60.0);
    
    [KxMenu showMenuInView:self.view
                  fromRect:menuReferenceRect
                 menuItems:menuItems];
    

}


- (void)showImplementation:(KxMenuItem *)menuItem
{
    if([self.codeViewPopover isPopoverVisible]){
        [self dismissCodePopover];
        return;
    }
    
    [self showCodePopover:menuItem.title button:self.showImplementationButton];
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

- (void)setupAlgorithmForName:(NSString *)name
                        label:(NSString *)label
                        about:(NSString *)about
{
    self.algorithmName = name;
    self.algorithmLabel = label;
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
    
    
    // Add ourselves as the delegate to handle data requests from current algorithm view.
    //
    // Note:  It is critical that we do this before adding newView as subView.
    //        Why?  Because loading the subview will eventually trigger a call to runAlgorithm in the subview
    //              which requires that the delegate is setup.
    [(AlgorithmView *)newView setViewDataDelegate:self];
    
    
    self.title = self.algorithmLabel;
    
    
    // If we have not previously setup a view, add one here.  We don't do this in changeToAlgorithmView:
    // since that routine expects that there is already a loaded view in self.currentAlgorithmView.
    if(!self.currentAlgorithmView){
        
        self.currentAlgorithmView = newView;
        
        // This will trigger didMoveToSuperview in subview.
        [self.algorithmView addSubview:newView];
        
        [self.algorithmView layoutIfNeeded];
        
        [self enableToolbarButtons];
        
        return;
    }
    
    
    // Swap in the newly selected view
    [self changeToAlgorithmView:newView];
    

}





// ==========================================================================
// C methods
// ==========================================================================
//


#pragma mark -
#pragma mark C methods





@end














