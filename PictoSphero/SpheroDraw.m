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
    
    if( (self=[super initWithColor:ccc4(128,128,128,128)] )) {
        self.tag = 40;
        redBuzzed = FALSE;
        blueBuzzed = FALSE;
        
        _guessLayer = guessLayer;
        _roundEndLayer = roundEndLayer;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
        Game *game = [appD game];
        
        // Game newRound
        [game newRound];
        // Guess loadEntries
        
        
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
        timerLabel.color = ccc3(0, 255, 0);
        timerLabel.scale = .3 * winSize.height / timerLabel.contentSize.height;
        timerLabel.position = ccp(0.5 * winSize.width, winSize.height - (timerLabel.contentSize.height * timerLabel.scale / 2) );
        [self addChild:timerLabel];
        
        // Red and blue buttons
        BuzzMenu = [CCMenu menuWithItems:nil];
        BuzzMenu.position = ccp(0,0);
        CCMenuItemImage *buzzRed = [CCMenuItemImage itemWithNormalImage:@"buzz.png"
                                                           selectedImage: @"buzz.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        buzzRed.scale = 0.7 * winSize.height / buzzRed.contentSize.width;
        buzzRed.position = ccp(0.25 * winSize.width, 0.45 * winSize.height);
        buzzRed.color = ccc3(255, 0, 0);
        buzzRed.rotation = 90;
        buzzRed.tag = GUESS_RED;
		[BuzzMenu addChild:buzzRed];
        CCMenuItemImage *buzzBlue = [CCMenuItemImage itemWithNormalImage:@"buzz.png"
                                                           selectedImage: @"buzz.png"
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
    return self;
}

-(void)onEnterTransitionDidFinish{
    // Fire up the sphero ball
    
    
    // Fire off the timer
    [self schedule: @selector(tick2:) interval:0.1];
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

    if(guessNumber == 1){ // Correct number
        _roundEndLayer.visible = YES;
        if(guesser == GUESS_RED) game.redScore += 1;
        if(guesser == GUESS_BLUE) game.blueScore += 1;
        _roundEndLayer.visible = YES;
        _roundEndLayer.scale = 0;
        _roundEndLayer.isTouchEnabled = YES;
        NSString * winnerString = (guesser == GUESS_RED) ? @"red" : @"blue";
        [_roundEndLayer setWinner:winnerString];
        _guessLayer.isTouchEnabled = NO;
        //[_guessLayer runAction:[CCScaleTo actionWithDuration:0.5 scale:0.0]];
        [_roundEndLayer runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    } else {
        if(redBuzzed && blueBuzzed){
            [self endRound];
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
        [self endRound];

        //[[CCDirector sharedDirector] replaceScene:[RoundEnd scene]];
    }
    
}
-(void) endRound
{
    [self unschedule:@selector(tick2:)];
    BuzzMenu.isTouchEnabled = NO;
    [_roundEndLayer setWinner:@""];
    _roundEndLayer.visible = YES;
    _roundEndLayer.scale = 0;
    _roundEndLayer.isTouchEnabled = YES;
    _guessLayer.isTouchEnabled = NO;
    //[_guessLayer runAction:[CCScaleTo actionWithDuration:0.5 scale:0.0]];
    [_roundEndLayer runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
}

@end
