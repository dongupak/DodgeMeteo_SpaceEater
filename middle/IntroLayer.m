//
//  IntroLayer.m
//  middle
//
//  Created by apple01 on 13. 4. 17..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "Play.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"int.JPG"];
        background.scaleX = 0.8f;
        background.scaleY = 0.8f;
        background.anchorPoint = ccp(0.5,0.5);
        
        seas = [SimpleAudioEngine sharedEngine];
        seas.backgroundMusicVolume = 4;
        [seas playBackgroundMusic:@"DST-DasElectron.mp3"];

	} else {
		background = [CCSprite spriteWithFile:@"int.JPG"];

	}
	background.position = ccp(235, size.height/2);

	// add the label as a child to this Layer
	[self addChild: background];
	
	// In one second transition to the new scene
	[self scheduleOnce:@selector(makeTransition:) delay:0.5];//로고딜레이
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:0.7f scene:[HelloWorldLayer scene]]];}
@end
