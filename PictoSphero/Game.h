//
//  Game.h
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Game : NSObject
{
    int roundNumber_;
    int redScore_;
    int blueScore_;
    int teams_;
    int timer_;
    int maxScore_;
    ccColor4B guessColor_;
    
    NSString * currentImage_;
}

-(void)newRound;

@property (nonatomic) int roundNumber;
@property (nonatomic) int redScore;
@property (nonatomic) int blueScore;
@property (nonatomic) int teams;
@property (nonatomic) int timer;
@property (nonatomic) int maxScore;
@property (nonatomic) ccColor4B guessColor;
@property (nonatomic, retain) NSString *currentImage;

@end
