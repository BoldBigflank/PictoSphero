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
    if( (self=[super initWithColor:ccc4(128,128,128,128)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *logoSprite = [CCSprite spriteWithFile:@"error-sphero.png"];
        logoSprite.scale = 0.75 * winSize.height / logoSprite.contentSize.height;
        logoSprite.position = ccp(winSize.width/2, winSize.height - (logoSprite.contentSize.height * logoSprite.scale / 2) );
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
