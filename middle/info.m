//
//  info.m
//  middle
//
//  Created by apple01 on 13. 6. 4..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "info.h"
#import "SceneManager.h"

@implementation info

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	info *layer = [info node];
	
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
        
        CCSprite *backs = [CCSprite spriteWithFile:@"Info.png"];
        backs.anchorPoint = ccp(0.5,0.5);
        backs.scale = 0.8f;
        backs.position = ccp(size.width/2.0 + 10,size.height/2.0 + 85);
        [self addChild:backs];
        
        CCSprite *ver = [CCSprite spriteWithFile:@"ver.png"];
        ver.anchorPoint = ccp(0.5,0.5);
        ver.position = ccp(size.width/2.0 - 130,size.height/2.0 - 80 );
        [self addChild:ver];
        
        CCSprite *creater = [CCSprite spriteWithFile:@"Creater.png"];
        creater.anchorPoint = ccp(0.5,0.5);
        creater.position = ccp(size.width/2.0 - 150,size.height/2.0 - 5);
        creater.scale = 0.5f;
        [self addChild:creater];
        
        CCSprite *creater2 = [CCSprite spriteWithFile:@"name.png"];
        creater2.anchorPoint = ccp(0.5,0.5);
        creater2.position = ccp(size.width/2.0 + 50 ,size.height/2.0 - 5);
        creater2.scale = 0.75f;
        [self addChild:creater2];
        
        
        info1=[CCMenuItemImage itemWithNormalImage:@"facebook.png" selectedImage:@"facebook.png" target:self
                                          selector:@selector(doClick:)];
        info1.scale = 0.8f;
        
        info1.tag = 5000;
        
        CCMenu *infom1 = [CCMenu menuWithItems:info1,nil];
        infom1.position=ccp(size.width/2.0+40 ,size.height/2.0 - 80 );
        
        [self addChild:infom1 z:10];
        
        CCMenuItem *back=[CCMenuItemImage itemWithNormalImage:@"backArrow.png" selectedImage:@"backArrow2.png" target:self selector:@selector(doClick:)];
        
        back.tag=4000;
        
        CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
        backmenu.position=ccp(size.width/2.0+190, size.height/2.0 -100);
        [self addChild:backmenu];

        
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
        //
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
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/blueborns"]];

-(void)doClick:(id)sender
{
    CCMenuItem *tmenu = (CCMenuItem *)sender;
    NSLog(@" 메뉴 %d ",tmenu.tag);
    
    if (tmenu.tag == 4000)
    {
        [sea playEffect:@"Computer Data 05.caf"];
        [SceneManager goMenu];
    }
    
    else if (tmenu.tag == 5000)
    {
    [sea playEffect:@"Computer Data 05.caf"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/blueborns"]];}
    
}
@end
