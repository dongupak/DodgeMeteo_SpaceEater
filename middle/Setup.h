//
//  Setup.h
//  middle
//
//  Created by apple01 on 13. 6. 6..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface Setup : CCLayer {
    
        SimpleAudioEngine *sea;
    
    CCParallaxNode *_backgroundNode;
    CCSprite *_spacedust1;
    CCSprite *_spacedust2;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
    
    CCMenuItem *_LevelLeft;
    CCMenuItem *_LevelRight;
    CCMenuItem *_ufoLeft;
    CCMenuItem *_ufoRight;
    CCSprite *LEVEL;
    CCSprite *UFO;
}

@end
