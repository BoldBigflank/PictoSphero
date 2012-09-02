//
//  Game.h
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
{
    int roundNumber_;
    int redScore_;
    int blueScore_;
    int teams_;
    
    UIImage * currentImage_;
}

-(UIImage *)newRound;

@property (nonatomic) int roundNumber;
@property (nonatomic) int redScore;
@property (nonatomic) int blueScore;
@property (nonatomic) int teams;
@property (nonatomic, retain) UIImage *currentImage;

@end
