//
//  HelloWorldLayer.m
//  middle
//
//  Created by apple01 on 13. 4. 17..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SceneManager.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	//SimpleAudioEngine *sea;
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
- (id)init
{
    if ( (self=[super initWithColor:ccc4(0,0,0,0)]) ) {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *MainTitle = [CCSprite spriteWithFile:@"MainTitle.png"];
        MainTitle.position = ccp(240,215);
        MainTitle.anchorPoint = ccp(0.5,0.5);
        [self addChild:MainTitle z:4];
        
        _Sound = [SimpleAudioEngine sharedEngine];
        _Sound.effectsVolume = 1;
        //[sea playBackgroundMusic:@"DST-DasElectron.mp3"];
        // 배경을 위한 패럴럭스 노드 추가
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        
        
        
        // 배경을 위한 패럴럭스 노드에 추가할 이미지들을 지정
		_spacedust1 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
        _spacedust2 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
        _planetsunrise = [CCSprite spriteWithFile:@"bg_planetsunrise.png"];
        _galaxy = [CCSprite spriteWithFile:@"bg_galaxy.png"];
        _spacialanomaly = [CCSprite spriteWithFile:@"bg_spacialanomaly.png"];
        _spacialanomaly2 = [CCSprite spriteWithFile:@"bg_spacialanomaly2.png"];
        
        //  배경이 움직이는 속도 조정(미구현)
        CGPoint dustSpeed = ccp(0.1, 0.1);
        CGPoint bgSpeed = ccp(0.05, 0.05);
        
        // 패럴럭스 노드에 이지미들 추가
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
            [self addChild:starsEffect z:1];
        }
    
        //info
        
    _Info=[CCMenuItemImage itemWithNormalImage:@"information.png" selectedImage:@"information2.png" target:self
                                     selector:@selector(doClick:)];
        
    CCMenu *information = [CCMenu menuWithItems:_Info,nil];
    information.position=ccp(440,285);
        //메뉴를 만들기 440280
        _Info.tag = 4000;
        
    [self addChild:information z:10];
        
    item1=[CCMenuItemImage itemWithNormalImage:@"START2.png" selectedImage:@"START.png" target:self selector:@selector(doClick:)];
    
    item2=[CCMenuItemImage itemWithNormalImage:@"HOWTO.png" selectedImage:@"HOWTO2.png" target:self selector:@selector(doClick:)];
    
    item3=[CCMenuItemImage itemWithNormalImage:@"RANK2.png" selectedImage:@"RANK.png" target:self selector:@selector(doClick:)];
    
        item1.tag=1000;
        item2.tag=2000;
        item3.tag=3000;

        //메뉴크기값 약간조절
        item3.scaleX = 1.10f;
        item2.scaleX = 1.10f;
        item1.scaleX = 1.10f;
        
    CCMenu *menu = [CCMenu menuWithItems:item1,item2,item3, nil];
    [menu alignItemsVerticallyWithPadding:7.5f];
    menu.position=ccp(240,100);
        [self addChild:menu z:10];

    }
	return self;
}


- (void)update:(ccTime)dt {

    CGPoint backgroundScrollVel = ccp(0, 0);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, dt));
}


-(void)doClick:(id)sender
{
    CCMenuItem *SelectMenu = (CCMenuItem *)sender;
    NSLog(@" 메뉴 %d ",SelectMenu.tag);
    
    if (SelectMenu.tag == 1000)
    {   //START 메뉴를 눌렀을 때 효과
        id action1 = [CCScaleTo actionWithDuration:0.09f scale:1.1f];         
        id action2 = [CCScaleTo actionWithDuration:0.09f scale:0.9f];   
        id action3 = [CCScaleTo actionWithDuration:0.08f scale:1.1f];
        id action4 = [CCScaleTo actionWithDuration:0.09f scale:0.9f]; 
        id action5 = [CCScaleTo actionWithDuration:0.09f scale:1.1f];
         [_Sound playEffect:@"Computer Data 03.caf"];
        id allActions = [CCSequence actions:action1,action2,
                 action3,action4,action5, nil];
        [item1 runAction:allActions];
        
        [self performSelector:@selector(goPlays)
                   withObject:nil
                   afterDelay:0.4f];
    }
    else if(SelectMenu.tag == 2000) { 
        id action1 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
        id action2 = [CCScaleTo actionWithDuration:0.1f scale:0.9f];
        id action3 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
        id action4 = [CCScaleTo actionWithDuration:0.1f scale:0.9f];
        id action5 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
         [_Sound playEffect:@"Computer Data 03.caf"];
        id allActions = [CCSequence actions:action1,action2,
                 action3,action4,action5, nil];
        [item2 runAction:allActions];
        
        [self performSelector:@selector(goGame)
                   withObject:nil
                   afterDelay:0.4f];
              }
    
    else if(SelectMenu.tag == 3000) 
    {
        [_Sound playEffect:@"Computer Data 03.caf"];
        id action1 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
        id action2 = [CCScaleTo actionWithDuration:0.1f scale:0.9f];
        id action3 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
        id action4 = [CCScaleTo actionWithDuration:0.1f scale:0.9f];
        id action5 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
        
        id allActions = [CCSequence actions:action1,action2,
                 action3,action4,action5, nil];
        [item3 runAction:allActions];
        
        [self performSelector:@selector(goRank)
                   withObject:nil
                   afterDelay:0.4f];
    }
    else if(SelectMenu.tag == 4000)
    {
        id action1 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
        id action2 = [CCScaleTo actionWithDuration:0.1f scale:0.9f];
        id action3 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
        id action4 = [CCScaleTo actionWithDuration:0.1f scale:0.9f];
        id action5 = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
        id allActions = [CCSequence actions:action1,action2,
                 action3,action4,action5, nil];
        [_Info runAction:allActions];
        
        [_Sound playEffect:@"Computer Data 03.caf"];
        
        [self performSelector:@selector(goInfo)
                   withObject:nil
                   afterDelay:0.4f];
    }

        
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
-(void)goPlays 
{
    [SceneManager goSetup];
}
-(void)goGame{
    [SceneManager goGameHow];
}
-(void)goRank
{
    [SceneManager goRank];
}
-(void)goInfo
{
    [SceneManager goInfo];
}
-(void)goset
{
    [SceneManager goSetup];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
