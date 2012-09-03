//
//  Error.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SpheroError.h"
#import "AppDelegate.h"

#import "Title.h"


@implementation SpheroError
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SpheroError *layer = [SpheroError node];
	
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
        starSplat.texture = [[CCTextureCache sharedTextureCache] addImage:@"sphero.png"];
        starSplat.duration = -1;
        starSplat.emissionRate = 300;
        starSplat.life = 4;
        starSplat.lifeVar = 3;
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
        ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
        starSplat.endColorVar = endColorVar;
        [self addChild:starSplat];
        
        CCSprite *logoSprite = [CCSprite spriteWithFile:@"error-sphero.png"];
        logoSprite.scale = 0.75 * winSize.height / logoSprite.contentSize.height;
        logoSprite.position = ccp(winSize.width/2, winSize.height - (logoSprite.contentSize.height * logoSprite.scale / 2) );
//        logoSprite.color = ccc3(0,0,0);
        [self addChild: logoSprite];
        
        CCMenu * playMenu = [CCMenu menuWithItems:nil];
        playMenu.position = ccp(0,0);
        CCMenuItemImage *okButton = [CCMenuItemImage itemWithNormalImage:@"ok.png"
                                                           selectedImage: @"ok.png"
                                                                  target:self
                                                                selector:@selector(okPressed:)];
        okButton.scale = 0.15 * winSize.height / okButton.contentSize.height;
        okButton.position = ccp(0.5 * winSize.width, 0.15 * winSize.height);
		
        [playMenu addChild:okButton];
        
        [self addChild:playMenu z:10];
    }
    return self;
}

-(void)okPressed:(CCMenuItem*)menuItem
{
    NSLog(@"okPressed %@", [menuItem description]);
    AppController *appD = (AppController *)[[UIApplication sharedApplication] delegate];
    [appD setupRobotConnection];
    [[CCDirector sharedDirector] replaceScene:[Title scene]];

}

@end
