//
//  MasterViewController.m
//  Algorithms
//
//  Created by Scott Carter on 8/15/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "AppDelegate.h"


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
@interface MasterViewController ()




// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) DetailViewController *detailViewController;


@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation MasterViewController

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

// None



// ==========================================================================
// Initializations
// ==========================================================================
//
#pragma mark -
#pragma mark Initializations

// awakeFromNib is called when the controller itself is unarchived from a nib. viewDidLoad is called
// when the view is created/unarchived. This distinction is especially important when the controller's
// view is stored in a separate nib file.
//  http://stackoverflow.com/questions/377202/which-should-i-use-awakefromnib-or-viewdidload
//
- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}


- (void)dealloc
{
    NSLog(@"!!! dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
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


#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Get dictionary for section and lookup section name corresponding to "type" key
    return self.appDelegate.algorithmDatabase[section][@"sectionLabel"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.appDelegate.algorithmDatabase count];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    //return YES;
    return NO;
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}



#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Get dictionary for section and lookup array corresponding to "algorithms" key.  Count of array is number of algorithms.
    return [self.appDelegate.algorithmDatabase[section][@"algorithms"] count];
    
    // return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *algorithmLabel = self.appDelegate.algorithmDatabase[section][@"algorithms"][row][@"algorithmLabel"];
    cell.textLabel.text = algorithmLabel;
    
    
//    NSDate *object = _objects[indexPath.row];
//    cell.textLabel.text = [object description];
    
    return cell;
}




/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *algorithmName = self.appDelegate.algorithmDatabase[section][@"algorithms"][row][@"algorithmName"];
    NSString *about = self.appDelegate.algorithmDatabase[section][@"algorithms"][row][@"about"];
    
    [self.detailViewController setupAlgorithmForName:algorithmName about:about];
    
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

// None
                               

// ==========================================================================
// C methods
// ==========================================================================
//


#pragma mark -
#pragma mark C methods





@end
















