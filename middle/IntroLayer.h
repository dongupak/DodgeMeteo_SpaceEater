//
//  IntroLayer.h
//  middle
//
//  Created by apple01 on 13. 4. 17..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
// HelloWorldLayer
@interface IntroLayer : CCLayer

{        
    SimpleAudioEngine *seas;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
