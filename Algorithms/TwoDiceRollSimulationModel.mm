//
//  TwoDiceRollSimulationModel.mm
//  Algorithms
//
//  Created by Scott Carter on 8/22/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#include "TwoDiceRollSimulationModel.h"


// Simulate the roll of 2 dice, numTrial times.
//
// Return the result as arrays where the index is a number representing a 2 dice
// sum from 2 to 12.
//
// The randomArrCounts values are the number of times we saw a particular sum.
// Values for indices 0,1 set to 0 by caller.
//
// The calculatedArrPercentages values are the calculated expected percentages
// that we should see each sum. Values for indices 0,1 set to 0.0 by caller.
//
void TwoDiceRollSimulationModel::dataForAlgorithm(int numTrials,
                                              int* randomArrCounts,
                                              double* calculatedArrPercentages)
{
    randomTrials((int)numTrials, randomArrCounts);
    
    calculatedTrials((int)numTrials, calculatedArrPercentages);
}


vector<string> TwoDiceRollSimulationModel::headerFileList(void)
{
    vector<string> fileVec;
    
    fileVec.push_back("AlgorithmModel.h");
    fileVec.push_back("TwoDiceRollSimulationModel.h");
    
    return fileVec;
}

vector<string> TwoDiceRollSimulationModel::implementationFileList(void)
{
    vector<string> fileVec;
    
    fileVec.push_back("AlgorithmModel.mm");
    fileVec.push_back("TwoDiceRollSimulationModel.mm");
    
    return fileVec;
}


void TwoDiceRollSimulationModel::randomTrials(int numTrials, int* arr)
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


void TwoDiceRollSimulationModel::calculatedTrials(int numTrials,
                                              double* result)
{
    // There are 6 x 6 combinations.  Cycle through each and
    // bucket the counts.
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
    
}








