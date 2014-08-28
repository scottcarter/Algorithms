//
//  AlgorithmModelInterface.mm
//  Algorithms
//
//  Created by Scott Carter on 8/22/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "AlgorithmModelInterface.h"

#import "AlgorithmModel.h"
#import "TwoDiceRollSimulationModel.h"


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
@interface AlgorithmModelInterface ()

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

// None

@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation AlgorithmModelInterface

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

// None


// ==========================================================================
// Protocol methods
// ==========================================================================
//
#pragma mark -
#pragma mark Protocol methods

// None


// ==========================================================================
// Class methods
// ==========================================================================
//
#pragma mark -
#pragma mark Class methods


// This method is responsible for getting data from the appropriate algorithm model
//
+ (NSDictionary *)dataForAlgorithmName:(NSString *)algorithmName inputs:(NSDictionary *)inputs
{
    
    AlgorithmModel* model = NULL;
    NSDictionary *data;
    
    if([algorithmName isEqualToString:@"TwoDiceRollSimulation"]){
        model = new TwoDiceRollSimulationModel();
        data = exerciseChap2Num7Model((TwoDiceRollSimulationModel*)model, inputs);
    }
    
    assert(model != NULL);  // Unhandled algorithm
    
    delete model;
    return data;
}



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


NSDictionary* exerciseChap2Num7Model(TwoDiceRollSimulationModel* model, NSDictionary* inputs)
{
    NSInteger numTrials = [(NSNumber *)inputs[@"numTrials"] integerValue];
    
    // http://stackoverflow.com/questions/629017/how-does-array100-0-set-the-entire-array-to-0
    //
    int randomArrCounts[13] = {};  // Initialize array elements 0-12 to zeroes.
    
    double calculatedArrPercentages[13];
    calculatedArrPercentages[0] = 0.0;
    calculatedArrPercentages[1] = 0.0;
    
    
    // Call the model for data
    model->dataForAlgorithm((int)numTrials, randomArrCounts, calculatedArrPercentages);
    
    
    // Bundle up our results
    //
    NSMutableArray *randomArrCountsMutableArr = [[NSMutableArray alloc] init];
    NSMutableArray *calcultedArrPercentagesMutableArr = [[NSMutableArray alloc] init];
    
    for(int i=0; i<13; i++){
        randomArrCountsMutableArr[i] = [NSNumber numberWithInteger:randomArrCounts[i]];
        calcultedArrPercentagesMutableArr[i] = [NSNumber numberWithDouble:calculatedArrPercentages[i]];
    }
    
    NSMutableDictionary *resultMutableDict = [[NSMutableDictionary alloc] init];
    resultMutableDict[@"randomArrCounts"] = [NSArray arrayWithArray:randomArrCountsMutableArr];
    resultMutableDict[@"calculatedArrPercentages"] = [NSArray arrayWithArray:calcultedArrPercentagesMutableArr];
    
    
    return [NSDictionary dictionaryWithDictionary:resultMutableDict];
}



@end









