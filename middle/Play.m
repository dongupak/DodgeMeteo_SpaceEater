//
//  Howto.m
//  middle
//
//  Created by apple01 on 13. 5. 29..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//
#define DEFAULT_DECELERATION    (0.4f)
#define DEFAULT_SENSITIVITY     (11.0F)
#import "Play.h"
#import "SceneManager.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation Play

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Play *layer = [Play node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    _Sound.effectsVolume = 2;
    if( (self=[super init]) ) {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
        //윈사이즈
       CGSize size = [[CCDirector sharedDirector] winSize];
        _Sound = [SimpleAudioEngine sharedEngine];
        
        //엑셀레로미터 사용 OK
        self.isAccelerometerEnabled = YES;
        
        //터치할 우주선 이미지 추가
        _MainUfo = [[CCSprite alloc] initWithFile : @"me2.png"];
        _MainUfo.position = ccp(size.width/2, size.height/2);
        [self addChild:_MainUfo z:30];
        ShieldOn = 0;
        _MainUfo.scale=0.05;
        //[me runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:450]]];
        self.isTouchEnabled = YES;//터치사용 OK
        
        [self performSelector:@selector(ufocheck)];
        [self performSelector:@selector(levelcheck)];
        
        life = 1 + levellife; //라잎초기화
        _Hearts = [CCSprite spriteWithFile:@"hp2.png"];
        _Hearts.position = ccp(60,285);
        _Hearts.opacity = 185;
        _Hearts.scale = 0.75;
        [self addChild:_Hearts z:10];
        [self schedule:@selector(LifeFunction)];
        
        //스코어///////////////////
        point = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Arial" fontSize:31];
        point.color = ccWHITE;
        point.opacity = 200;
        point.position = ccp(size.width/2.0, size.height/2.0 + 120);
        [self addChild:point z:60];

        //스코어 불러와서 초기화
        AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
        delegate.gameScore = 0;
        
        
        stop = 0;

        CCMenuItem *pause=[CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage:@"pause2.png" target:self selector:@selector(doClick:)];
        
        pause.tag=3000;
        
        pausemenu = [CCMenu menuWithItems:pause, nil];
        pausemenu.position=ccp(size.width/2.0+190, size.height/2.0 + 125);
        pausemenu.opacity=180;
        [self addChild:pausemenu z:32];
                
        // CCParallaxNode 생성
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];

        // 배경으로 넣을 이미지들 생성
		_spacedust1 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
        _spacedust2 = [CCSprite spriteWithFile:@"bg_front_spacedust.png"];
        _planetsunrise = [CCSprite spriteWithFile:@"bg_planetsunrise.png"];
        _galaxy = [CCSprite spriteWithFile:@"bg_galaxy.png"];
        _spacialanomaly = [CCSprite spriteWithFile:@"bg_spacialanomaly.png"];
        _spacialanomaly2 = [CCSprite spriteWithFile:@"bg_spacialanomaly2.png"];
        
        // 배경 이미지들이 움직일 속도 추가(미구현)
        CGPoint dustSpeed = ccp(0.5, 0.5);
        CGPoint bgSpeed = ccp(0.05, 0.05);
        
        //CCParallaxNode에 이미지들 추가
        [_backgroundNode addChild:_spacedust1 z:0 parallaxRatio:dustSpeed positionOffset:ccp(0,winSize.height/2)];
        [_backgroundNode addChild:_spacedust2 z:0 parallaxRatio:dustSpeed positionOffset:ccp(_spacedust1.contentSize.width,winSize.height/2)];        
        [_backgroundNode addChild:_galaxy z:-1 parallaxRatio:bgSpeed positionOffset:ccp(0,winSize.height * 0.7)];
        [_backgroundNode addChild:_planetsunrise z:-1 parallaxRatio:bgSpeed positionOffset:ccp(600,winSize.height * 0)];
        [_backgroundNode addChild:_spacialanomaly z:-1 parallaxRatio:bgSpeed positionOffset:ccp(900,winSize.height * 0.3)];
        [_backgroundNode addChild:_spacialanomaly2 z:-1 parallaxRatio:bgSpeed positionOffset:ccp(1500,winSize.height * 0.9)];

        //별이 지나가는 파티클 추가
        NSArray *starsArray = [NSArray arrayWithObjects:@"playstar1.plist", @"playstar2.plist", @"playstar3.plist", nil];
        for(NSString *stars in starsArray) {
            CCParticleSystemQuad *starsEffect = [CCParticleSystemQuad particleWithFile:stars];
            [self addChild:starsEffect z:1];
        }
        //운석 넣을 배열 선언
        _MeteoGroup = [[NSMutableArray alloc] init];

        //아이템을 넣을 배열 선언
        Items1 = [[NSMutableArray alloc] init];
        Items2 = [[NSMutableArray alloc] init];
        Items3 = [[NSMutableArray alloc] init];
        shield1 = [[NSMutableArray alloc] init];
        shield2 = [[NSMutableArray alloc] init];
        //충돌검사
        [self schedule:@selector(gameLogic:)];
        [self schedule:@selector(itemcheck:) interval:1.0];
        //운석들이 생성되는 로직 실행
        [self schedule:@selector(gameLogic1:) interval:(0.8 + levelspeed)];

        [self schedule:@selector(scorefunc:) interval:0.002];
        
        double curTime = CACurrentMediaTime();
        _gameOverTime = curTime + 30.0;
        [self scheduleUpdate];
    }
    return self;
}

-(void)levelcheck
{
    AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
    
    if(delegate.gameLevel == 1)
    {
        
        levelmaxS = 1;//운석속도 맥스
        levelminS = 1;//운석속도 민
        levelspeed = +1.0;//운석 생성속도
        levellife = 1;//라이프포인트
        levelsecond = 5;//새로운 운석 출몰시간
        levelpoint = 2;
    }
    
    else if(delegate.gameLevel == 2)
    {
        levelmaxS = 0;//운석속도 맥스
        levelminS = 0;//운석속도 민
        levelspeed = 0;//운석 생성속도
        levellife = 0;//라이프포인트
        levelsecond = 0;//새로운 운석 출몰시간
        levelpoint = 3;
    }
    
    else if(delegate.gameLevel == 3)
    {
        levelmaxS = -2;//운석속도 맥스
        levelminS = -0.5;//운석속도 민
        levelspeed = -0.5;//운석 생성속도
        levellife = -1;//라이프포인트
        levelsecond = -5;//새로운 운석 출몰시간
        levelpoint = 4;
    }
    
}


-(void)ufocheck
{
    AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
    
    if(delegate.gameUfo == 1)
    {
    ufo = [CCSprite spriteWithFile:@"ufo1.png"];
    CGSize UFOCenter;
    UFOCenter = _MainUfo.contentSize;
    ufo.position = ccp(UFOCenter.width/2.0,UFOCenter.height/2.0);
    ufo.scale=20;
    [ufo runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:1000]]];
    [_MainUfo addChild:ufo z:10];
    }
    
    else if(delegate.gameUfo == 2)
    {
        ufo = [CCSprite spriteWithFile:@"ufo2.png"];
        CGSize ufocenter;
        ufocenter = _MainUfo.contentSize;
        ufo.position = ccp(ufocenter.width/2.0,ufocenter.height/2.0);
        ufo.scale=20;
        [ufo runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:1000]]];
        
        [_MainUfo addChild:ufo z:10];
    }
    
    else if(delegate.gameUfo == 3)
    {
        ufo = [CCSprite spriteWithFile:@"ufo3.png"];
        CGSize ufocenter;
        ufocenter = _MainUfo.contentSize;
        ufo.position = ccp(ufocenter.width/2.0,ufocenter.height/2.0);
        ufo.scale=20;
        [ufo runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:1000]]];
        
        [_MainUfo addChild:ufo z:10];
    }
}

//아이템과 빨간운석 생성
-(void)itemcheck:(ccTime)dt
{
    item = arc4random() % 200;
    
    if ((item==60||item == 120||item == 180)&&life<3)
    {
       CCSprite *_RedCross = [CCSprite spriteWithFile:@"HpItem.png"];
        int x = (arc4random() % 440)+20;
        int y = (arc4random() % 280)+20;
        _RedCross.position = ccp(x,y);
        _RedCross.scale = 0.78f;
        [self addChild:_RedCross];
        id jump = [CCJumpBy actionWithDuration:20 position:ccp(0,0) height:10 jumps:30];
        [_RedCross runAction:jump];
        [Items1 addObject:_RedCross];
    }
    
    else if ((item == 100||item == 50)&&ShieldOn==0)
    {
        CCSprite *E_Shield = [CCSprite spriteWithFile:@"electricItem.png"];
        int x = (arc4random() % 440)+20;
        int y = (arc4random() % 280)+20;
        E_Shield.position = ccp(x,y);
        E_Shield.scale = 0.78f;
        [self addChild:E_Shield];
        id jump = [CCJumpBy actionWithDuration:20 position:ccp(0,0) height:10 jumps:30];
        [E_Shield runAction:jump];
        [Items2 addObject:E_Shield];
    }
    
    if ((item == 30||item == 150)&&ShieldOn==0)
    {
        CCSprite *F_Shield = [CCSprite spriteWithFile:@"fireItem.png"];
        int x = (arc4random() % 440)+20;
        int y = (arc4random() % 280)+20;
        F_Shield.position = ccp(x,y);
        F_Shield.scale = 0.78f;
        [self addChild:F_Shield];
        id jump = [CCJumpBy actionWithDuration:20 position:ccp(0,0) height:10 jumps:30];
        [F_Shield runAction:jump];
        [Items3 addObject:F_Shield];

    }

    ReRedmeteo = arc4random() % 25;
    if (ReRedmeteo == 1)
    {
        [self performSelector:@selector(redmeteon)];
    }
}
-(void)life5
{
    life = life - 1;
    [self performSelector:@selector(LifeFunction)];
}
//점수 색깔변화 및 시간에 따른 운석 추가
-(void)scorefunc:(ccTime)dt
{
    if(life>=0){
    AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
    
    delegate.gameScore += levelpoint;
    NSString *poins = [[NSString alloc] initWithFormat:@"%6d", delegate.gameScore];

    if(((delegate.gameScore % 1000) == 0)||((delegate.gameScore % 1000) == 1))
    {
        id actionTo1 = [CCScaleTo actionWithDuration:0.1  scale: 1.8];
        id actionTO2 = [CCScaleTo actionWithDuration:0.1  scale: 1.0];
        id actionToAll = [CCSequence actions:actionTo1, actionTO2, nil];
        [point runAction:actionToAll];
    };
        if (delegate.gameScore > 10000)
        {
            point.color = ccc3(255, 228, 0);
        }
        if (delegate.gameScore > 10065)
        {
            point.color = ccc3(255, 255, 255);
        }
        if (delegate.gameScore > 20000)
        {
            point.color = ccc3(0, 216, 255);
        }
        if (delegate.gameScore > 20065)
        {
            point.color = ccc3(255, 255, 255);
        }
        if (delegate.gameScore > 30000)
        {
            point.color = ccc3(225, 0,127);
        }
        if (delegate.gameScore > 30065)
        {
            point.color = ccc3(255, 255, 255);
        }
        if (delegate.gameScore > 40000)
        {
            point.color = ccc3(255,0,0);
        }
        if (delegate.gameScore > 40065)
        {
            point.color = ccc3(255, 255, 255);
        }
        if (delegate.gameScore > 50000)
        {
            point.color = ccc3(29, 219,22);
        }
        if (delegate.gameScore > 50065)
        {
            point.color = ccc3(255, 255, 255);
        }
        
    if ( delegate.gameScore > 1000)
    {
        [self schedule:@selector(gameLogic2:) interval:(1.5 + levelspeed)];
    }
        
    if (delegate.gameScore > 5000)
    {
        [self schedule:@selector(gameLogic3:) interval:(1.8 + levelspeed)];
    }
    if (delegate.gameScore > 10000)
    {
        [self schedule:@selector(gameLogic4:) interval:(1.8 + levelspeed)];
    }
    if (delegate.gameScore > 15000)
    {
        [self schedule:@selector(gameLogic5:) interval:(1.8 + levelspeed)];
    }
    if((delegate.gameScore % 25000) == 0)
    {
        [self performSelector:@selector(levelup)];
    };
       [point setString:poins];
    }
    else {
    }
}

-(void)LifeFunction
{
    if (life == 3)
    {
        [self removeChild:_Hearts cleanup:YES];
        _Hearts = [CCSprite spriteWithFile:@"hp1.png"];
        _Hearts.position = ccp(60,285);
        _Hearts.opacity = 185;
        _Hearts.scale = 0.75;
        [self addChild:_Hearts z:32];
        [_Hearts runAction:[CCBlink actionWithDuration:2 blinks:10]];
    }
    
    else if(life == 2)
    {
        [self removeChild:_Hearts cleanup:YES];
        _Hearts = [CCSprite spriteWithFile:@"hp2.png"];
        _Hearts.position = ccp(60,285);
        _Hearts.opacity = 185;
        _Hearts.scale = 0.75;
        [self addChild:_Hearts z:32];
        [_Hearts runAction:[CCBlink actionWithDuration:2 blinks:10]];
    }
    
    else if(life == 1)
    {
        [self removeChild:_Hearts cleanup:YES];
        _Hearts = [CCSprite spriteWithFile:@"hp3.png"];
        _Hearts.position = ccp(60,285);
        _Hearts.opacity = 185;
        _Hearts.scale = 0.75;
        [self addChild:_Hearts z:32];
        [_Hearts runAction:[CCBlink actionWithDuration:2 blinks:10]];
    }
    
    else if(life == 0)
    {
        [self removeChild:_Hearts cleanup:YES];
        _Hearts = [CCSprite spriteWithFile:@"hp4.png"];
        _Hearts.position = ccp(60,285);
        _Hearts.opacity = 185;
        _Hearts.scale = 0.75;
        [self addChild:_Hearts z:32];
        [_Hearts runAction:[CCBlink actionWithDuration:2 blinks:10]];
        
    }
    else if(life < 0)
    {
        [self doParticle0];
        //폭발하는 에니메이션 실행

        _Sound.effectsVolume = 4;
        [_Sound playEffect:@"boom.wav"];
        
        id actionTo1 = [CCScaleTo actionWithDuration:3  scale:1.6];
        id actionTo2 = [CCMoveTo actionWithDuration:3 position:ccp(240,160)];
        id spawn = [CCSpawn actions:actionTo1,actionTo2, nil];
        
        [point runAction:spawn];
        
        [_MainUfo stopAllActions];
        [self removeChild:_MainUfo cleanup:YES];
        [self removeChild:pausemenu cleanup:YES];

        [self performSelector:@selector(expFinished:) withObject:nil afterDelay:1];
       [self performSelector:@selector(gameover) withObject:nil afterDelay:2];
            }
}


//충돌검사함수 프레임마다
-(void)gameLogic:(ccTime)dt {
    // 게임종료 변수 선언
    if(life>=0){
    if (ShieldOn == 0)
    {
    for (CCSprite *meteo in _MeteoGroup) {
         if (CGRectIntersectsRect(_MainUfo.boundingBox, meteo.boundingBox)) {
           // meteo.visible = NO;
             _Sound.effectsVolume = 3;
             [_Sound playEffect:@"exp.wav"];
             
            [_MainUfo runAction:[CCBlink actionWithDuration:1.0 blinks:9]];
            CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [_MeteoGroup removeObject:node];
            [node removeFromParentAndCleanup:YES];}];
            [meteo runAction:actionMoveDone];
            [self performSelector:@selector(life5)];
             [self doParticle1];
            NSLog(@"Crash1");
        }
    }
    }
    
    else if (ShieldOn == 1)
    {
        for (CCSprite *meteo in _MeteoGroup) {
            if (CGRectIntersectsRect(_MainUfo.boundingBox, meteo.boundingBox)) {
               // meteo.visible = NO;
                _Sound.effectsVolume = 2;
                [_Sound playEffect:@"Surge.caf"];
                CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    [_MeteoGroup removeObject:node];
                    [node removeFromParentAndCleanup:YES];}];
                [meteo runAction:actionMoveDone];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                [self doParticle2];
                NSLog(@"Lightning");
            }
        }
    }

    else if (ShieldOn == 2)
    {
        for (CCSprite *meteo in _MeteoGroup) {
            
            if (CGRectIntersectsRect(_MainUfo.boundingBox, meteo.boundingBox)) {
              //  meteo.visible = NO;
                _Sound.effectsVolume =4;
                [_Sound playEffect:@"get.wav"];
                CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    [_MeteoGroup removeObject:node];
                    [node removeFromParentAndCleanup:YES];
                }];
                [meteo runAction:actionMoveDone];
                
                AppController *delegate = (AppController *)[[UIApplication sharedApplication] delegate];
                delegate.gameScore += 100;
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                [self doParticle3];
                NSLog(@"Fire");
            }
        }
    }
    
    for (CCSprite *obj in Items1) {
        
        if (CGRectIntersectsRect(_MainUfo.boundingBox, obj.boundingBox)) {
            _Sound.effectsVolume = 3;
            [_Sound playEffect:@"hill.caf"];
            CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [Items1 removeObject:node];
                [node removeFromParentAndCleanup:YES];
            }];
            [obj runAction:actionMoveDone];
            if(life<=2||life>0){
                life++;}
            NSLog(@"Item1Get");
        }
    }
    
    for (CCSprite *obj in Items2) {
        
        if (CGRectIntersectsRect(_MainUfo.boundingBox, obj.boundingBox)) {
            _Sound.effectsVolume = 2;
            [_Sound playEffect:@"Surge.caf"];
            CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [Items2 removeObject:node];
                [node removeFromParentAndCleanup:YES];
                if (ShieldOn == 0) {
                    ShieldOn = 1;
                    [self performSelector:@selector(states1:) withObject:nil afterDelay:10];
                }
            }];
            [obj runAction:actionMoveDone];
            
            _BlueShield = [CCSprite spriteWithFile:@"circle1.png"];
            _BlueShield.position = ccp(ufo.contentSize.width/2, ufo.contentSize.height/2);
            [ufo addChild:_BlueShield z:550];
            [_BlueShield runAction:[CCScaleTo actionWithDuration:9 scale:0.2f]];
            [_BlueShield runAction:[CCRotateTo actionWithDuration:10 angle:10000]];
            [shield1 addObject:_BlueShield];
            NSLog(@"Item2Get");
        }
    }
    
    for (CCSprite *obj in Items3) {
        
        if (CGRectIntersectsRect(_MainUfo.boundingBox, obj.boundingBox)) {
            _Sound.effectsVolume = 2;
            [_Sound playEffect:@"fire.wav"];
            CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [Items3 removeObject:node];
                [node removeFromParentAndCleanup:YES];
            }];
            if (ShieldOn == 0) {
                ShieldOn = 2;
                [self performSelector:@selector(states2:) withObject:nil afterDelay:8];
            }

            [obj runAction:actionMoveDone];
            
            _RedShield = [CCSprite spriteWithFile:@"circle2.png"];
            _RedShield.position = ccp(ufo.contentSize.width/2, ufo.contentSize.height/2);
            [ufo addChild:_RedShield z:550];
            [_RedShield runAction:[CCScaleTo actionWithDuration:7 scale:0.2f]];
            [_RedShield runAction:[CCRotateTo actionWithDuration:8 angle:10000]];
            [shield2 addObject:_RedShield];
            NSLog(@"Item3Get");
        }
    }
    
    }
}

//실드 시간 지나면 실행하는 함수
-(void)states1:(ccTime)dt{
    ShieldOn = 0;
    for (CCSprite *obj in shield1) {
        if (ShieldOn==0) {
            obj.visible = NO;
            CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [shield1 removeObject:node];
                [node removeFromParentAndCleanup:YES];
            }];
            [obj runAction:actionMoveDone];
            
        }
    }
    NSLog(@"Timeover");
}
-(void)states2:(ccTime)dt{
    ShieldOn = 0;
    for (CCSprite *obj in shield2) {
        if (ShieldOn==0) {
            obj.visible = NO;
            CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [shield2 removeObject:node];
                [node removeFromParentAndCleanup:YES];
            }];
            [obj runAction:actionMoveDone];
            
        }
    }
    NSLog(@"Timeover");
}


-(void)doParticle0{
    ParticleExplo = [CCParticleFire node];
    ParticleExplo.emitterMode = kCCParticleModeRadius;
    ParticleExplo.scale = 0.5;
    //몇초동안 폭팔을 실행할 것인지
    ParticleExplo.duration = 0.4;
    //앵글 초기회전값 및 변화량
    ParticleExplo.angle = 90;
    ParticleExplo.angleVar = 720;
    //파티클색깔
    ccColor4F startColor = {0.9f, 0, 0, 0.3f};
    ParticleExplo.startColor = startColor;//시작컬러
    ccColor4F startColorVar = {0.9f, 0.3f, 0.2f, 0.5f};
    ParticleExplo.startColorVar = startColorVar; //시작컬러 변화량
    ccColor4F endColor = {0.9f, 0.5f, 0, 0.8f};
    ParticleExplo.endColor = endColor; //종료 컬러값;
    ccColor4F endColorVar = {0.5f, 0, 0, 0.4f};
    ParticleExplo.endColorVar = endColorVar; //종료 컬러변화량
    //파티클 생존시간, 변화량
    ParticleExplo.life = 0.7;
    ParticleExplo.lifeVar = 1;
    ParticleExplo.position = _MainUfo.position;
    [self addChild:ParticleExplo z:39 tag:1];
    //폭발하는 에니메이션 실행
    [self performSelector:@selector(expFinished:) withObject:nil afterDelay:1];
}
-(void)doParticle1{
    ParticelCrash = [CCParticleFire node];
    ParticelCrash.emitterMode = kCCParticleModeRadius;
    ParticelCrash.scale = 0.42;
    ParticelCrash.duration = 0.4;
    ParticelCrash.angle = 90;
    ParticelCrash.angleVar = 720;
    ccColor4F startColor = {0.9f, 0, 0, 0.3f};
    ParticelCrash.startColor = startColor;//시작컬러
    ccColor4F startColorVar = {0.9f, 0.3f, 0.2f, 0.5f};
    ParticelCrash.startColorVar = startColorVar; //시작컬러 변화량
    ccColor4F endColor = {0.9f, 0.5f, 0, 0.8f};
    ParticelCrash.endColor = endColor; //종료 컬러값;
    ccColor4F endColorVar = {0.5f, 0, 0, 0.4f};
    ParticelCrash.endColorVar = endColorVar; //종료 컬러변화량
    ParticelCrash.life = 0.5;
    ParticelCrash.lifeVar = 1;
    ParticelCrash.position = _MainUfo.position;
    [self addChild:ParticelCrash z:900];
    
    [self performSelector:@selector(expFinished:) withObject:nil afterDelay:0.7];
}


//파란실드폭팔
-(void) doParticle2
{
    ParticelBlue = [CCParticleExplosion node];
    ParticelBlue.emitterMode = kCCParticleModeRadius;
    ParticelBlue.scale = 0.295;
    ParticelBlue.duration = 0.4;
    ParticelBlue.angle = 90;
    ParticelBlue.angleVar = 720;
    ccColor4F startColor = {0.0f, 0.0f, 0.9f, 0.3f};
    ParticelBlue.startColor = startColor;//시작컬러
    ccColor4F startColorVar = {0.0f, 0.0f, 0.9f, 0.5f};
    ParticelBlue.startColorVar = startColorVar; //시작컬러 변화량
    ccColor4F endColor = {0.0f, 0.0f, 0.9f, 0.8f};
    ParticelBlue.endColor = endColor; //종료 컬러값;
    ccColor4F endColorVar = {0.0f, 0.0f, 0.9f, 0.4f};
    ParticelBlue.endColorVar = endColorVar; //종료 컬러변화량
    ParticelBlue.life = 0.5;
    ParticelBlue.lifeVar = 1;
    ParticelBlue.position = _MainUfo.position;
    [self addChild:ParticelBlue z:1];
    [self performSelector:@selector(expFinished:) withObject:nil afterDelay:0.7];
    
}

//빨간실드폭팔
-(void) doParticle3
{
    ParticelRed = [CCParticleExplosion node];
    ParticelRed.emitterMode = kCCParticleModeRadius;
    ParticelRed.scale = 0.2;
    ParticelRed.duration = 0.4;
    ParticelRed.angle = 90;
    ParticelRed.angleVar = 720;
    ccColor4F startColor = {0.9f, 0, 0.9f, 0.3f};
    ParticelRed.startColor = startColor;//시작컬러
    ccColor4F startColorVar = {0.9f, 0, 0.9f, 0.5f};
    ParticelRed.startColorVar = startColorVar; //시작컬러 변화량
    ccColor4F endColor = {0.9f, 0, 0.9f, 0.8f};
    ParticelRed.endColor = endColor; //종료 컬러값;
    ccColor4F endColorVar = {0.9f, 0, 0.9f, 0.4f};
    ParticelRed.endColorVar = endColorVar; //종료 컬러변화량
    ParticelRed.life = 0.5;
    ParticelRed.lifeVar = 1;
    ParticelRed.position = _MainUfo.position;
    [self addChild:ParticelRed z:1];
    
    [self performSelector:@selector(expFinished:) withObject:nil afterDelay:0.7];
    
}


-(void)expFinished:(id)sender
{
    [self removeChild:ParticleExplo cleanup:YES];
    [self removeChild:ParticelCrash cleanup:YES];
    [self removeChild:ParticelBlue cleanup:YES];
    [self removeChild:ParticelRed cleanup:YES];
}

-(void)gameLogic1:(ccTime)dt {
    [self addMeteo1];
}
-(void)gameLogic2:(ccTime)dt {
    [self addMeteo2];
}
-(void)gameLogic3:(ccTime)dt {
    [self addMeteo3];
}
-(void)gameLogic4:(ccTime)dt {
    [self addMeteo4];
}
-(void)gameLogic5:(ccTime)dt {
    [self addMeteo5];
}

-(void)gameLogic6
{
    [self redmeteon];
}
-(void)levelup
{
    levelmaxS = levelminS -1;//운석속도 맥스
    levelminS = levelminS - 1;//운석속도 민
    levelspeed = levelspeed + 0.5;//새로운 운석 출몰시간
    levelpoint = levelpoint + 1;
}
// 1번 운석생성 함수
- (void) addMeteo1 {
    
    CCSprite *meteo1 = [CCSprite spriteWithFile:@"meteo01.png"];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = meteo1.contentSize.height / 2;
    int maxY = winSize.height - meteo1.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    meteo1.position = ccp(winSize.width + meteo1.contentSize.width/2+70, actualY);
    [self addChild:meteo1];
    [_MeteoGroup addObject:meteo1];
    
    meteo1.anchorPoint = ccp(0.5,0.5);

    int minDuration = 3.0 + levelminS;
    int maxDuration = 6.0 + levelmaxS;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(-(meteo1.contentSize.width/2+70), actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES]; }];

    id doActions = [CCSequence actions:actionMove, actionMoveDone, nil];
    id Spining = [CCRotateBy actionWithDuration:10 angle:2500];
    id spa = [CCSpawn actions:Spining,doActions, nil];
        [meteo1 runAction:spa];
}
//운석생성함수 2번
- (void) addMeteo2 {
    
        CCSprite *meteo2 = [CCSprite spriteWithFile:@"meteo02.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
  
    int je2 = (arc4random() % 100);
    if (je2>50)
    {_PlusMinus = -1;}
    else if (je2<=50)
    {_PlusMinus = 1;
    }

    int plus = _PlusMinus * ((winSize.width/2)+70);
    int metw = winSize.width/2 + plus;
    int metw2 = winSize.width/2 + (-1*plus);
    int rand = arc4random() % 450;
    int rand2 = arc4random() % 450;

    meteo2.position = ccp(metw,rand);
    [self addChild:meteo2];
    [_MeteoGroup addObject:meteo2];
    meteo2.anchorPoint = ccp(0.5,0.5);

    int minDuration = 3.0 + levelminS;
    int maxDuration = 6.0 + levelmaxS;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    

    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(metw2, rand2)];
    
    
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    id doActions = [CCSequence actions:actionMove, actionMoveDone, nil];
    
    id Spining = [CCRotateBy actionWithDuration:10 angle:2500];
    id MeteoSpawn = [CCSpawn actions:Spining,doActions, nil];
    
    [meteo2 runAction:MeteoSpawn];
}

- (void) addMeteo3 {
    
    CCSprite *meteo3 = [CCSprite spriteWithFile:@"meteo03.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    int je2 = (arc4random() % 100);
    if (je2>50)
    {_PlusMinus = -1;}
    else if (je2<=50)
    {_PlusMinus = 1;
    }

    int plus = _PlusMinus * ((winSize.width/2)+70);
    int metw = winSize.height/2 + plus;
    int metw2 = winSize.height/2 + (-1*plus);
    int rand = arc4random() % 520;
    int rand2 = arc4random() % 520;
    
    meteo3.position = ccp(rand,metw);
    [self addChild:meteo3];
    [_MeteoGroup addObject:meteo3];
    meteo3.anchorPoint = ccp(0.5,0.5);
    
    int minDuration = 6.0 + levelminS;
    int maxDuration = 9.0 + levelmaxS;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(rand2, metw2)];
    
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    id doActions = [CCSequence actions:actionMove, actionMoveDone, nil];
    
    id Spining = [CCRotateBy actionWithDuration:10 angle:2500];
    id MeteoSpawn = [CCSpawn actions:Spining,doActions, nil];
    
    [meteo3 runAction:MeteoSpawn];
}

- (void) addMeteo4 {
    
    CCSprite *meteo4 = [CCSprite spriteWithFile:@"meteo06.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    int je2 = (arc4random() % 100);
    if (je2>50)
    {_PlusMinus = -1;}
    else if (je2<=50)
    {_PlusMinus = 1;
    }
    
    int plus = _PlusMinus * ((winSize.width/2)+70);
    int metw = winSize.width/2 + plus;
    int metw2 = winSize.width/2 + (-1*plus);
    int rand = arc4random() % 450;
    int rand2 = arc4random() % 450;
    
    meteo4.position = ccp(metw,rand);
    [self addChild:meteo4];
    [_MeteoGroup addObject:meteo4];
    meteo4.anchorPoint = ccp(0.5,0.5);
    
    int minDuration = 5.0 + levelminS;
    int maxDuration = 9.0 + levelmaxS;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(metw2, rand2)];
    
    
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    id doActions = [CCSequence actions:actionMove, actionMoveDone, nil];
    
    id Spining = [CCRotateBy actionWithDuration:10 angle:2500];
    id MeteoSpawn = [CCSpawn actions:Spining,doActions, nil];
    
    [meteo4 runAction:MeteoSpawn];
}


- (void) addMeteo5 {
    
    CCSprite *meteo5 = [CCSprite spriteWithFile:@"meteo04.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    int je2 = (arc4random() % 100);
    if (je2>50)
    {_PlusMinus = -1;}
    else if (je2<=50)
    {_PlusMinus = 1;
    }
    
    int plus = _PlusMinus * ((winSize.width)+70);
    int metw = plus;
    int metw2 = (-1*plus);
    int rand = arc4random() % 450;
    int rand2 = arc4random() % 450;
    
    meteo5.position = ccp(metw,rand);
    [self addChild:meteo5];
    [_MeteoGroup addObject:meteo5];
    meteo5.anchorPoint = ccp(0.5,0.5);
    
    int minDuration = 5.0 + levelminS;
    int maxDuration = 9.0 + levelmaxS;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(metw2, rand2)];
    
    
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    id doActions = [CCSequence actions:actionMove, actionMoveDone, nil];
    
    id Spining = [CCRotateBy actionWithDuration:10 angle:2500];
    id MeteoSpawn = [CCSpawn actions:Spining,doActions, nil];
    
    [meteo5 runAction:MeteoSpawn];
}

- (void) redmeteon{
    
    redmeteo = [[CCSprite alloc] initWithFile:@"redmeteo.png"];
    [self addChild:redmeteo z:31 ];
    redmeteo.scale=0.95f;
    redmeteo.visible = NO;
    redmeteo.visible = YES;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCSprite *redmeteoch = [CCSprite spriteWithFile:@"redmeteo.png"];
    CGSize meteocenter;
    meteocenter = redmeteo.contentSize;
    redmeteoch.position = ccp(meteocenter.width/2.0,meteocenter.height/2.0);
    redmeteoch.scale=1.4f;
    
    [redmeteo addChild:redmeteoch z:31];

    int je2 = (arc4random() % 100);
    if (je2>50)
    {_PlusMinus = -1;}
    else if (je2<=50)
    {_PlusMinus = 1;}
    
    int plus = _PlusMinus * ((winSize.width)+200);
    int metw = plus;
    int metw2 = (-1*plus);
    int rand = arc4random() % 500;
    int rand2 = arc4random() % 500;
    
    redmeteo.position = ccp(metw,rand);
    [_MeteoGroup addObject:redmeteo];
    redmeteo.anchorPoint = ccp(0.5,0.5);
    
    int minDuration = 15.0 + levelminS;
    int maxDuration = 20.0 + levelmaxS;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(metw2, rand2)];
    
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];}];
    id doActions = [CCSequence actions:actionMove, actionMoveDone, nil];
    id Spining = [CCRotateBy actionWithDuration:20 angle:2500];
    id MeteoSpawn = [CCSpawn actions:Spining,doActions, nil];
    
    [redmeteo runAction:MeteoSpawn];
}

//이 아래로 터치
-(BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint p = [self convertTouchToNodeSpace:touch ];
    CGRect r = CGRectMake(_MainUfo.position.x-32, _MainUfo.position.y-24,64,64);
    return CGRectContainsPoint(r, p);
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(TouchState != FALSE){//이미 터치한 상태라면 무시
        return NO;
    }
    if(![self containsTouchLocation:touch]){//터치한 곳이 me가 아니면 무시
        return NO;
    }
    TouchState = TRUE;//맞게 터치했으면 이동을 적용
    return YES; 
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];//슬라이드로 이동한것 체크
    _MainUfo.position = CGPointMake(touchPoint.x, touchPoint.y);//이동좌표설정
}
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    TouchState = FALSE;//터치풀기
}
-(void)registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

//게임엔드 씬
- (void)endScene:(EndReason)endReason {
    
    if (_gameOver) return;
    _gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;


    youlose = [CCMenuItemImage itemWithNormalImage:@"youlose.png" selectedImage:@"youlose.png" target:self selector:@selector(doNoting:)];
    youlose.position = ccp(winSize.width/2, winSize.height * 0.7);
    
    restart = [CCMenuItemImage itemWithNormalImage:@"restart2.png" selectedImage:@"restart.png" target:self selector:@selector(restartTapped:)];
    restart.position = ccp(winSize.width/2, winSize.height * 0.45);
    
    gomenu = [CCMenuItemImage itemWithNormalImage:@"menu.png" selectedImage:@"menu2.png" target:self selector:@selector(GoMemu:)];
    gomenu.position = ccp(winSize.width/2, winSize.height * 0.25);
    
    CCMenu *menu = [CCMenu menuWithItems:youlose, restart, gomenu, nil];
    menu.position = CGPointZero;
    menu.scale = 0.1f;
    [self addChild:menu z:500];
    [menu runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];

}
//재시작시 화면전환 효과
- (void)restartTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[Play scene]]];
}
//메뉴로 가는 씬매니저
- (void)GoMemu:(id)sender {
    [SceneManager goMenu];
}
//게임오버 씬으로 이동
-(void)gameover
{
    [self endScene:kEndReasonLose];
    }
- (void)doNoting:(id)sender {
}
-(void)doClick:(id)sender
{
    CCMenuItem *tmenu = (CCMenuItem *)sender;
    NSLog(@" 메뉴 %d ",tmenu.tag);
    
    if (tmenu.tag == 4000)
    {
        [SceneManager goMenu];
    }
    
    if (tmenu.tag == 3000)
    {
        
        [[CCDirector sharedDirector] pause];
        [self removeChild:pausemenu cleanup:YES];
        
        CCMenuItem *resume=[CCMenuItemImage itemWithNormalImage:@"resume.png" selectedImage:@"resume2.png" target:self selector:@selector(doClick:)];
        
        resume.tag = 2000;
        
        CGSize size = [[CCDirector sharedDirector] winSize];

        resumemenu = [CCMenu menuWithItems:resume, nil];
        resumemenu.position=ccp(size.width/2.0+190, size.height/2.0 + 125);
        resumemenu.opacity=180;
        [self addChild:resumemenu z:10];
        pausealert = [CCSprite spriteWithFile:@"pausealert.png"];
        pausealert.position=ccp(size.width/2.0, size.height/2.0);
        [self addChild:pausealert z:50];
        [_Sound playEffect:@"Computer Data 06.caf"];
    }
    
    if (tmenu.tag == 2000)
    {
        [[CCDirector sharedDirector] resume];
        [self removeChild:resumemenu cleanup:YES];
        [self removeChild:pausealert cleanup:YES];
        
        CCMenuItem *pause=[CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage:@"pause2.png" target:self selector:@selector(doClick:)];
        
        pause.tag=3000;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        pausemenu = [CCMenu menuWithItems:pause, nil];
        pausemenu.position=ccp(size.width/2.0+190, size.height/2.0 + 125);
        pausemenu.opacity=180;
        [self addChild:pausemenu z:10];
        
        
    }
    
    
}
//가속센서 체크
- (void)update:(ccTime)delta
{
    CGPoint pos = _MainUfo.position;
    pos.x += playerVelocity.y*-1;
    pos.y += playerVelocity.x;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    float leftBorderLimit = 15;
    float rightBorderLimit = screenSize.width-15 ;
    float topBorderLimit = 15;
    float bottomBorderLimit = screenSize.height -15;
    
    if (pos.x < leftBorderLimit)
    {
        pos.x = leftBorderLimit;
        playerVelocity.x = 0;
    }
    else if (pos.x > rightBorderLimit)
    {
        pos.x = rightBorderLimit;
        playerVelocity.x = 0;
    }
    if (pos.y < topBorderLimit)
    {
        pos.y = topBorderLimit;
        playerVelocity.y = 0;
    }
    else if (pos.y > bottomBorderLimit)
    {
        pos.y = bottomBorderLimit;
        playerVelocity.y = 0;
    }
    _MainUfo.position = pos;
}

//가속센서 조정함수
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    float maxVelocity = 50;
    //세로 가속도계를 가로로 만듬
    CGPoint converted = ccp((float)-acceleration.y,(float)acceleration.x);
    
    _MainUfo.rotation = (float)CC_RADIANS_TO_DEGREES(atan2f(converted.x, converted.y)+M_PI);
    // 현재 가속도계의 가속에 따라 속도 조절
    //가속도센서는 초당 수십회 이상의 입력을 받기때문에 acceleration 객체가 가진 값을 필터링해야 한다.
    //여기서는 DEFAULT_DECELERATION 과 DEFAULT_SENSITIVITY 값에 입력값을 곱하는 방식을 사용하는데 이 값은 사용자가 민감도를 달리 설정할 수 있다.
    playerVelocity.x = playerVelocity.x * DEFAULT_DECELERATION + acceleration.x * DEFAULT_SENSITIVITY;
    playerVelocity.y = playerVelocity.y * DEFAULT_DECELERATION + acceleration.y * DEFAULT_SENSITIVITY;
    
    if (playerVelocity.x > maxVelocity)
    {
        playerVelocity.x = maxVelocity;
    }
    else if (playerVelocity.x < -maxVelocity)
    {
        playerVelocity.x = -maxVelocity;
    }
    
    if (playerVelocity.y > maxVelocity)
    {
        playerVelocity.y = maxVelocity;
    }
    else if (playerVelocity.y < -maxVelocity)
    {
        playerVelocity.y = -maxVelocity;
    }
}



@end