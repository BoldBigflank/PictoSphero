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
    if( (self=[super initWithColor:ccc4(51,243,232,255)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCParticleSystemQuad *starSplat = [[CCParticleRain alloc] initWithTotalParticles:300];
        starSplat.texture = [[CCTextureCache sharedTextureCache] addImage:@"yellowstar.png"];
        starSplat.duration = -1;
        starSplat.emissionRate = 300;
        starSplat.life = 8;
        starSplat.lifeVar = 4;
        starSplat.startSize = 60;
        starSplat.startSizeVar = 20;
        starSplat.endSize = 20;
        starSplat.endSizeVar = 10;
        starSplat.angle = 180;
        starSplat.angleVar = 180;
        starSplat.rotation = 0;
        starSplat.gravity = ccp(0, -60);
        starSplat.speed = winSize.width/8;
        starSplat.speedVar = 15;
        starSplat.radialAccel = 5;
        starSplat.radialAccelVar = 15;
        starSplat.tangentialAccel = 0;
        starSplat.tangentialAccelVar = 0;
        starSplat.position = ccp(winSize.width/2, winSize.height/2);
        starSplat.posVar = ccp(winSize.width/2, winSize.height/2);
        ccColor4F startColor = {1.0f, 1.0f, 1.0f, 1.0f};
        starSplat.startColor = startColor;
        ccColor4F startColorVar = {0.2f, 0.25f, 0.2f, 0.29f};
        starSplat.startColorVar = startColorVar;
        ccColor4F endColor = {1.0f, 1.0f, 1.0f, 1.0f};
        starSplat.endColor = endColor;
        ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
        starSplat.endColorVar = endColorVar;
        starSplat.autoRemoveOnFinish = YES;
        [self addChild:starSplat];
        
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
