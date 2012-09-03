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
    if( (self=[super initWithColor:ccc4(13,217,133,255)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCParticleSystemQuad *starSplat = [[CCParticleRain alloc] initWithTotalParticles:300];
        starSplat.texture = [[CCTextureCache sharedTextureCache] addImage:@"star.png"];
        starSplat.duration = 1;
        starSplat.emissionRate = 3200;
        starSplat.life = 8;
        starSplat.lifeVar = 0;
        starSplat.startSize = 20;
        starSplat.startSizeVar = 1;
        starSplat.endSize = 20;
        starSplat.endSizeVar = 10;
        starSplat.angle = 180;
        starSplat.angleVar = 0;
        starSplat.rotation = 0;
        starSplat.gravity = ccp(0, 0);
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
        
        CCParticleSystemQuad *starField = [[CCParticleRain alloc] initWithTotalParticles:400];
        starField.texture = [[CCTextureCache sharedTextureCache] addImage:@"star.png"];
        starField.duration = -1;
        starField.life = 8;
        starField.lifeVar = 0;
        starField.startSize = 20;
        starField.startSizeVar = 1;
        starField.endSize = 20;
        starField.endSizeVar = 10;
        starField.angle = 180;
        starField.angleVar = 0;
        starField.rotation = 0;
        starField.gravity = ccp(0, 0);
        starField.speed = winSize.width/8;
        starField.speedVar = 15;
        starField.radialAccel = 5;
        starField.radialAccelVar = 15;
        starField.tangentialAccel = 0;
        starField.tangentialAccelVar = 0;
        starField.position = ccp(winSize.width, winSize.height/2);
        starField.posVar = ccp(0, winSize.height/2);
        starField.startColor = startColor;
        starField.startColorVar = startColorVar;
        starField.endColor = endColor;
        starField.endColorVar = endColorVar;
        [self addChild:starField];

        logoSprite = [CCSprite spriteWithFile:@"logo.png"];
        logoSprite.scale = 0.75 * winSize.height / logoSprite.contentSize.height;
        logoSprite.position = ccp(winSize.width/2, winSize.height + (logoSprite.contentSize.height * logoSprite.scale / 2) );
        [self addChild: logoSprite];
        
        CCMenu * playMenu = [CCMenu menuWithItems:nil];
        playMenu.position = ccp(0,0);
//        CCMenuItemImage *playSolo = [CCMenuItemImage itemWithNormalImage:@"solo.png"
//                                                           selectedImage: @"solo.png"
//                                                                  target:self
//                                                                selector:@selector(playGame:)];
//        playSolo.scale = 0.15 * winSize.height / playSolo.contentSize.height;
//        playSolo.position = ccp(0.25 * winSize.width, 0.15 * winSize.height);
//        playSolo.tag = MENU_SOLO;
//		[playMenu addChild:playSolo];
        CCMenuItemImage *playTeam = [CCMenuItemImage itemWithNormalImage:@"team.png"
                                                           selectedImage: @"team.png"
                                                                  target:self
                                                                selector:@selector(playGame:)];
        playTeam.position = ccp(0.5 * winSize.width, 0.15 * winSize.height);
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

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
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
