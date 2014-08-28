//
//  AlgorithmView.h
//  Algorithms
//
//  Created by Scott Carter on 8/22/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"


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

@protocol DataDelegate <NSObject>

- (NSDictionary *)dataForAlgorithmInputs:(NSDictionary *)inputs;

@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Public Interface
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@interface AlgorithmView : UIView



// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

@property (nonatomic, weak) id <DataDelegate> dataDelegate;



// ==========================================================================
// Class method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Class methods declarations

// None


// ==========================================================================
// Instance method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Instance method declarations

- (void)algorithmViewWillRotate;
- (void)runAlgorithm;
- (void)updateAlgorithmDisplay;



@end










