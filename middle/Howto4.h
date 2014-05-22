//
//  Howto4.h
//  middle
//
//  Created by 정보통신공학과 on 13. 6. 9..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface Howto4 : CCLayer {
    SimpleAudioEngine *sea;
    
    CCParallaxNode *_backgroundNode;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
}

@end
