//
//  Game.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//
//

#import "Game.h"
#import <UIKit/UIKit.h>

@implementation Game

@synthesize currentImage=currentImage_;
@synthesize redScore=redScore_, blueScore=blueScore_, roundNumber=roundNumber_, teams=teams_, timer=timer_, guessColor=guessColor_, maxScore=maxScore_;

-(id)init{
    if((self = [super init])){
        self.roundNumber = 1;
        self.blueScore = 0;
        self.redScore = 0;
        self.timer = 10;
        self.maxScore = 7;
    }
    return self;
}


-(void)newRound{
    // Pick a picture from the collection
    self.currentImage = @"Default.png";
    NSArray *pictureArray = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:nil];
    
    int chosenPic = arc4random() % pictureArray.count;
    self.currentImage = [pictureArray objectAtIndex:chosenPic];
    
}

@end
