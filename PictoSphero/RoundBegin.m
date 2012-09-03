//
//  Intro.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundBegin.h"
#import "AppDelegate.h"
#import "Game.h"

#import "SpheroDraw.h"


@implementation RoundBegin
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	RoundBegin *layer = [RoundBegin node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init
{
    if( (self=[super initWithColor:ccc4(13,217,133,255)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // Scores labels, table/ball sprites, Round number, Go button
        CCParticleSystemQuad *starSplat = [[CCParticleRain alloc] initWithTotalParticles:300];
        starSplat.texture = [[CCTextureCache sharedTextureCache] addImage:@"yellowstar.png"];
        starSplat.duration = 1;
        starSplat.emissionRate = 3200;
        starSplat.life = 8;
        starSplat.lifeVar = 0;
        starSplat.startSize = 20;
        starSplat.startSizeVar = 1;
        starSplat.endSize = 10;
        starSplat.endSizeVar = 10;
        starSplat.angle = 180;
        starSplat.angleVar = 180;
        starSplat.rotation = 0;
        starSplat.gravity = ccp(0, 5);
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
        ccColor4F endColorVar = {0.5f, 0.5f, 0.5f, 0.5f};
        starSplat.endColorVar = endColorVar;
        starSplat.autoRemoveOnFinish = YES;
        [self addChild:starSplat];
        
        
        
        AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
        Game *game = [appD game];

        CCSprite * roundLabel = [CCSprite spriteWithFile:@"round.png"];
        roundLabel.scale = 0.15 * winSize.height / roundLabel.contentSize.height;
        roundLabel.position = ccp(0.5 * winSize.width, winSize.height - (roundLabel.contentSize.height * roundLabel.scale / 2));
        
        [self addChild: roundLabel];
        
//        CCSprite *roundNumber = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%i.png", game.roundNumber]];
//        roundNumber.scale = roundLabel.contentSize.height * roundLabel.scale / roundNumber.contentSize.height;
//        roundNumber.position = ccp(0.5 * winSize.width, winSize.height - (roundNumber.contentSize.height * roundNumber.scale / 2) - (roundLabel.contentSize.height * roundLabel.scale) );
//        [self addChild:roundNumber];
        
        CCLabelTTF *roundNumber = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", game.roundNumber] fontName:@"Arial" fontSize:24];
        roundNumber.color = ccc3(128, 128, 255);
        roundNumber.scale = roundLabel.contentSize.height * roundLabel.scale / roundNumber.contentSize.height;
        roundNumber.position = ccp(0.5 * winSize.width, winSize.height - (roundNumber.contentSize.height * roundNumber.scale / 2) - (roundLabel.contentSize.height * roundLabel.scale) );
        [self addChild:roundNumber];

        CCSprite * redLabel = [CCSprite spriteWithFile:@"red-large.png"];
        redLabel.scale = 0.15 * winSize.height / redLabel.contentSize.height;
        redLabel.position = ccp(0.15 * winSize.width, winSize.height - (redLabel.contentSize.height * redLabel.scale / 2));
        
        [self addChild: redLabel];
        
        CCLabelTTF *redScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", game.redScore] fontName:@"Arial" fontSize:24];
        redScore.color = ccc3(255, 0, 0);
        redScore.scale = redLabel.contentSize.height * redLabel.scale / redScore.contentSize.height;
        redScore.position = ccp(0.15 * winSize.width, winSize.height - (redScore.contentSize.height * redScore.scale / 2) - (redLabel.contentSize.height * redLabel.scale) );
        [self addChild:redScore];
        
        
        CCSprite *blueLabel = [CCSprite spriteWithFile:@"blue-large.png"];
        blueLabel.scale = 0.15 * winSize.height / blueLabel.contentSize.height;
        blueLabel.position = ccp(0.85 * winSize.width, winSize.height - (blueLabel.contentSize.height * blueLabel.scale / 2));
        
        [self addChild:blueLabel];
        
        CCLabelTTF *blueScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", game.blueScore] fontName:@"Arial" fontSize:24];
        blueScore.color = ccc3(0, 0, 255);
        blueScore.scale = blueLabel.contentSize.height * blueLabel.scale / blueScore.contentSize.height;
        blueScore.position = ccp(0.85 * winSize.width, winSize.height - (blueScore.contentSize.height * blueScore.scale / 2) - (blueLabel.contentSize.height * blueLabel.scale) );
        [self addChild:blueScore];
        
        floor = [CCSprite spriteWithFile:@"instruction-floor.png"];
        floor.scale = 0.5 * winSize.height / floor.contentSize.height;
        floor.position = ccp(0.5 * winSize.width, (floor.contentSize.height * floor.scale / 2));
        [self addChild:floor];
        
        sphero = [CCSprite spriteWithFile:@"sphero.png"];
        sphero.scale = floor.scale;
        sphero.position = ccp(floor.position.x, floor.position.y + (floor.contentSize.height * floor.scale / 2));
        [self addChild:sphero];
        
        CCLabelTTF *instructionLabel = [CCLabelTTF labelWithString:@"Place the Sphero in the middle of the floor with the tail pointing 'down'." fontName:@"Arial" fontSize:24];
        instructionLabel.color = ccc3(255,255,0 );
        instructionLabel.position = ccp(0.5 * winSize.width, .6 * winSize.height );
        [self addChild:instructionLabel];
        
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

-(void)okPressed:(CCMenuItem*)menuItem
{
    NSLog(@"okPressed %@", [menuItem description]);
    [[CCDirector sharedDirector] replaceScene:[SpheroDraw scene]];
    
}

-(void) onEnterTransitionDidFinish{
    CCAction *dropBall = [CCMoveTo actionWithDuration:1 position:ccp(floor.position.x, floor.position.y - (0.1*floor.contentSize.height) )];
    
    [sphero runAction:dropBall];
    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
    [appD setKeepRolling:NO];
    [appD moveToPoint:ccp(0,0)];
    [appD showSpheroTail:YES];
}
@end
