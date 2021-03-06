//
//  AlgorithmModelInterface.h
//  Algorithms
//
//  Created by Scott Carter on 8/22/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import <Foundation/Foundation.h>


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
@interface AlgorithmModelInterface : NSObject



// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark  Properties

// None


// ==========================================================================
// Class method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Class method declarations

+ (NSArray *)headerFilesForAlgorithmName:(NSString *)algorithmName config:(NSDictionary *)config;

+ (NSArray *)implementationFilesForAlgorithmName:(NSString *)algorithmName config:(NSDictionary *)config;



+ (NSDictionary *)viewDataForAlgorithmName:(NSString *)algorithmName inputs:(NSDictionary *)inputs;

+ (NSDictionary *)viewSetupInfoForAlgorithmName:(NSString *)algorithmName;



// ==========================================================================
// Instance method declarations
// ==========================================================================
//
#pragma mark -
#pragma mark Instance method declarations

// None

@end

