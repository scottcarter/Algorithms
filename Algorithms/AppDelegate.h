//
//  AppDelegate.h
//  Algorithms
//
//  Created by Scott Carter on 8/15/14.
//  Copyright (c) 2014 Scott Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// A database of information shared between the master and detail view controllers.
//
// Initialized in application:didFinishLaunchingWithOptions: instead of
// in one of the 2 controllers to avoid any race conditions on access.
//
@property (strong, nonatomic) NSArray *algorithmDatabase;


@end
