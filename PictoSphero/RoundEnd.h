//
//  RoundEnd.h
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RoundEnd : CCLayerColor {
    CCLabelTTF *winnerLabel;
    CCSprite *picture;
}
+(CCScene *) scene;
-(void)setWinner:(NSString *)winner;

@end
