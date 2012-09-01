//
//  GameEnd.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameEnd.h"


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
        NSString *className = [NSString stringWithFormat:@"Class %@", [[self class] description]];
        CCLabelTTF *label = [CCLabelTTF labelWithString:className fontName:@"Marker Felt" fontSize:64];
        
		// position the label on the center of the screen
		label.position =  ccp( winSize.width /2 , winSize.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
    }
    return self;
}
@end
