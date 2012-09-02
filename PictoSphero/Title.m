//
//  Title.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Title.h"
#import "AppDelegate.h"
#import "Game.h"

#import "SpheroError.h"
#import "RoundBegin.h"


#define MENU_SOLO 1
#define MENU_TEAM 2



@implementation Title
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Title *layer = [Title node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if( (self=[super initWithColor:ccc4(128,128,128,128)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        logoSprite = [CCSprite spriteWithFile:@"logo.png"];
        logoSprite.scale = 0.75 * winSize.height / logoSprite.contentSize.height;
        logoSprite.position = ccp(winSize.width/2, winSize.height + (logoSprite.contentSize.height * logoSprite.scale / 2) );
        [self addChild: logoSprite];
        
        CCMenu * playMenu = [CCMenu menuWithItems:nil];
        playMenu.position = ccp(0,0);
        CCMenuItemImage *playSolo = [CCMenuItemImage itemWithNormalImage:@"solo.png"
                                                           selectedImage: @"solo.png"
                                                                  target:self
                                                                selector:@selector(playGame:)];
        playSolo.scale = 0.15 * winSize.height / playSolo.contentSize.height;
        playSolo.position = ccp(0.25 * winSize.width, 0.15 * winSize.height);
        playSolo.tag = MENU_SOLO;
		[playMenu addChild:playSolo];
        CCMenuItemImage *playTeam = [CCMenuItemImage itemWithNormalImage:@"team.png"
                                                           selectedImage: @"team.png"
                                                                  target:self
                                                                selector:@selector(playGame:)];
        playTeam.position = ccp(0.75 * winSize.width, 0.15 * winSize.height);
        playTeam.scale = 0.15 * winSize.height / playTeam.contentSize.height;
        playTeam.tag = MENU_TEAM;
		[playMenu addChild:playTeam];
        
        [self addChild:playMenu z:10];

    }
    return self;
}


-(void)onEnterTransitionDidFinish{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // Set the animations
    CCAction *logoAction = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2, winSize.height - (logoSprite.contentSize.height * logoSprite.scale / 2) )];
    
    [logoSprite runAction:logoAction];
    
    
}

-(void)playGame:(CCMenuItem*)menuItem
{
    NSLog(@"playGame %@", [menuItem description]);
    // If there is not a sphero attached, hit the error
    Game *game = [[Game alloc] init];
    game.teams = (menuItem.tag == MENU_SOLO) ? 1 : 2;
    
    //DEBUG
    [game newRound];
    
    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
    [appD setGame:game];
    
    if( [appD robotOnline] == NO ){
        [[CCDirector sharedDirector] pushScene:[SpheroError scene]];
        return;
    }
    
    [[CCDirector sharedDirector] replaceScene:[RoundBegin scene]];
}

@end
