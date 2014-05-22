//
//  Play.h
//  middle
//
//  Created by apple01 on 13. 5. 29..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
//게임 종료 관련
typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

@interface Play : CCLayer {

    CCParallaxNode *_backgroundNode;
    CCSprite *_spacedust1;
    CCSprite *_spacedust2;
    CCSprite *_planetsunrise;
    CCSprite *_galaxy;
    CCSprite *_spacialanomaly;
    CCSprite *_spacialanomaly2;
    CCSprite *_Hearts;
    CCSprite *pausealert;
    
    CCLabelTTF *point;//스코어포인트
    SimpleAudioEngine *_Sound;
    CCSprite *ufo;
    CCMenu *pausemenu;
    CCMenu *resumemenu;
    CCMenuItem *youlose;
    CCMenuItem *gomenu;
    CCMenuItem *restart;
    //보호막 발동 이미지
    CCSprite *_BlueShield;
    CCSprite *_RedShield;
    
    //레벨에 따른 추가값
    NSInteger levelmaxS;//운석속도 맥스
    NSInteger levelminS;//운석속도 민
    NSInteger levelspeed;//운석 생성속도
    NSInteger levellife;//라이프포인트
    NSInteger levelsecond;//새로운 운석 출몰시간
    NSInteger levelpoint;//점수가중치
    
    //기본 설정값
    NSInteger life;//라이프포인트
    NSInteger ShieldOn; //쉴드
    NSInteger item; //아이템
    NSInteger ReRedmeteo; //불운석
    NSInteger stop; //포즈기능
    //운석 소환관련 인자
    int _PlusMinus;
    int _PlusMinus2;
    //비행기
    CCSprite *_MainUfo;
    //터치관련
    BOOL TouchState;
    
    //운석을 넣을 어레이
    NSMutableArray *_MeteoGroup;
    //아이템 넣을 어레이
    NSMutableArray *Items1;
    NSMutableArray *Items2;
    NSMutableArray *Items3;
    NSMutableArray *shield1;
    NSMutableArray *shield2;
    //파티클 변수
    CCParticleSystem *ParticleExplo;
    CCParticleSystem *ParticelCrash;
    CCParticleSystem *ParticelBlue;
    CCParticleSystem *ParticelRed;
    //생명력
    int _lives;
    //게임오버 ccp(size.width/2.0+190, size.height/2.0 + 125);시간 및 조건
    double _gameOverTime;
    bool _gameOver;
    CCSprite *redmeteo;
    
    //엑셀레로미터관련 변수
    CGPoint playerVelocity;

};
//운석소환 실행함수
-(void)gameLogic1;
-(void)gameLogic2;
-(void)gameLogic3;
-(void)gameLogic4;
-(void)gameLogic5;
-(void)gameLogic6;
//운선소환 함수
- (void) addMeteo1;
- (void) addMeteo2;
- (void) addMeteo3;
- (void) addMeteo4;
- (void) addMeteo5;
- (void) addMeteo6;
//터치 가능하게 만듬
- (void) registerWithTouchDispatcher;
//파티클 함수
-(void)doParticle;

@end
