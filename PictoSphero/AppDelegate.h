//
//  AppDelegate.h
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "RobotUIKit/RobotUIKit.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
    RUICalibrateGestureHandler *calibrateHandler;
    

	CCDirectorIOS	*director_;							// weak ref

    // Sphero
    bool robotOnline_;
    int packetCounter;
    int round_;
    int redScore_;
    int blueScore_;
    CGPoint currentPos;
}

-(void)setupRobotConnection;

@property (nonatomic) bool robotOnline;
@property (nonatomic) int teams;
@property (nonatomic) int redScore;
@property (nonatomic) int blueScore;
@property (nonatomic) int round;
@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
