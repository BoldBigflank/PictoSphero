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
	
	// 'layer' is an autorelease object.
	SpheroDraw *layer = [SpheroDraw node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    Guess *guessLayer = [Guess node];
    [scene addChild:guessLayer];
    
	// return the scene
	return scene;
}
-(id) init
{
    if( (self=[super initWithColor:ccc4(128,128,128,128)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
        Game *game = [appD game];
        
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
        CCMenu * playMenu = [CCMenu menuWithItems:nil];
        playMenu.position = ccp(0,0);
        CCMenuItemImage *playSolo = [CCMenuItemImage itemWithNormalImage:@"buzz.png"
                                                           selectedImage: @"buzz.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        playSolo.scale = 0.15 * winSize.height / playSolo.contentSize.height;
        playSolo.position = ccp(0.25 * winSize.width, 0.15 * winSize.height);
        playSolo.tag = GUESS_RED;
		[playMenu addChild:playSolo];
        CCMenuItemImage *playTeam = [CCMenuItemImage itemWithNormalImage:@"buzz.png"
                                                           selectedImage: @"buzz.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        playTeam.position = ccp(0.75 * winSize.width, 0.15 * winSize.height);
        playTeam.scale = 0.15 * winSize.height / playTeam.contentSize.height;
        playTeam.tag = GUESS_BLUE;
		[playMenu addChild:playTeam];
        
        [self addChild:playMenu z:10];
        
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
    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
    Game *game = [appD game];
    ccColor4B guessColor = (menuItem.tag == GUESS_RED) ? ccc4(255, 0, 0, 255) : ccc4(0, 0, 255, 255);
    game.guessColor = guessColor;
    
    [[CCDirector sharedDirector] pushScene:[Guess scene]];
}

-(void) tick2: (ccTime) dt
{
    timer -= dt;
    timerLabel.string = [NSString stringWithFormat:@"%i", (int)timer];
    if(timer <= 0){
        NSLog(@"Time's up!");
        [self unschedule:@selector(tick2:)];
        [[CCDirector sharedDirector] replaceScene:[RoundEnd scene]];
    }
    
}

@end
