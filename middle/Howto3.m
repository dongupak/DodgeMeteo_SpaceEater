//
//  Howto3.m
//  middle
//
//  Created by apple01 on 13. 5. 29..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "Howto3.h"
#import "SceneManager.h"

@implementation Howto3

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Howto3 *layer = [Howto3 node];
	
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
        
        CCSprite *meteo01 = [CCSprite spriteWithFile:@"meteo01.png"];
        meteo01.position = ccp(size.width/4.0 - 40,size.height/2.0 + 40);
        [self addChild:meteo01];
        meteo01.scale = 1.0f;
        [meteo01 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:10 angle:2500]]];
        
        CCSprite *meteo02 = [CCSprite spriteWithFile:@"meteo02.png"];
        meteo02.position = ccp(size.width/4.0 - 40,size.height/2.0 + 5);
        [self addChild:meteo02];
        meteo02.scale = 1.0f;
        [meteo02 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:10 angle:2500]]];
        
        CCSprite *meteo03 = [CCSprite spriteWithFile:@"meteo03.png"];
        meteo03.position = ccp(size.width/4.0 - 10,size.height/2.0 + 5);
        [self addChild:meteo03];
        meteo03.scale = 1.0f;
        [meteo03 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:10 angle:2500]]];
        
        CCSprite *meteo04 = [CCSprite spriteWithFile:@"meteo04.png"];
        meteo04.position = ccp(size.width/4.0 - 15,size.height/2.0 + 40);
        [self addChild:meteo04];
        meteo04.scale = 1.0f;
        [meteo04 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:10 angle:2500]]];
        
        CCSprite *meteo05 = [CCSprite spriteWithFile:@"meteo06.png"];
        meteo05.position = ccp(size.width/4.0 + 10,size.height/2.0 + 40);
        [self addChild:meteo05];
        meteo05.scale = 1.0f;
        [meteo05 runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:10 angle:2500]]];
        
        CCSprite *redmeteo = [CCSprite spriteWithFile:@"redmeteo.png"];
        redmeteo.position = ccp(size.width/4.0 - 20,size.height/2.0 - 70);
        [self addChild:redmeteo];
        redmeteo.scale = 1.0f;
        [redmeteo runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:10 angle:2500]]];
        
        
        CCLabelTTF *text = [CCLabelTTF labelWithString:@"You can meet this kinds of meteorites. They have different pattern." dimensions:CGSizeMake(240,60) hAlignment:UITextAlignmentLeft fontName:@"Arial" fontSize:16];
        text.color = ccWHITE;
        text.position = ccp(size.width/2.0 + 35, size.height/2.0 + 18);
        [self addChild:text];
        
        CCLabelTTF *text2 = [CCLabelTTF labelWithString:@"This is biggest meteorites." dimensions:CGSizeMake(240,90) hAlignment:UITextAlignmentLeft fontName:@"Arial" fontSize:16];
        text2.color = ccWHITE;
        text2.position = ccp(size.width/2.0 + 35, size.height/2.0 - 87);
        [self addChild:text2];
        
        CCLabelTTF *text3 = [CCLabelTTF labelWithString:@"This one respond in random time." dimensions:CGSizeMake(240,60) hAlignment:UITextAlignmentLeft fontName:@"Arial" fontSize:16];
        text3.color = ccWHITE;
        text3.position = ccp(size.width/2.0 + 35, size.height/2.0 - 95);
        [self addChild:text3];
        
        
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
        [SceneManager goGameHow4];
    }
    
}

@end
