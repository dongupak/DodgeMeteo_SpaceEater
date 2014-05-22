//
//  Howto.m
//  middle
//
//  Created by apple01 on 13. 5. 29..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "Howto2.h"
#import "SceneManager.h"

@implementation Howto2

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Howto2 *layer = [Howto2 node];
	
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
        
        CCSprite *lifepo = [CCSprite spriteWithFile:@"HpItem.png"];
        lifepo.position = ccp(size.width/4.0 - 30,size.height/2.0 + 30);
        [self addChild:lifepo];
        lifepo.scale = 1.0f;
        
        CCSprite *shield = [CCSprite spriteWithFile:@"electricItem.png"];
        shield.position = ccp(size.width/4.0 - 30,size.height/2.0 - 20);
        [self addChild:shield];
        shield.scale = 1.0f;
        
        CCSprite *fireitem = [CCSprite spriteWithFile:@"fireItem.png"];
        fireitem.position = ccp(size.width/4.0 - 30,size.height/2.0 - 70);
        [self addChild:fireitem];
        fireitem.scale = 1.0f;
        
        CCLabelTTF *text = [CCLabelTTF labelWithString:@"Medicine: When you get this item, your heart will be added one ." dimensions:CGSizeMake(300,60) hAlignment:UITextAlignmentLeft fontName:@"Arial" fontSize:14];
        text.color = ccWHITE;
        text.position = ccp(size.width/2.0 + 25, size.height/2.0 + 15);
        [self addChild:text];
        
        CCLabelTTF *text2 = [CCLabelTTF labelWithString:@"Electric Shield: This item will make you invincible" dimensions:CGSizeMake(300,60) hAlignment:UITextAlignmentLeft fontName:@"Arial" fontSize:14];
        text2.color = ccWHITE;
        text2.position = ccp(size.width/2.0 + 25, size.height/2.0 - 35);
        [self addChild:text2];
        
        CCLabelTTF *text3 = [CCLabelTTF labelWithString:@"Frie Shield: When you get 'Fire Shield', you can change the meteos to score." dimensions:CGSizeMake(300,60)hAlignment:UITextAlignmentLeft fontName:@"Arial" fontSize:14];
        text3.color = ccWHITE;
        text3.position = ccp(size.width/2.0 + 25, size.height/2.0 - 85);
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
        [SceneManager goGameHow3];
    }
    
}

@end
