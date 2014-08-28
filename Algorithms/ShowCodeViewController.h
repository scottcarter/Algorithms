//
//  ShowCodeViewController.h
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

// None


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Public Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@interface ShowCodeViewController : UIViewController



// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark  Properties

@property (strong, nonatomic) NSString *code;


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

- (void)clearWebView;

@end

