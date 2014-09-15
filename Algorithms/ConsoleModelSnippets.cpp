//
//  ConsoleModelSnippets.cpp
//  Algorithms
//
//  Created by Scott Carter on 9/12/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#include "ConsoleModelSnippets.h"



/*
 Example of pointer to pointers.
 
 Find first negative number in a list.
 
 We pass pointer to fp to findNegativeHelper, rather than fp itself
 so that helper method can modify fp (point at result).
 */
string ConsoleModelSnippets::findNegative(void)
{
    string result("ConsoleModelSnippets::findNegative\n\n");
    
    float vals[] = {34.23, 67.33, 46.44, -100.22, 85.56, 0};
    float* fp = vals;
    findNegativeHelper(&fp);
    
    char c_str[80];
    sprintf(c_str, "First negative #=%f",*fp);
    
    result += string(c_str);
    
    return result;
}

void ConsoleModelSnippets::findNegativeHelper(float **fpp)
{
    while (**fpp != 0) {
        if(**fpp < 0)
            break;
        else
            (*fpp)++;
    }
}


vector<string> ConsoleModelSnippets::headerFileList(void)
{
    vector<string> fileVec;
    
    fileVec.push_back("AlgorithmModel.h");
    fileVec.push_back("ConsoleModel.h");
    fileVec.push_back("ConsoleModelSnippets.h");
    
    return fileVec;
}

vector<string> ConsoleModelSnippets::implementationFileList(void)
{
    vector<string> fileVec;
    
    fileVec.push_back("AlgorithmModel.mm");
    fileVec.push_back("ConsoleModel.mm");
    fileVec.push_back("ConsoleModelSnippets.cpp");
    
    return fileVec;
}







