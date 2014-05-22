//
//  Setup.m
//  middle
//
//  Created by apple01 on 13. 6. 6..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "Setup.h"
#import "SceneManager.h"
#import "AppDelegate.h"

@implementation Setup

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Setup *layer = [Setup node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if( (self=[super init]) ) {
        sea = [SimpleAudioEngine sharedEngine];
        //윈사이즈
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        delegate.gameLevel = 2;
        delegate.gameUfo = 1;
        
        CCSprite *selLv = [CCSprite spriteWithFile:@"selectlevel.png"];
        selLv.anchorPoint = ccp(0.5,0.5);

        selLv.position = ccp(size.width/2.0 +105,size.height/2.0+50);
        [self addChild:selLv];

        CCSprite *selUf = [CCSprite spriteWithFile:@"selectufo.png"];
        selUf.anchorPoint = ccp(0.5,0.5);
 
        selUf.position = ccp(size.width/2.0 -105,size.height/2.0+50);
        [self addChild:selUf];

    
        UFO = [CCSprite spriteWithFile:@"ufo1.png"];
        UFO.anchorPoint = ccp(0.5,0.5);
        UFO.scale = 0.9f;
        UFO.scale = 2;
        UFO.position = ccp(size.width/2.0 -110,size.height/2.0-20);
        [UFO runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:1000]]];
        [self addChild:UFO];

        
        LEVEL = [CCSprite spriteWithFile:@"Normal.png"];
        LEVEL.anchorPoint = ccp(0.5,0.5);
        LEVEL.scale = 0.9f;
        LEVEL.position = ccp(size.width/2.0 +105,size.height/2.0-20);
        [self addChild:LEVEL];
        
        _LevelLeft = [CCMenuItemImage itemWithNormalImage:@"arrow1.png" selectedImage:@"arrow1-1.png" target:self
                                          selector:@selector(doClick:)];
        _LevelRight = [CCMenuItemImage itemWithNormalImage:@"arrow2.png" selectedImage:@"arrow2-2.png" target:self
                                            selector:@selector(doClick:)];
        _ufoLeft = [CCMenuItemImage itemWithNormalImage:@"arrow1.png" selectedImage:@"arrow1-1.png" target:self
                                                selector:@selector(doClick:)];
        _ufoRight = [CCMenuItemImage itemWithNormalImage:@"arrow2.png" selectedImage:@"arrow2-2.png" target:self
                                                selector:@selector(doClick:)];
        _LevelLeft.tag = 1000;
        _LevelRight.tag = 2000;
        _ufoLeft.tag = 3000;
        _ufoRight.tag = 4000;
        _LevelLeft.position = ccp(35,-25);
        _LevelRight.position = ccp(175,-25);
        _ufoLeft.position = ccp(-175,-25);
        _ufoRight.position = ccp(-50,-25);
        
        CCMenu *infom1 = [CCMenu menuWithItems:_LevelLeft,_LevelRight,_ufoLeft,_ufoRight,nil];
        [self addChild:infom1 z:10];
        
        CCMenuItem *front=[CCMenuItemImage itemWithNormalImage:@"GoArrow.png" selectedImage:@"GoArrow2.png" target:self selector:@selector(doClick:)];        front.tag=5000;
        front.position=ccp(190,-100);
        
        CCMenu *GoToGame = [CCMenu menuWithItems:front, nil];
        
        [self addChild:GoToGame];
        
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        
        // 배경으로 넣을 이미지들 생성
		_spacedust1 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
        _spacedust2 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
        _planetsunrise = [CCSprite spriteWithFile:@"bg_planetsunrise.png"];
        _galaxy = [CCSprite spriteWithFile:@"bg_galaxy.png"];
        _spacialanomaly = [CCSprite spriteWithFile:@"bg_spacialanomaly.png"];
        _spacialanomaly2 = [CCSprite spriteWithFile:@"bg_spacialanomaly2.png"];
        //
        // 배경 이미지들이 움직일 속도 추가(미구현)
        CGPoint dustSpeed = ccp(0.1, 0.1);
        CGPoint bgSpeed = ccp(0.05, 0.05);
        
        //CCParallaxNode에 이미지들 추가
        [_backgroundNode addChild:_spacedust1 z:0 parallaxRatio:dustSpeed positionOffset:ccp(0,winSize.height/2)];
        [_backgroundNode addChild:_spacedust2 z:0 parallaxRatio:dustSpeed positionOffset:ccp(_spacedust1.contentSize.width,winSize.height/2)];
        [_backgroundNode addChild:_galaxy z:-1 parallaxRatio:bgSpeed positionOffset:ccp(0,winSize.height * 0.7)];
        [_backgroundNode addChild:_planetsunrise z:-1 parallaxRatio:bgSpeed positionOffset:ccp(600,winSize.height * 0)];
        [_backgroundNode addChild:_spacialanomaly z:-1 parallaxRatio:bgSpeed positionOffset:ccp(900,winSize.height * 0.3)];
        [_backgroundNode addChild:_spacialanomaly2 z:-1 parallaxRatio:bgSpeed positionOffset:ccp(1500,winSize.height * 0.9)];
        
        //별이 지나가는 파티클 추가
        NSArray *starsArray = [NSArray arrayWithObjects:@"Stars1.plist", @"Stars2.plist", @"Stars3.plist", nil];
        for(NSString *stars in starsArray) {
            CCParticleSystemQuad *starsEffect = [CCParticleSystemQuad particleWithFile:stars];
            [self addChild:starsEffect z:1];        }
        
    }
    return self;
}

-(void)doClick:(id)sender
{
    CCMenuItem *tmenu = (CCMenuItem *)sender;
    NSLog(@" 메뉴 %d ",tmenu.tag);
    if (tmenu.tag == 5000)
    {
        [sea playEffect:@"Computer Data 05.caf"];
        [SceneManager goPlay];
        NSLog(@"Click");
    }

    else if (tmenu.tag == 2000)
    {
        [sea playEffect:@"Computer Data 04.caf"];
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        delegate.gameLevel = delegate.gameLevel+1;

        if(delegate.gameLevel == 4)
        {
            delegate.gameLevel = 1;
        }
        
        [self performSelector:@selector(levelchange)];
    }
    
    else if (tmenu.tag == 1000)
    {
        [sea playEffect:@"Computer Data 01.caf"];
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        delegate.gameLevel = delegate.gameLevel - 1;
        
        if(delegate.gameLevel == 0)
        {
            delegate.gameLevel = 3;
        }
           [self performSelector:@selector(levelchange)];
    }
    else if (tmenu.tag == 3000)
    {
        [sea playEffect:@"Computer Data 01.caf"];
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        delegate.gameUfo = delegate.gameUfo - 1;
        
        if(delegate.gameUfo == 0)
        {
            delegate.gameUfo = 3;
        }
        [self performSelector:@selector(ufochange)];
    }
    else if (tmenu.tag == 4000)
    {
       [sea playEffect:@"Computer Data 04.caf"];
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        delegate.gameUfo = delegate.gameUfo + 1;
        
        if(delegate.gameUfo == 4)
        {
            delegate.gameUfo = 1;
        }
        [self performSelector:@selector(ufochange)];
    }
    }

-(void)levelchange
    {
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        CGSize size = [[CCDirector sharedDirector] winSize];

        if(delegate.gameLevel == 1)
        {
            [self removeChild:LEVEL cleanup:YES];
            LEVEL = [CCSprite spriteWithFile:@"Easy.png"];
            LEVEL.anchorPoint = ccp(0.5,0.5);
            LEVEL.scale = 0.9f;
            LEVEL.position = ccp(size.width/2.0 +108,size.height/2.0-23);
            [self addChild:LEVEL];
        }
        else if(delegate.gameLevel == 2)
        {
            
            [self removeChild:LEVEL cleanup:YES];
            LEVEL = [CCSprite spriteWithFile:@"Normal.png"];
            LEVEL.anchorPoint = ccp(0.5,0.5);
            LEVEL.scale = 0.9f;
            LEVEL.position = ccp(size.width/2.0 +105,size.height/2.0-20);
            [self addChild:LEVEL];
            
        }
        else if(delegate.gameLevel == 3)
        {
            
            [self removeChild:LEVEL cleanup:YES];
            LEVEL = [CCSprite spriteWithFile:@"Hard.png"];
            LEVEL.anchorPoint = ccp(0.5,0.5);
            LEVEL.scale = 0.9f;
            LEVEL.position = ccp(size.width/2.0 +108,size.height/2.0-23);
            
            [LEVEL runAction:[CCScaleBy actionWithDuration:1 scale:1.5f]];
            [LEVEL runAction:[CCScaleBy actionWithDuration:1 scale:1.0f]];
            [self addChild:LEVEL];
        }
    }


-(void)ufochange
{
    AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    if(delegate.gameUfo == 1)
    {
        [self removeChild:UFO cleanup:YES];
        UFO = [CCSprite spriteWithFile:@"ufo1.png"];
        UFO.anchorPoint = ccp(0.5,0.5);
        UFO.scale = 0.9f;
        UFO.scale = 2;
        UFO.position = ccp(size.width/2.0 -110,size.height/2.0-20);
        [UFO runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:1000]]];
        [self addChild:UFO];
    }
    
    else if(delegate.gameUfo == 2)
    {
        [self removeChild:UFO cleanup:YES];
        UFO = [CCSprite spriteWithFile:@"ufo2.png"];
        UFO.anchorPoint = ccp(0.5,0.5);
        UFO.scale = 0.9f;
        UFO.scale = 2;
        UFO.position = ccp(size.width/2.0 -110,size.height/2.0-20);
        [UFO runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:1000]]];
        [self addChild:UFO];
        
    }
    
    else if(delegate.gameUfo == 3)
    {
        [self removeChild:UFO cleanup:YES];
        UFO = [CCSprite spriteWithFile:@"ufo3.png"];
        UFO.anchorPoint = ccp(0.5,0.5);
        UFO.scale = 0.9f;
        UFO.scale = 2;
        UFO.position = ccp(size.width/2.0 -110,size.height/2.0-20);
        [UFO runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:1000]]];
        [self addChild:UFO];
        
    }

}



@end
