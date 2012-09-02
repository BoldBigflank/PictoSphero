//
//  RoundEnd.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundEnd.h"
#import "AppDelegate.h"
#import "Game.h"

#import "RoundBegin.h"
#import "GameEnd.h"


@implementation RoundEnd
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	RoundEnd *layer = [RoundEnd node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init
{
    if( (self=[super initWithColor:ccc4(128,128,128,128)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        NSString *className = [NSString stringWithFormat:@"Class %@", [[self class] description]];
        CCLabelTTF *label = [CCLabelTTF labelWithString:className fontName:@"Marker Felt" fontSize:64];
        
		// position the label on the center of the screen
		label.position =  ccp( winSize.width /2 , winSize.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];

        // Next button
        
        CCMenu * playMenu = [CCMenu menuWithItems:nil];
        playMenu.position = ccp(0,0);
        CCMenuItemImage *okButton = [CCMenuItemImage itemWithNormalImage:@"ok.png"
                                                           selectedImage: @"ok.png"
                                                                  target:self
                                                                selector:@selector(okPressed:)];
        okButton.scale = 0.15 * winSize.height / okButton.contentSize.height;
        okButton.position = ccp(0.8 * winSize.width, 0.15 * winSize.height);
		
        [playMenu addChild:okButton];
        
        [self addChild:playMenu z:10];
        
    }
    return self;
}

-(void)setWinner:(NSString *)winner{
    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
    Game *game = [appD game];
    
    NSLog(@"setWinner");
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // red, blue, none
    if(winner != @""){ // No winner
        winnerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ wins the round!", [winner capitalizedString]] fontName:@"Arial" fontSize:48];
        winnerLabel.color = ccc3(0, 0, 0);
        winnerLabel.scale = .15 * winSize.height / winnerLabel.contentSize.height;
        winnerLabel.position = ccp(0.5 * winSize.width, winSize.height - (winnerLabel.contentSize.height * winnerLabel.scale / 2) );
        [self addChild:winnerLabel];
    }

    picture = [CCSprite spriteWithFile:game.currentImage];
    picture.position = ccp(winSize.width/2, winSize.height/2);
    picture.scale = 0.75 * winSize.height / picture.contentSize.height;
    [self addChild: picture];
    
}

-(void)okPressed:(CCMenuItem*)menuItem
{
    NSLog(@"okPressed %@", [menuItem description]);
    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
    Game *game = [appD game];
    if(game.redScore >= game.maxScore || game.blueScore >= game.maxScore){
        [[CCDirector sharedDirector] replaceScene:[GameEnd scene]];
    }
    else
        [[CCDirector sharedDirector] replaceScene:[RoundBegin scene]];
    
}
@end
