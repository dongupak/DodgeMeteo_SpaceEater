//
//  AppDelegate.h
//  middle
//
//  Created by apple01 on 13. 4. 17..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
    NSInteger gameScore; //score
    NSInteger gameLevel; //level
    NSInteger gameUfo; //ufo
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (readwrite) NSInteger       gameScore;
@property (readwrite) NSInteger       gameLevel;
@property (readwrite) NSInteger       gameUfo;
@end
