//
//  GameEnd.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameEnd.h"
#import "AppDelegate.h"
#import "Game.h"

#import "Title.h"


@implementation GameEnd
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameEnd *layer = [GameEnd node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init
{
    if( (self=[super initWithColor:ccc4(128,128,128,128)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
        Game *game = [appD game];
        NSString *teamString = (game.redScore > game.blueScore) ? @"red-large.png" : @"blue-large.png";
        NSString *winString = (game.redScore > game.blueScore) ? @"red-wins.png" : @"blue-wins.png";
        
        CCSprite *logoSprite = [CCSprite spriteWithFile:teamString];
        logoSprite.scale = 0.35 * winSize.height / logoSprite.contentSize.height;
        logoSprite.position = ccp(winSize.width/2, (.75* winSize.height) );
        [self addChild: logoSprite];
        
        CCSprite *winSprite = [CCSprite spriteWithFile:winString];
        winSprite.scale = 0.35 * winSize.height / winSprite.contentSize.height;
        winSprite.position = ccp(winSize.width/2, (0.4 * winSize.height) );
        [self addChild: winSprite];
        
        CCMenu * playMenu = [CCMenu menuWithItems:nil];
        playMenu.position = ccp(0,0);
        CCMenuItemImage *okButton = [CCMenuItemImage itemWithNormalImage:@"ok.png"
                                                           selectedImage: @"ok.png"
                                                                  target:self
                                                                selector:@selector(okPressed:)];
        okButton.scale = 0.15 * winSize.height / okButton.contentSize.height;
        okButton.position = ccp(0.5 * winSize.width, 0.15 * winSize.height);
		
        [playMenu addChild:okButton];
        [self addChild:playMenu];
        
    }
    return self;
}

-(void)okPressed:(CCMenuItem*)menuItem
{
    NSLog(@"okPressed %@", [menuItem description]);
    [[CCDirector sharedDirector] replaceScene:[Title scene]];
    
}

@end
