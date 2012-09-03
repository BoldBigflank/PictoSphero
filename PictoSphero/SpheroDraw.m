//
//  SpheroDraw.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SpheroDraw.h"
#import "AppDelegate.h"
#import "Game.h"

#import "Guess.h"
#import "RoundEnd.h"
#import "SimpleAudioEngine.h"


#define GUESS_RED 1
#define GUESS_BLUE 2

@implementation SpheroDraw
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    Guess *guessLayer = [Guess node];
    guessLayer.visible = NO;
    [scene addChild:guessLayer z:1];
    
    RoundEnd *roundEndLayer = [RoundEnd node];
    roundEndLayer.visible = NO;
    [scene addChild:roundEndLayer z:1];
    
    // 'layer' is an autorelease object.
	SpheroDraw *layer = [[SpheroDraw alloc] initWithGuess:guessLayer roundEnd:roundEndLayer];

	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) initWithGuess:(Guess *)guessLayer roundEnd:(RoundEnd *)roundEndLayer
{
    
    if( (self=[super initWithColor:ccc4(51,243,232,255)] )) {
        self.tag = 40;
        redBuzzed = FALSE;
        blueBuzzed = FALSE;
        
        _guessLayer = guessLayer;
        _roundEndLayer = roundEndLayer;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCParticleSystemQuad *starField = [[CCParticleRain alloc] initWithTotalParticles:200];
        starField.texture = [[CCTextureCache sharedTextureCache] addImage:@"question.png"];
        starField.duration = -1;
        starField.life = 8;
        starField.lifeVar = 0;
        starField.startSize = 10;
        starField.startSizeVar = 10;
        starField.endSize = 60;
        starField.endSizeVar = 10;
        starField.angle = 180;
        starField.angleVar = 180;
        starField.rotation = 15;
        starField.gravity = ccp(0, 15);
        starField.speed = winSize.width/8;
        starField.speedVar = 40;
        starField.radialAccel = 5;
        starField.radialAccelVar = 15;
        starField.tangentialAccel = 0;
        starField.tangentialAccelVar = 0;
        starField.position = ccp(winSize.width/2, winSize.height/2);
        starField.posVar = ccp(winSize.width/2, winSize.height/2);
        ccColor4F startColor = {1.0f, 1.0f, 1.0f, 1.0f};
        ccColor4F startColorVar = {0.2f, 0.25f, 0.2f, 0.29f};
        ccColor4F endColor = {1.0f, 1.0f, 1.0f, 1.0f};
        ccColor4F endColorVar = {0.0f, 0.0f, 0.0f};
        starField.startColor = startColor;
        starField.startColorVar = startColorVar;
        starField.endColor = endColor;
        starField.endColorVar = endColorVar;
        [self addChild:starField];
        
        AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
        Game *game = [appD game];
        
        
        // Game newRound
        [game newRound];
        // Guess loadEntries
        [guessLayer setupChoices:[game choices]];
        
        [appD showSpheroTail:NO];
        [appD setKeepRolling:YES];
        [appD moveToPoint:ccp(0,0)];
        timer = (float)game.timer;
        
        // Red and blue scores
        CCLabelTTF *redScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", game.redScore] fontName:@"Arial" fontSize:24];
        redScore.color = ccc3(255, 0, 0);
        redScore.scale = .1 * winSize.height / redScore.contentSize.height;
        redScore.position = ccp(0.25 * winSize.width, winSize.height - (redScore.contentSize.height * redScore.scale / 2) );
        [self addChild:redScore];
        
        CCLabelTTF *blueScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", game.blueScore] fontName:@"Arial" fontSize:24];
        blueScore.color = ccc3(0, 0, 255);
        blueScore.scale = .1 * winSize.height / blueScore.contentSize.height;
        blueScore.position = ccp(0.75 * winSize.width, winSize.height - (blueScore.contentSize.height * blueScore.scale / 2) );
        [self addChild:blueScore];
        
        
        // Timer
        timerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", game.timer] fontName:@"Arial" fontSize:48];
        timerLabel.color = ccc3(255, 255, 0);
        timerLabel.scale = .3 * winSize.height / timerLabel.contentSize.height;
        timerLabel.position = ccp(0.5 * winSize.width, winSize.height - (timerLabel.contentSize.height * timerLabel.scale / 2) );
        [self addChild:timerLabel];
        
        // Red and blue buttons
        BuzzMenu = [CCMenu menuWithItems:nil];
        BuzzMenu.position = ccp(0,0);
        CCMenuItemImage *buzzRed = [CCMenuItemImage itemWithNormalImage:@"buzz-red.png"
                                                           selectedImage: @"buzz-red.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        buzzRed.scale = 0.7 * winSize.height / buzzRed.contentSize.width;
        buzzRed.position = ccp(0.25 * winSize.width, 0.45 * winSize.height);
        buzzRed.color = ccc3(255, 0, 0);
        buzzRed.rotation = 90;
        buzzRed.tag = GUESS_RED;
		[BuzzMenu addChild:buzzRed];
        CCMenuItemImage *buzzBlue = [CCMenuItemImage itemWithNormalImage:@"buzz-blue.png"
                                                           selectedImage: @"buzz-blue.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        buzzBlue.position = ccp(0.75 * winSize.width, 0.45 * winSize.height);
        buzzBlue.scale = 0.7 * winSize.height / buzzBlue.contentSize.width;
        buzzBlue.color = ccc3(0, 0, 255);
        buzzBlue.rotation = -90;
        buzzBlue.tag = GUESS_BLUE;
		[BuzzMenu addChild:buzzBlue];
        
        [self addChild:BuzzMenu z:9];
        
    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Jaazz.wav" loop:YES];
    
    
    return self;
}

-(void)onEnterTransitionDidFinish{
    // Fire up the sphero ball
    
    // Fire off the timer
    [self schedule: @selector(tick2:) interval:0.1];
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCParticleRain *explosion = [[CCParticleRain alloc] initWithTotalParticles:200];
    explosion.texture = [[CCTextureCache sharedTextureCache] addImage:@"yellowstar.png"];
    explosion.duration = .5;
    explosion.emissionRate = 800;
    explosion.life = .4;
    explosion.lifeVar = .3;
    explosion.startSize = 40;
    explosion.startSizeVar = 30;
    explosion.endSize = 0;
    explosion.endSizeVar = 0;
    explosion.angle = 0;
    explosion.angleVar = 360;
    explosion.rotation = 0;
    explosion.gravity = CGPointZero;
    explosion.speed = 72;
    explosion.speedVar = 0;
    explosion.radialAccel = 756.5;
    explosion.radialAccelVar = 50;
    explosion.tangentialAccel = 0;
    explosion.tangentialAccelVar = 0;
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    explosion.position = location;
    explosion.posVar = ccp(0,0);
    ccColor4F startColor = {1.0f, 0.16f, 0.0f, 1.0f};
    explosion.startColor = startColor;
    ccColor4F startColorVar = {0.0f, 0.45f, 0.0f, 0.31f};
    explosion.startColorVar = startColorVar;
    ccColor4F endColor = {0.31f, 0.08f, 0.0f, 1.0f};
    explosion.endColor = endColor;
    ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    explosion.endColorVar = endColorVar;
    explosion.autoRemoveOnFinish = YES;
    [self addChild:explosion];
    return TRUE;
}

-(void)makeGuess:(CCMenuItem*)menuItem
{
    if(menuItem.tag == GUESS_RED && redBuzzed) return;
    if(menuItem.tag == GUESS_BLUE && blueBuzzed) return;
    guesser = menuItem.tag;
    
//    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
//    Game *game = [appD game];
    
    BuzzMenu.isTouchEnabled = FALSE;
    ccColor3B guessColor = (menuItem.tag == GUESS_RED) ? ccc3(255, 0, 0) : ccc3(0, 0, 255);

    if(menuItem.tag == GUESS_RED) redBuzzed = true;
    if(menuItem.tag == GUESS_BLUE) blueBuzzed = true;
    
    [_guessLayer showGuess:guessColor];
    [self unschedule:@selector(tick2:)];
    _guessLayer.visible = YES;
    _guessLayer.scale = 0;
    [_guessLayer runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
}

-(void)returnWithGuess:(int)guessNumber{
    NSLog(@"returnWithGuess %i", guessNumber);
    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
    Game *game = [appD game];

    if(guessNumber == 0){ // Correct number
        _roundEndLayer.visible = YES;
        if(guesser == GUESS_RED) game.redScore += 1;
        if(guesser == GUESS_BLUE) game.blueScore += 1;
        NSString * winnerString = (guesser == GUESS_RED) ? @"red" : @"blue";
        [self endRound:winnerString];
    } else {
        if(redBuzzed && blueBuzzed){
            [self endRound:@""];
        }
        else{
            _guessLayer.visible = NO;
            BuzzMenu.isTouchEnabled = YES;
            [self schedule: @selector(tick2:) interval:0.1];
        }
    }
//    _guessLayer.isTouchEnabled = FALSE;
    
}

-(void) tick2: (ccTime) dt
{
    timer -= dt;
    timerLabel.string = [NSString stringWithFormat:@"%i", (int)timer];
    if(timer < 1){
        NSLog(@"Time's up!");
        [self endRound:@""];

        //[[CCDirector sharedDirector] replaceScene:[RoundEnd scene]];
    }
    
}
-(void) endRound:(NSString*)winner
{
    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
    [appD setKeepRolling:NO];
    [self unschedule:@selector(tick2:)];
    BuzzMenu.isTouchEnabled = NO;
    [_roundEndLayer setWinner:winner];
    _roundEndLayer.visible = YES;
    _roundEndLayer.scale = 0;
    _roundEndLayer.isTouchEnabled = YES;
    _guessLayer.isTouchEnabled = NO;
    //[_guessLayer runAction:[CCScaleTo actionWithDuration:0.5 scale:0.0]];
    [_roundEndLayer runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
}

@end
