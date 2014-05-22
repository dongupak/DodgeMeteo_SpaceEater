//
//  HelloWorldLayer.h
//  middle
//
//  Created by apple01 on 13. 4. 17..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "SimpleAudioEngine.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCMenuItem *item1;
    CCMenuItem *item2;
    CCMenuItem *item3;
    CCMenuItem *_Info;
    SimpleAudioEngine *_Sound;

    //배경에 쓰기 위한 이미지들 및 패럴럭스
    CCParallaxNode *_backgroundNode;
    CCSprite *_spacedust1;
    CCSprite *_spacedust2;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
