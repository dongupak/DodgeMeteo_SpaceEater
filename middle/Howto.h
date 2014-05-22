//
//  Howto.h
//  middle
//
//  Created by apple01 on 13. 5. 29..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface Howto : CCLayer {
    SimpleAudioEngine *sea;
    
    CCParallaxNode *_backgroundNode;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
}

@end
