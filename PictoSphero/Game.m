//
//  Game.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//
//

#import "Game.h"

@implementation Game

@synthesize currentImage=currentImage_;
@synthesize redScore=redScore_, blueScore=blueScore_, roundNumber=roundNumber_, teams=teams_, timer=timer_, guessColor=guessColor_;

-(id)init{
    if((self = [super init])){
        self.roundNumber = 1;
        self.blueScore = 0;
        self.redScore = 0;
        self.timer = 10;
    }
    return self;
}


-(void)newRound{
    // Pick a picture from the collection
    self.currentImage = [[UIImage alloc] initWithContentsOfFile:@""];
}

@end
