//
//  ConsoleModelSnippets.h
//  Algorithms
//
//  Created by Scott Carter on 9/12/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#ifndef __Algorithms__ConsoleModelSnippets__
#define __Algorithms__ConsoleModelSnippets__

#include <vector>
#include <string>

#include <iostream>

using namespace std;

class ConsoleModelSnippets
{
public:
    
    // Static member functions that can be called without an instance of this
    // class.
    static string findNegative(void);
    
    static vector<string> headerFileList(void);
    static vector<string> implementationFileList(void);
    
private:
    
    static void findNegativeHelper(float **fpp);
};



#endif /* defined(__Algorithms__ConsoleModelSnippets__) */
