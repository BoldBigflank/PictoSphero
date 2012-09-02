//
//  Guess.h
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Guess : CCLayerColor {
    CCSprite *backgroundColor;
    CCMenu *guessMenu;
}
+(CCScene *) scene;
-(void)showGuess:(ccColor3B)color;
-(void)setupChoices:(NSArray*)choices;
@end
