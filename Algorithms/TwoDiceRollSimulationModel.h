//
//  TwoDiceRollSimulationModel.h
//  Algorithms
//
//  Created by Scott Carter on 8/22/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#ifndef __Algorithms__TwoDiceRollSimulationModel__
#define __Algorithms__TwoDiceRollSimulationModel__


#include "AlgorithmModel.h"

class TwoDiceRollSimulationModel : public AlgorithmModel
{
public:
    void dataForAlgorithm(int numTrials,
                          int* randomArrCounts,
                          double* calculatedArrPercentages);
    
private:
    
    void randomTrials(int numTrials,
                      int* result);
    void calculatedTrials(int numTrials,
                          double* result);
    
};



#endif /* defined(__Algorithms__TwoDiceRollSimulationModel__) */
