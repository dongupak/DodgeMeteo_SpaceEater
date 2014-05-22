//
//  SceneManager.h
//  Cocos2dGame Template
//
//  Created by ivis01 on 13. 2. 1..
//
//

#import <Foundation/Foundation.h>

// 게임에서 사용되는 레이어를 추가하거나 불필요한 레이어는 삭제한다
#import "HelloWorldLayer.h"
#import "Rank.h"
#import "Howto.h"
#import "play.h"
#import "info.h"

@interface SceneManager : NSObject {

}

// 각 레이어로 이동하는 정적 메소드임
+(void) goMenu;
+(void) goRank;
+(void) goSetup;
+(void) goPlay;
+(void) goInfo;
//+(void) goGameWin;
//+(void) goGameOver;
+(void) goGameHow;
+(void) goGameHow2;
+(void) goGameHow3;
+(void) goGameHow4;
//+(void) goGamePlay;
// 레이어간 이동에서 사용되는 트랜지션 효과와 효과에 사용되는 시간
+(void) go:(CCLayer *)layer withTransition:(NSString *)transitionString ofDelay:(float)t;
+(void) go:(CCLayer *)layer withTransition:(NSString *)transitionString;
+(void) go:(CCLayer *)layer;

@end
