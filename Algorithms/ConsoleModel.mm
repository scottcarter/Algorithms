//
//  ConsoleModel.mm
//  Algorithms
//
//  Created by Scott Carter on 8/29/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#include "ConsoleModel.h"

#include "ConsoleModelSnippets.h"


void ConsoleModel::dataForAlgorithm(RunSelection runSelection, string& output)
{
    switch (runSelection) {
        case FindNegative:
            output = ConsoleModelSnippets::findNegative();
            break;

        case Hello2:
            output = "Hello World 2\n";
            break;

        case Hello3:
            output = "Hello World 3\n";
            break;

        default:
            char c_str[80];
            sprintf(c_str, "Illegal value of runSelection == %d",runSelection);
            output = string(c_str);
            
            break;
    }
    
    
}


void ConsoleModel::setupInfoForAlgorithm(vector<string>& stringVec,
                                              vector<int>& runSelection)
{
    stringVec.push_back("Find First Negative Number");
    runSelection.push_back(FindNegative);
    
    stringVec.push_back("Hello World 2");
    runSelection.push_back(Hello2);
    
    stringVec.push_back("Hello World 3");
    runSelection.push_back(Hello3);
    
}



vector<string> ConsoleModel::headerFileList(RunSelection runSelection)
{
    vector<string> fileVec;
    
    switch (runSelection) {
        case FindNegative:
            fileVec = ConsoleModelSnippets::headerFileList();
            break;
            
        case Hello2:
            fileVec.push_back("AlgorithmModel.h");
            fileVec.push_back("ConsoleModel.h");
            break;
            
        case Hello3:
            fileVec.push_back("AlgorithmModel.h");
            fileVec.push_back("ConsoleModel.h");
            break;
            
        default:
            break;
    }
    
    return fileVec;
}


vector<string> ConsoleModel::implementationFileList(RunSelection runSelection)
{
    vector<string> fileVec;
    
    switch (runSelection) {
        case FindNegative:
            fileVec = ConsoleModelSnippets::implementationFileList();
            break;
            
        case Hello2:
            fileVec.push_back("AlgorithmModel.mm");
            fileVec.push_back("ConsoleModel.mm");
            break;
            
        case Hello3:
            fileVec.push_back("AlgorithmModel.mm");
            fileVec.push_back("ConsoleModel.mm");
            break;
            
        default:
            break;
    }
    
    return fileVec;

}









