//
//  AlgorithmModelInterface.mm
//  Algorithms
//
//  Created by Scott Carter on 8/22/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "AlgorithmModelInterface.h"

#import "Project.h"


// Need to import all models here.
#import "TwoDiceRollSimulationModel.h"
#import "ConsoleModel.h"



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

+ (NSArray *)headerFilesForAlgorithmName:(NSString *)algorithmName config:(NSDictionary *)config
{
    
    AlgorithmModel* model = NULL;
    NSArray *files = nil;
    vector<string> fileVec;
    
    if([algorithmName isEqualToString:@"TwoDiceRollSimulation"]){
        model = new TwoDiceRollSimulationModel();
        fileVec = ((TwoDiceRollSimulationModel*)model)->headerFileList();
        
    }
    else if([algorithmName isEqualToString:@"Console"]){
        NSInteger row = [config[@"row"] integerValue];
        model = new ConsoleModel();
        fileVec = ((ConsoleModel*)model)->headerFileList((ConsoleModel::RunSelection)row);
    }
    
    assert(model != NULL);  // Unhandled algorithm
    delete model;
    
    files = codeFiles(fileVec);
    return files;
}



+ (NSArray *)implementationFilesForAlgorithmName:(NSString *)algorithmName config:(NSDictionary *)config
{
    AlgorithmModel* model = NULL;
    NSArray *files = nil;
    vector<string> fileVec;
    
    if([algorithmName isEqualToString:@"TwoDiceRollSimulation"]){
        model = new TwoDiceRollSimulationModel();
        fileVec = ((TwoDiceRollSimulationModel*)model)->implementationFileList();
        
    }
    else if([algorithmName isEqualToString:@"Console"]){
        NSInteger row = [config[@"row"] integerValue];
        model = new ConsoleModel();
        fileVec = ((ConsoleModel*)model)->implementationFileList((ConsoleModel::RunSelection)row);
    }
    
    assert(model != NULL);  // Unhandled algorithm
    delete model;
    
    files = codeFiles(fileVec);
    return files;
}




// This method is responsible for getting data from selected algorithm model
//
+ (NSDictionary *)viewDataForAlgorithmName:(NSString *)algorithmName inputs:(NSDictionary *)inputs
{
    
    AlgorithmModel* model = NULL;
    NSDictionary *data = nil;
    
    if([algorithmName isEqualToString:@"TwoDiceRollSimulation"]){
        model = new TwoDiceRollSimulationModel();
        data = twoDiceRollSimulationData((TwoDiceRollSimulationModel*)model, inputs);
    }
    else if([algorithmName isEqualToString:@"Console"]){
        model = new ConsoleModel();
        data = consoleData((ConsoleModel *)model, inputs);
    }
    
    assert(model != NULL);  // Unhandled algorithm
    
    delete model;
    return data;
}


// This method is responsible for getting setup information from selected algorithm model
//
+ (NSDictionary *)viewSetupInfoForAlgorithmName:(NSString *)algorithmName
{
    AlgorithmModel* model = NULL;
    NSDictionary *setupInfo = nil;
    
    if([algorithmName isEqualToString:@"TwoDiceRollSimulation"]){
        ; // No setup needed
    }
    else if([algorithmName isEqualToString:@"Console"]){
        model = new ConsoleModel();
        setupInfo = consoleSetupInfo((ConsoleModel *)model);
    }
    
    assert(model != NULL);  // Unhandled algorithm
    
    delete model;
    return setupInfo;
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


#pragma mark Header and Implementation file helpers

NSArray *codeFiles(vector<string>& fileVec)
{
    NSMutableArray *filesMutableArray = [[NSMutableArray alloc] init];
    
    vector<string>::iterator fileVecIter = fileVec.begin();
    
    // Cycle through each string
    for(;fileVecIter != fileVec.end(); fileVecIter++){
        const char* cStr = (*fileVecIter).c_str();
        
        NSString *str = [NSString stringWithCString:cStr encoding:NSUTF8StringEncoding];
        
        [filesMutableArray addObject:str];
    }
    
    return [[NSArray alloc] initWithArray:filesMutableArray];
}



#pragma mark viewSetupInfoForAlgorithmName helpers

NSDictionary* consoleSetupInfo(ConsoleModel* model)
{
    NSMutableDictionary *setupMutableDict = [[NSMutableDictionary alloc] init];
    
    vector<string> stringVec;
    vector<int>runSelection;
    
    model->setupInfoForAlgorithm(stringVec, runSelection);
    
    // Vectors must be of same length!
    assert(stringVec.size() == runSelection.size());
    
    vector<string>::iterator stringVecIter = stringVec.begin();
    vector<int>::iterator runSelectionIter = runSelection.begin();
    
    // Cycle through each string, runSelection pair
    for(;stringVecIter != stringVec.end(); stringVecIter++, runSelectionIter++){
        const char* cStr = (*stringVecIter).c_str(); // Get constant string pointer
        
        NSString *str = [NSString stringWithCString:cStr encoding:NSUTF8StringEncoding];
        
        [setupMutableDict setObject:str forKey:[NSNumber numberWithInt:*runSelectionIter]];
    }
    
    return [[NSDictionary alloc] initWithDictionary:setupMutableDict];
}



#pragma mark viewDataForAlgorithmName helpers

NSDictionary* consoleData(ConsoleModel* model, NSDictionary* inputs)
{
    NSInteger selection = [(NSNumber *)inputs[@"runSelection"] integerValue];
    
    string consoleOutput;
    model->dataForAlgorithm((ConsoleModel::RunSelection)selection, consoleOutput);
    
    // Bundle up our result
    NSString *result =  [NSString stringWithCString:consoleOutput.c_str() encoding:NSUTF8StringEncoding];
    
    return @{@"consoleOutput": result};
}


NSDictionary* twoDiceRollSimulationData(TwoDiceRollSimulationModel* model, NSDictionary* inputs)
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









