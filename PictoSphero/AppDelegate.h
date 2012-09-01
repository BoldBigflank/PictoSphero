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
    bool robotOnline;
    int packetCounter;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
