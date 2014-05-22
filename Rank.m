//
//  Howto.m
//  middle
//
//  Created by apple01 on 13. 5. 29..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "Rank.h"
#import "SceneManager.h"

@implementation Rank

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Rank *layer = [Rank node];
	
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
        
        //게임 설명하는 이미지를 넣기위한부분
        CCSprite *backs = [CCSprite spriteWithFile:@"Ranking.png"];
        backs.anchorPoint = ccp(0.5,0.5);
        backs.position = ccp(size.width/2.0,size.height/2.0 + 100);
        [self addChild:backs];
        
        //스케일조정
        backs.scale = 0.75f;
        
        
               
        
        CCMenuItem *back=[CCMenuItemImage itemWithNormalImage:@"backArrow.png" selectedImage:@"backArrow2.png" target:self selector:@selector(doClick:)];
        
        back.tag=4000;
        
        CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
        backmenu.position=ccp(size.width/2.0+190, size.height/2.0 -100);
        [self addChild:backmenu];
    }
    return self;
}

-(void)doClick:(id)sender
{
    CCMenuItem *tmenu = (CCMenuItem *)sender;
    NSLog(@" 메뉴 %d ",tmenu.tag);
    
    if (tmenu.tag == 4000)
    {
        
        [SceneManager goMenu];
        [sea playEffect:@"Computer Data 05.caf"];
        
    }
    
    
}

@end
