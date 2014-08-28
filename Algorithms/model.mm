//
//  ExerciseChap2Num7Model.mm
//  Algorithms
//
//  Created by Scott Carter on 8/22/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#include "ExerciseChap2Num7Model.h"



// Page 53
//
// Simulate the roll of 2 dice numTrial times.
//
// Return the result as a dictionary where the key is a number from 2 to 12 and the value is the number of times we
// saw a particular sum.
//
NSDictionary* ExerciseChap2Num7Model::dataForAlgorithm()
{
    NSInteger numTrials = [(NSNumber *)inputsDict[@"numTrials"] integerValue];
    
    
    // Get random and calculated results
    //
    
    // http://stackoverflow.com/questions/629017/how-does-array100-0-set-the-entire-array-to-0
    //
    int randomArrCounts[13] = {};  // Initialize array elements 0-12 to zeroes.
    randomTrials(numTrials, randomArrCounts);

    
    double calculatedArrPercentages[13];
    calculatedTrials(numTrials, calculatedArrPercentages);

    
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
    
    
    NSDictionary *resultDict = [NSDictionary dictionaryWithDictionary:resultMutableDict];

    return resultDict;
}


void ExerciseChap2Num7Model::randomTrials(int numTrials, int* arr)
{
    // Seed our random number generator
    srandom(1);
    
    // Execute numTrials times.  Bucket the results.
    for(int i=0; i<numTrials; i++){
        long dice1 = (random() % 6) + 1; // 1-6
        long dice2 = (random() % 6) + 1; // 1-6
        
        arr[dice1 + dice2]++;
    }
    
}


void ExerciseChap2Num7Model::calculatedTrials(int numTrials, double* result)
{
    // There are 6 x 6 combinations.  Cycle through each and bucket the counts.
    int arrCounts[13] = {};
    
    int numCombos = 0;
    for(int dice1=1; dice1<=6; dice1++){
        for(int dice2=1; dice2<=6; dice2++){
            arrCounts[dice1+dice2]++;
            numCombos++;
        }
    }
    
    // Calculate the percentages
    for(int i=2; i<=12; i++){
        result[i] = (double)arrCounts[i]/(double)numCombos;
    }
    
    // We don't use indices 0, 1.  Initialize them to 0.0
    result[0] = 0.0;
    result[1] = 0.0;
    
    
}








