//
//  AboutViewController.h
//  Algorithms
//
//  Created by Scott Carter on 8/27/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import <UIKit/UIKit.h>



// FIXME: None
// TODO: None
#pragma mark -

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Forward Declarations
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark Forward Declarations

// None


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Protocols
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
#pragma mark Protocols

@protocol AboutPopoverDelegate <NSObject>

- (void)dismissAboutPopover;

@end


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Public Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@interface AboutViewController : UIViewController



// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark  Properties

@property (strong, nonatomic) NSString *text;

@property (weak, nonatomic) id <AboutPopoverDelegate> aboutPopoverDelegate;


// ==========================================================================
// Class method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Class method declarations

// None


// ==========================================================================
// Instance method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Instance method declarations

// None

@end

