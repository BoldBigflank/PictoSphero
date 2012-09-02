//
//  SpheroDraw.h
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Guess.h"
#import "RoundEnd.h"

@interface SpheroDraw : CCLayerColor {
    Guess *_guessLayer;
    RoundEnd * _roundEndLayer;
    
    CCMenu * BuzzMenu;
    CCLabelTTF *timerLabel;
    float timer;
    bool redBuzzed;
    bool blueBuzzed;
    int guesser;
    
}

-(void)returnWithGuess:(int)guessNumber;
-(id)initWithGuess:(Guess *)guessLayer roundEnd:(RoundEnd *)roundEndLayer;
+(CCScene *) scene;
@end
