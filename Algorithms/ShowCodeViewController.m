//
//  ShowCodeViewController.m
//  Algorithms
//
//  Created by Scott Carter on 8/27/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "ShowCodeViewController.h"


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
@interface ShowCodeViewController ()

// ==========================================================================
// Properties
// ==========================================================================
//
#pragma mark -
#pragma mark Properties

@property (weak, nonatomic) IBOutlet UIWebView *codeView;



@end



// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                    Implementation
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
#pragma mark -
@implementation ShowCodeViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
//    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.codeView loadRequest:request];
    
    
    // highlight.js is hosted
    
    NSString *htmlPrefix = @"\n\
    <html>\n\
    <head>\n\
    <link rel='stylesheet' href='http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/styles/railscasts.min.css'>\n\
    <script src='http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/highlight.min.js'></script>\n\
    \n\
    <script>\n\
    hljs.initHighlightingOnLoad();\
    </script>\n\
    \n\
    \n\
    </head>\n\
    <body>\n\
    <pre><code class='cpp'>\n\
    ";
    
    NSString *htmlSuffix = @"\n\
    </code></pre>\n\
    </body>\n\
    </html>\n\
    ";
    
    NSString *html = [NSString stringWithFormat:@"%@\n%@\n%@",htmlPrefix, self.code, htmlSuffix];
    
    //NLOG("html=%@",html)
    
    [self.codeView loadHTMLString:html baseURL:nil];
}



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

// None


// ==========================================================================
// Instance methods
// ==========================================================================
//
#pragma mark -
#pragma mark Instance methods

- (void)clearWebView
{
    [self.codeView loadHTMLString:@"" baseURL:nil];
}



// ==========================================================================
// C methods
// ==========================================================================
//


#pragma mark -
#pragma mark C methods





@end









