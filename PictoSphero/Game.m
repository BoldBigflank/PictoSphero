//
//  Game.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//
//

#import "Game.h"

@implementation Game

@synthesize currentImage=currentImage_, choices=choices_;
@synthesize redScore=redScore_, blueScore=blueScore_, roundNumber=roundNumber_, teams=teams_, timer=timer_, guessColor=guessColor_, maxScore=maxScore_, cgImage=cgImage_, bitmapData=bitmapData_;

-(id)init{
    if((self = [super init])){
        self.roundNumber = 1;
        self.blueScore = 0;
        self.redScore = 0;
        self.timer = 30;
        self.maxScore = 5;
    }
    return self;
}


-(void)newRound{
    // Pick a picture from the collection
    self.currentImage = @"Default.png";
    NSArray *files = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];

    if(files.count > 0){
        int chosenPic = arc4random() % files.count;
        self.currentImage = [[files objectAtIndex:chosenPic] lastPathComponent];
        UIImage *image = [UIImage imageNamed:self.currentImage];
        self.cgImage = [image CGImage];
        CGDataProviderRef provider = CGImageGetDataProvider(self.cgImage);
        self.bitmapData = CGDataProviderCopyData(provider);
        
        NSMutableArray *choices = [[NSMutableArray alloc] initWithObjects:[[files objectAtIndex:chosenPic] lastPathComponent], nil];
        while ([choices count] < 4){
            int choiceNumber = arc4random() % files.count;
            if(![choices containsObject:[[files objectAtIndex:choiceNumber] lastPathComponent]]){
                [choices addObject:[[files objectAtIndex:choiceNumber] lastPathComponent]];
            }
        }
        self.choices = [[NSArray alloc] initWithArray:choices];
    }
    
    
}

@end
