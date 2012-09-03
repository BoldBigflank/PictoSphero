//
//  Guess.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Guess.h"
#import "AppDelegate.h"
#import "Game.h"
#import "SpheroDraw.h"


#define GUESS_A 1
#define GUESS_B 2
#define GUESS_C 3
#define GUESS_D 4

@implementation Guess
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Guess *layer = [Guess node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init
{
    if( (self=[super init] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        NSString *className = [NSString stringWithFormat:@"Class %@", [[self class] description]];
        CCLabelTTF *label = [CCLabelTTF labelWithString:className fontName:@"Marker Felt" fontSize:64];
        
		// position the label on the center of the screen
		label.position =  ccp( winSize.width /2 , winSize.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        backgroundColor = [CCSprite spriteWithFile:@"blank.png"];
        [backgroundColor setTextureRect:CGRectMake( 0, 0, winSize.width, winSize.height)];
        backgroundColor.color = ccc3(255,255,255);
        backgroundColor.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backgroundColor z:10];
        
        guessMenu = [CCMenu menuWithItems:nil];
        guessMenu.position = ccp(0,0);
        CCMenuItemImage *guessA = [CCMenuItemImage itemWithNormalImage:@"blanklabel.png"
                                                           selectedImage: @"blanklabel.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        guessA.scale = 0.4 * winSize.height / guessA.contentSize.height;
        guessA.position = ccp(0.25 * winSize.width, 0.75 * winSize.height);
        guessA.tag = GUESS_A;

		[guessMenu addChild:guessA];
        CCMenuItemImage *guessB = [CCMenuItemImage itemWithNormalImage:@"blanklabel.png"
                                                           selectedImage: @"blanklabel.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        guessB.position = ccp(0.75 * winSize.width, 0.75 * winSize.height);
        guessB.scale = 0.4 * winSize.height / guessB.contentSize.height;
        guessB.tag = GUESS_B;
		[guessMenu addChild:guessB];
        
        CCMenuItemImage *guessC = [CCMenuItemImage itemWithNormalImage:@"blanklabel.png"
                                                           selectedImage: @"blanklabel.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        guessC.scale = 0.4 * winSize.height / guessC.contentSize.height;
        guessC.position = ccp(0.25 * winSize.width, 0.25 * winSize.height);
        guessC.tag = GUESS_C;
		[guessMenu addChild:guessC];
        CCMenuItemImage *guessD = [CCMenuItemImage itemWithNormalImage:@"blanklabel.png"
                                                           selectedImage: @"blanklabel.png"
                                                                  target:self
                                                                selector:@selector(makeGuess:)];
        guessD.position = ccp(0.75 * winSize.width, 0.25 * winSize.height);
        guessD.scale = 0.4 * winSize.height / guessD.contentSize.height;
        guessD.tag = GUESS_D;
		[guessMenu addChild:guessD];
        
        [self addChild:guessMenu z:10];        
        
    }
    return self;
}

-(void)makeGuess:(CCMenuItem*)menuItem
{
    NSLog(@"makeGuess %d", menuItem.tag);
    [(SpheroDraw *)[[self parent] getChildByTag:40] returnWithGuess:menuItem.tag];
}

-(void)showGuess:(ccColor3B)color{
    // Change the background sprite to the color
    backgroundColor.color = color;
    
    // 
}

-(void)setupChoices:(NSArray *)choices{
    NSMutableArray *availableChoices = [NSMutableArray arrayWithArray:choices];
    for(CCMenuItem *menuItem in [guessMenu children]){
        int choiceNumber = arc4random() % availableChoices.count;
        menuItem.tag = [choices indexOfObject:[availableChoices objectAtIndex:choiceNumber]];
        NSString *prettyString = [[availableChoices objectAtIndex:choiceNumber] stringByReplacingOccurrencesOfString:@"-" withString:@" " ];
        prettyString = [prettyString stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
        CCLabelTTF *choiceLabel = [CCLabelTTF labelWithString:prettyString fontName:@"Arial" fontSize:24];
        choiceLabel.color = ccc3(0, 255, 0);
        choiceLabel.position = ccp(150.0f, 150.0f);
        
        [menuItem addChild:choiceLabel z:11];
        [availableChoices removeObjectAtIndex:choiceNumber];
    }
}


@end
