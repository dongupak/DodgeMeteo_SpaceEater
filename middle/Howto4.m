//
//  Howto.m
//  middle
//
//  Created by apple01 on 13. 5. 29..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "Howto4.h"
#import "SceneManager.h"

@implementation Howto4

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Howto4 *layer = [Howto4 node];
	
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
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //게임 설명하는 이미지를 넣기위한부분
        CCSprite *backs = [CCSprite spriteWithFile:@"HowtoPlay.png"];
        backs.anchorPoint = ccp(0.5,0.5);
        backs.position = ccp(size.width/2.0,size.height/2.0 + 100);
        [self addChild:backs];
        
        //스케일조정
        backs.scale = 0.75f;
        
        //게임 설명 1번 페이지
        
        CCSprite *explain = [CCSprite spriteWithFile:@"explain.png"];
        explain.position = ccp(size.width/2.0,size.height/2.0);
        [self addChild:explain z:0];
        explain.scale = 1.0f;

        
        CCMenuItem *back=[CCMenuItemImage itemWithNormalImage:@"GoArrow.png" selectedImage:@"GoArrow2.png" target:self selector:@selector(doClick:)];
        
        back.tag=4000;
        
        CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
        backmenu.position=ccp(size.width/2.0+190, size.height/2.0 -100);
        [self addChild:backmenu];
        
        // CCParallaxNode 생성
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        // 배경으로 넣을 이미지들 생성
        _planetsunrise = [CCSprite spriteWithFile:@"bg_planetsunrise.png"];
        _galaxy = [CCSprite spriteWithFile:@"bg_galaxy.png"];
        _spacialanomaly = [CCSprite spriteWithFile:@"bg_spacialanomaly.png"];
        _spacialanomaly2 = [CCSprite spriteWithFile:@"bg_spacialanomaly2.png"];
        //
        // 배경 이미지들이 움직일 속도 추가(미구현)
        
        CGPoint bgSpeed = ccp(0.05, 0.05);
        //
        //CCParallaxNode에 이미지들 추가
        
        [_backgroundNode addChild:_galaxy z:-1 parallaxRatio:bgSpeed positionOffset:ccp(0,winSize.height * 0.7)];
        [_backgroundNode addChild:_planetsunrise z:-1 parallaxRatio:bgSpeed positionOffset:ccp(600,winSize.height * 0)];
        [_backgroundNode addChild:_spacialanomaly z:-1 parallaxRatio:bgSpeed positionOffset:ccp(900,winSize.height * 0.3)];
        [_backgroundNode addChild:_spacialanomaly2 z:-1 parallaxRatio:bgSpeed positionOffset:ccp(1500,winSize.height * 0.9)];
        
    }
    return self;
}

-(void)doClick:(id)sender
{
    CCMenuItem *tmenu = (CCMenuItem *)sender;
    NSLog(@" 메뉴 %d ",tmenu.tag);
    
    if (tmenu.tag == 4000)
    {
        [sea playEffect:@"Computer Data 05.caf"];
        [SceneManager goMenu]; 
    }
    
}

@end
