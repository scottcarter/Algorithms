//
//  Global.h
//
//  Created by Scott Carter on 8/15/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

// ***** Nothing project specific in this file *****
//
// Project specific defines, as well as import of this file, go in the Project.h file.
//
// This file should only be imported by Project.h file.
//

#ifndef Global_h
#define Global_h

//// SharedState singleton
//#import "CommonStateSingleton.h"
//
//// Our debug singleton
//#import "DebugSingleton.h"
//
//// For TestFlight TFLog
//#import "TestFlight.h"


// Default is a release environment
//
// PROJECT_DEVELOPMENT macro should be set in Project.h file just prior to #import "Global.h"
#ifndef PROJECT_DEVELOPMENT
#define PROJECT_DEVELOPMENT 0
#endif

// ENABLE_PRAGMA_FOR_FLOG macro should be set in Project.h file just prior to #import "Global.h"
#ifndef ENABLE_PRAGMA_FOR_FLOG
#define ENABLE_PRAGMA_FOR_FLOG 1
#endif


// Get define for TARGET_IPHONE_SIMULATOR
// Reference:  http://bit.ly/YCPyPJ
#include "TargetConditionals.h"

// Create the define IPHONE_SIMULATOR_DEVELOPMENT that we can use for debugging and test purposes
#if PROJECT_DEVELOPMENT
#if TARGET_IPHONE_SIMULATOR
#define IPHONE_SIMULATOR_DEVELOPMENT 1
#endif
#endif

// Default is not an iphone simulator development environment unless set above
// (default could mean iPad, iPhone device, iPhone simulator in release environment, etc)
#ifndef IPHONE_SIMULATOR_DEVELOPMENT
#define IPHONE_SIMULATOR_DEVELOPMENT 0
#endif



/**
 * Does ARC support support GCD objects?
 * It does if the minimum deployment target is iOS 6+ or Mac OS X 8+
 **/
// References:
// http://stackoverflow.com/questions/13702701/why-is-arc-complaining-about-dispatch-queue-create-and-dispatch-release-in-ios-6
// https://github.com/soffes/Reachability/blob/5ef19d50169bcced4c3cb4a480ed3ed1ef150dd8/Reachability.h
//
#if TARGET_OS_IPHONE

// Compiling for iOS

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000 // iOS 6.0 or later
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else                                         // iOS 5.X or earlier
#define NEEDS_DISPATCH_RETAIN_RELEASE 1
#endif

#endif


 
// Define some macros that only execute in a development environment
#if PROJECT_DEVELOPMENT


// Macros used to put up flags in Instruments view.  Only available in simulator environment.
#if IPHONE_SIMULATOR_DEVELOPMENT

//
//
// Examples used a constant string in format such as com.scarter.mytracepoints.app.point,
// but in looking at the macro, it appears that any string can be used.
//
// DTSendSignalFlag("com.scarter.mytracepoints.app.point", DT_POINT_SIGNAL, TRUE);
//
// References:
// http://invasivecode.tumblr.com/post/18677362251/flags-very-useful-when-debugging-with
// http://www.freelancemadscience.com/fmslabs_blog/2012/9/18/advanced-profiling-with-the-dtperformancesession-framework.html
// http://developer.apple.com/library/ios/#documentation/AnalysisTools/Conceptual/WhatsNewInstruments/NewFeatures40/NewFeatures40.html
//
// Note:
// You need to enable flags to be displayed as mentioned in the reference above at freelancemadscience.com
// Contrary to that reference though, I needed to check "Signal Flags", not "Symbol Flags".

#import <DTPerformanceSession/DTSignalFlag.h>


// Notes:
// - NSString used with INSTRUMENT macros can be about 40 characters before getting truncated.
// - Analyze will show warnings when using these macros, but this in an issue with the DTSendSignalFlag macro
//   and still functionally works.  Issue related to "timesec declared without an initial value" which you can
//   see by expanding the Analyze warning.

// Point flag (just an event in time)
#define INSTRUMENT_POINT_SIGNAL(x)  {const char *cstr = [x UTF8String]; DTSendSignalFlag(cstr, DT_POINT_SIGNAL, TRUE); }

// Start flag (to mark the start of something)
#define INSTRUMENT_START_SIGNAL(x) {const char *cstr = [x UTF8String]; DTSendSignalFlag(cstr, DT_START_SIGNAL, TRUE); }

// End flag (to mark the end of something)
#define INSTRUMENT_END_SIGNAL(x) {const char *cstr = [x UTF8String]; DTSendSignalFlag(cstr, DT_END_SIGNAL, TRUE); }


// Example:
// NSString *mystr = [NSString stringWithFormat:@"Loop index %d",arrIndex];
//
// INSTRUMENT_POINT_SIGNAL(mystr)
//
#else

#define INSTRUMENT_POINT_SIGNAL(...)
#define INSTRUMENT_START_SIGNAL(...)
#define INSTRUMENT_END_SIGNAL(...)

#endif


#define _STR(x) #x
#define STR(x) _STR(x)

// Pragma messages
//
// Reference:
// http://gcc.gnu.org/onlinedocs/cpp/Macros.html#Macros
//
#define DO_PRAGMA(x) _Pragma (#x)


//// Define a macro that will log to our DebugSingleton using logAddText.
////
//#define DSLOG(FormatLiteral, ...) \
//{ \
//NSString *text = [NSString stringWithFormat:@"%s(%u): \n" FormatLiteral "\n\n",__FUNCTION__, __LINE__, ##__VA_ARGS__]; \
//[[DebugSingleton sharedDebugSingleton] logAddText:text]; \
//}


// Define a macro that will trace to our DebugSingleton using traceAdd.
//
// Examples:
//
// DSTRACE("Hello",@"foo":@"bar", @"yahoo":@"google")
// DSTRACE("",@"foo":@"bar", @"yahoo":@"google")
// DSTRACE("Hello")
//
// NSString *key = @"mykey";
// NSArray *obj = @[@{@"k1":@"v1"}, @{@"k2":@"v2", @"k3":@"v3"}];
// DSTRACE("Hello",key:obj)



// NOTE:
// I've suspended my use of DSTRACE for now since I was using it in a thread un-safe manner.
// See some of the logs in Dropbox->Developer_iOS7->Bug Reports->Algorithms which I currently attribute to this issue:
//
// unresolvedConflictVersionsOfItemAtURL_4_13_14*.txt
// runLoop_4_16_14*.txt
// runLoop_5_1_14.txt
// pointer_being_freed_was_not_allocated_5_2_14.txt
//

//#define DSTRACE(str, ...) \
//{ \
//NSString *msg = [NSString stringWithFormat:@"" str ""]; \
//NSString *functionLine = [NSString stringWithFormat:@"%s(%u)",__FUNCTION__, __LINE__]; \
//NSDictionary *traceDict = @{@"a_msg":msg, @"functionLine":functionLine, @"infoDict":@{__VA_ARGS__}}; \
//[[DebugSingleton sharedDebugSingleton] traceAdd:traceDict]; \
//}

#define DSTRACE(...)


// Define an error log message that prints argument along with function name and line number.
// Useful in conditional blocks.
//
// Exception description. May be truncated to 100 chars.
// isFatal (required). NO indicates non-fatal exception.

//#define ERROR_LOG(FormatLiteral, ...)  [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createExceptionWithDescription:[NSString stringWithFormat:@"ERROR in %s(%u) %@ %@: " FormatLiteral, __FUNCTION__, __LINE__, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ##__VA_ARGS__] withFatal:@NO] build]];  NSLog (@"ERROR in %s(%u): " FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__);  DSLOG("ERROR: " FormatLiteral, ##__VA_ARGS__)

#define ERROR_LOG(FormatLiteral, ...)  NSLog (@"ERROR in %s(%u): " FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__);


// Define an exception log message (programming checks) that can be used in conditional blocks.
// See also NSAssert() which can be used for one line checks.
//
// When to use an exception?  For programming errors, not run-time user errors (such as file cannot be found).
// User errors can be communicated via NSError objects.  See:
// A Note on Errors and Exceptions
// https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ErrorHandlingCocoa/CreateCustomizeNSError/CreateCustomizeNSError.html
//
// More on NSError
// https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/NSError_Class/Reference/Reference.html
// https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ErrorHandlingCocoa/ErrorObjectsDomains/ErrorObjectsDomains.html
//

//#define EXCEPTION_LOG(FormatLiteral, ...)  [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createExceptionWithDescription:[NSString stringWithFormat:@"EXCEPTION in %s(%u) %@ %@: " FormatLiteral, __FUNCTION__, __LINE__, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ##__VA_ARGS__] withFatal:@YES] build]]; [NSException raise:NSInternalInconsistencyException format:@"EXCEPTION in %s(%u): " FormatLiteral "\n", __FUNCTION__, __LINE__, ##__VA_ARGS__];

#define EXCEPTION_LOG(FormatLiteral, ...)  [NSException raise:NSInternalInconsistencyException format:@"EXCEPTION in %s(%u): " FormatLiteral "\n", __FUNCTION__, __LINE__, ##__VA_ARGS__];


// To get a symbol stack trace, try:
// NSLog(@"%@",[NSThread callStackSymbols]);
// Reference: http://bit.ly/ZhwIv4


// Define some pragma messages that appear in Issue Navigator view.
// They can be temporary (TODO, FIXME) or permanent (BOOKMARK)
// They print a constant string (similar to CLOG below) with a specific prefix.
//
//#define TODO(...)
#define TODO(x) DO_PRAGMA(message (STR(__LINE__) " TODO: " #x))

#define FIXME(x) DO_PRAGMA(message (STR(__LINE__) " FIXME: " #x))

#define BOOKMARK(x) DO_PRAGMA(message (STR(__LINE__) " -> " #x))

// Define a couple logging varieties.  Both appear in Issue Navigator view.
// They are intended for temporary debug.
//
// CLOG prints a constant string, without the need for @, quotes or trailing ;
// CLOG(Hello World)
//
// NLOG can replace NSLog, without the need for @ or trailing ;
// NLOG("firstname=%@",self.firstname)
// 
#define CLOG(x) NSLog(@#x); DO_PRAGMA(message (STR(__LINE__) " NSLog: " #x))

// Simple example of NLOG
//#define NLOG(...) NSLog(@__VA_ARGS__); DO_PRAGMA(message (STR(__LINE__) " NSLog: " #__VA_ARGS__))


// Formatted log.  Note that I don't need STR() for __LINE__
//
// Reference:
// http://en.wikipedia.org/wiki/Variadic_macro
//
// Implement NLOG with FLOG
//
// If ENABLE_PRAGMA_FOR_FLOG is set, FLOG and NLOG both use pragma.  If not set, only NLOG uses pragma.
#if ENABLE_PRAGMA_FOR_FLOG

#define FLOG(LogType, MacroType, FormatLiteral, ...)  NSLog (@"%s(%u): " LogType " \n" FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__);  DO_PRAGMA(message (STR(__LINE__) " " MacroType ": " FormatLiteral " " #__VA_ARGS__))

#define NLOG(FormatLiteral, ...)  FLOG("","NSLog", FormatLiteral, ##__VA_ARGS__)

#else

#define FLOG(LogType, MacroType, FormatLiteral, ...)  NSLog (@"%s(%u): " LogType " \n" FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__);  

#define NLOG(FormatLiteral, ...)  FLOG("","NSLog", FormatLiteral, ##__VA_ARGS__) DO_PRAGMA(message (STR(__LINE__) " NSLog : " FormatLiteral " " #__VA_ARGS__))
#endif



// If PROJECT_DEVELOPMENT is not defined, we stub out ERROR_LOG, EXCEPTION_LOG, BOOKMARK, CLOG.

// FLOG, NLOG are specifically setup for TestFlight in release mode
// and consequently any project specific logging macros in the .pch file will continue to function for remote logging.
//
#else

#define INSTRUMENT_POINT_SIGNAL(...)
#define INSTRUMENT_START_SIGNAL(...) 
#define INSTRUMENT_END_SIGNAL(...)

#define DSLOG(...)

#define DSTRACE(...)


// We continue to report errors to Google Analytics in production, but don't call NSLog
//#define ERROR_LOG(FormatLiteral, ...)  [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createExceptionWithDescription:[NSString stringWithFormat:@"ERROR in %s(%u) %@ %@: " FormatLiteral, __FUNCTION__, __LINE__, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ##__VA_ARGS__] withFatal:@NO] build]];  if([[CommonStateSingleton sharedCommonStateSingleton] testFlightInitialized]){ TFLog (@"ERROR in %s(%u): " FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__); }

#define ERROR_LOG(...)


// We continue to report exceptions to Google Analytics in production, but don't throw an exception.
//#define EXCEPTION_LOG(FormatLiteral, ...)  [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createExceptionWithDescription:[NSString stringWithFormat:@"EXCEPTION in %s(%u) %@ %@: " FormatLiteral, __FUNCTION__, __LINE__, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ##__VA_ARGS__] withFatal:@YES] build]];  if([[CommonStateSingleton sharedCommonStateSingleton] testFlightInitialized]){ TFLog (@"EXCEPTION in %s(%u): " FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__); }

#define EXCEPTION_LOG(...)


#define TODO(...)
#define FIXME(...)
#define BOOKMARK(...)
#define CLOG(...)

// Special handling for TestFlight.
//#define FLOG(LogType, MacroType, FormatLiteral, ...)  if([[CommonStateSingleton sharedCommonStateSingleton] testFlightInitialized]){ TFLog (@"%s(%u): " LogType " \n" FormatLiteral "\n\n", __FUNCTION__, __LINE__, ##__VA_ARGS__); }
//
//#define NLOG(FormatLiteral, ...)  FLOG("","NSLog", FormatLiteral, ##__VA_ARGS__)

#define FLOG(...)
#define NLOG(...)

#endif



// +++++++++++++++++++++++++++++++++++++++++++
// Unit testing macros
// +++++++++++++++++++++++++++++++++++++++++++
//

//// Define some macros that only execute in a development environment
//#if PROJECT_DEVELOPMENT
//
//#define COVERPOINT(Name,Condition) if(Condition) { [[CommonStateSingleton sharedCommonStateSingleton] incrementCoverpoint:Name]; }
//
//#else
//
//#define COVERPOINT(...)
//
//#endif



// ++++++++++++++++++++++++++++++++++++++++++++
// Debug macros
// ++++++++++++++++++++++++++++++++++++++++++++

// Inject an error with specified domain, code.  We inject up to MaxInjections in a given
// run.  Count can be reset using resetInjectionErrorCounts method in DebugSingleton.

//#define INJECT_ERROR_RETURN_NIL(Domain, Code, MaxInjections) \
//FIXME(Injecting error and returning nil) \
//NSUInteger injectionCount = [[DebugSingleton sharedDebugSingleton] injectionErrorCountForDomain:Domain code:Code]; \
//if(injectionCount < MaxInjections){ \
//NSLog(@"%d/%d Injecting error domain=%@ code=%d",injectionCount+1, MaxInjections, Domain, Code); \
//if(error != NULL){ \
//NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Injecting error and returning nil", @"")}; \
//*error = [[NSError alloc] initWithDomain:Domain code:Code userInfo:errorDictionary]; \
//ERROR_LOG("%@",*error) \
//} \
//return nil; \
//}
//
//#define INJECT_ERROR_RETURN_NO(Domain, Code, MaxInjections) \
//FIXME(Injecting error and returning NO) \
//NSUInteger injectionCount = [[DebugSingleton sharedDebugSingleton] injectionErrorCountForDomain:Domain code:Code]; \
//if(injectionCount < MaxInjections){ \
//NSLog(@"%d/%d Injecting error domain=%@ code=%d",injectionCount+1, MaxInjections, Domain, Code); \
//if(error != NULL){ \
//NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Injecting error and returning NO", @"")}; \
//*error = [[NSError alloc] initWithDomain:Domain code:Code userInfo:errorDictionary]; \
//ERROR_LOG("%@",*error) \
//} \
//return NO; \
//}




#endif





