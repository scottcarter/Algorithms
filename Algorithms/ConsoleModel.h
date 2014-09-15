//
//  ConsoleModel.h
//  Algorithms
//
//  Created by Scott Carter on 8/29/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#ifndef __Algorithms__ConsoleModel__
#define __Algorithms__ConsoleModel__

#include <iostream>

using namespace std;


#include "AlgorithmModel.h"

class ConsoleModel : public AlgorithmModel
{
public:
    enum RunSelection {FindNegative, Hello2, Hello3};
    
    void dataForAlgorithm(RunSelection runSelection, string& output);
    
    void setupInfoForAlgorithm(vector<string>& stringVec,
                               vector<int>& runSelection);
    
    vector<string> headerFileList(RunSelection runSelection);
    vector<string> implementationFileList(RunSelection runSelection);
    
private:
    
    
};

#endif /* defined(__Algorithms__ConsoleModel__) */
