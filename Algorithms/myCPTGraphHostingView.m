//
//  myCPTGraphHostingView.m
//  Algorithms
//
//  Created by Scott Carter on 8/28/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import "myCPTGraphHostingView.h"

@implementation myCPTGraphHostingView


// We use subclass CPTGraphHostingView so that we can access drawRect:
//
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    
    // Our bounds have been completely set and stabilized.
    //
    // Send a notification to any potential listeners.
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:CPTGraphHostingViewDrawRectNotification object:self userInfo:nil];
    
}


@end
