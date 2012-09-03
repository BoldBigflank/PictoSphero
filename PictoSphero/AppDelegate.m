//
//  AppDelegate.m
//  PictoSphero
//
//  Created by Alex Swan on 9/1/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import "RobotKit/RobotKit.h"

#define TOTAL_PACKET_COUNT 200
#define PACKET_THRESHOLD 50

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_, robotOnline=robotOnline_, game=game_, keepRolling=keepRolling_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    self.robotOnline = NO;

    // Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:YES];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	[director_ pushScene: [IntroLayer scene]]; 

	
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];

    //Setup a calibration gesture handler on our view to handle rotation gestures and give visual feeback to the user.
    calibrateHandler = [[RUICalibrateGestureHandler alloc] initWithView:navController_.view];
	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
    /*When the application is entering the background we need to close the connection to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
    robotOnline_ = NO;
    
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [self setupRobotConnection];
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
    
    [super dealloc];
}

// Sphero functions
-(void)setupRobotConnection {
    NSLog(@"setupRobotConnection");
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];
    }
}

- (void)handleRobotOnline {
    /*The robot is now online, we can begin sending commands*/
    if(!robotOnline_) {
        /* Send commands to Sphero Here: */
        [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:0.0 blue:0.0];
        
        // Register for asynchronise data streaming packets
        [[RKDeviceMessenger sharedMessenger] addDataStreamingObserver:self selector:@selector(handleAsyncData:)];
        /* Start locator streaming */
        [self startLocatorStreaming];
        
    }
    robotOnline_ = YES;
}

-(void)startLocatorStreaming {
    
    // Note: If your ball has Firmware < 1.20 then these Quaternions
    //       will simply show up as zeros.
    
    // Sphero samples this data at 400 Hz.  The divisor sets the sample
    // rate you want it to store frames of data.  In this case 400Hz/40 = 10Hz
    uint16_t divisor = 20;
    
    // Packet frames is the number of frames Sphero will store before it sends
    // an async data packet to the iOS device
    uint16_t packetFrames = 1;
    
    // Count is the number of async data packets Sphero will send you before
    // it stops.  You want to register for a finite count and then send the command
    // again once you approach the limit.  Otherwise data streaming may be left
    // on when your app crashes, putting Sphero in a bad state.
    uint8_t count = TOTAL_PACKET_COUNT;
    
    // Reset finite packet counter
    packetCounter = 0;
    
    // Register for Locator X,Y position, and X,Y velocity
    RKDataStreamingMask sensorMask = RKDataStreamingMaskLocatorAll;
    
    //// Start data streaming for the locator data. The update rate is set to 20Hz with
    //// one sample per update, so the sample rate is 10Hz. Packets are sent continuosly.
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:divisor
                                                   packetFrames:packetFrames
                                                     sensorMask:sensorMask
                                                    packetCount:count];
}

- (void)handleAsyncData:(RKDeviceAsyncData *)asyncData
{
    // Need to check which type of async data is received as this method will be called for
    // data streaming packets and sleep notification packets. We are going to ingnore the sleep
    // notifications.
    if ([asyncData isKindOfClass:[RKDeviceSensorsAsyncData class]]) {
        
        // Check to see if we need to request more packets
        packetCounter++;
        if( packetCounter > (TOTAL_PACKET_COUNT-PACKET_THRESHOLD)) {
            [self startLocatorStreaming];
        }
        
        // Grab specific sensor data objects from the main sensor object
        RKDeviceSensorsAsyncData *sensorsAsyncData = (RKDeviceSensorsAsyncData *)asyncData;
        RKDeviceSensorsData *sensorsData = [sensorsAsyncData.dataFrames lastObject];
        RKLocatorData *locatorData = sensorsData.locatorData;
        
        Game *game = [self game];
        
        // Use destination point/heading to determine whether to stop
        
        // Print Locator Values
//        self.xValueLabel.text = [NSString stringWithFormat:@"%.02f  %@", locatorData.position.x, @"cm"];
//        self.yValueLabel.text = [NSString stringWithFormat:@"%.02f  %@", locatorData.position.y, @"cm"];
//        self.xVelocityValueLabel.text = [NSString stringWithFormat:@"%.02f  %@", locatorData.velocity.x, @"cm/s"];
//        self.yVelocityValueLabel.text = [NSString stringWithFormat:@"%.02f  %@", locatorData.velocity.y, @"cm/s"];
        
        // ****** DRAW DATA ********
        if([game cgImage] == NULL) return;
        //NSLog(@"Data obtained %f %f", locatorData.position.x, locatorData.position.y);
        
        // If the direction is going away from the target, stop and relocate
        // locatorData.position - targetPos > currentPos - targetPos
        CGPoint newPosition = ccp(locatorData.position.x, locatorData.position.y);
        CGPoint newVector = ccpSub(newPosition, targetPos);
        CGPoint oldVector = ccpSub(currentPos, targetPos);
        if(sqrt(newVector.x*newVector.x + newVector.y*newVector.y) > sqrt(oldVector.x*oldVector.x+oldVector.y*oldVector.y) ){
            [RKRollCommand sendStop];
            //
        }
        if (locatorData.velocity.x < 0.1 && locatorData.velocity.y < 0.1){
            //NSLog(@"RECALCULATING");
            [self moveToPoint:targetPos];
        }
        
        if(locatorData.position.x == currentPos.x && locatorData.position.y == currentPos.y) return;
        currentPos = ccp(locatorData.position.x, locatorData.position.y);
        const UInt8 *data = CFDataGetBytePtr([game bitmapData]);
        float x = (integer_t)locatorData.position.x % CGImageGetWidth([game cgImage]);
        
        float y = (CGImageGetHeight([game cgImage]) - (integer_t)locatorData.position.y % CGImageGetHeight([game cgImage]));
        int width = CGImageGetWidth([game cgImage]);
        int BytesPerPixel = CGImageGetBytesPerRow([game cgImage]) / CGImageGetWidth([game cgImage]);
        
        unsigned int index = (BytesPerPixel * (y * width + x));
        
        float r = (float)data[index]/255;
        float g = (float)data[index+1]/255;
        float b = (float)data[index+2]/255;
        float a = (float)data[index+3]/255;
        //NSLog(@"(%f, %f) %f, %f, %f, %f", x, y, r, g, b, a);
        [RKRGBLEDOutputCommand sendCommandWithRed:r green:g blue:b];
//        imageXSlider.value = (float)(x/CGImageGetWidth([game cgImage]));
//        imageYSlider.value = 1 - (y/CGImageGetHeight([game cgImage]));
    }
}

-(void)showSpheroTail:(bool)showTail{
    if(showTail){
        [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOff];
    }
    else{
        [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOn];
    }
    float brightness = (showTail) ? 1.0 : 0.0;
    [RKBackLEDOutputCommand sendCommandWithBrightness:brightness];
    [RKConfigureLocatorCommand sendCommandForFlag:RKConfigureLocatorRotateWithCalibrateFlagOff newX:0 newY:0 newYaw:0];
}

-(void)moveToPoint:(CGPoint)point{
    //NSLog(@"moveToPoint (%i\t%i)->(%i\t%i)", (int)currentPos.x, (int)currentPos.y, (int)point.x, (int)point.y);
    // Set destination point/heading
    // stop it, rotate it, Send it off
    targetPos = point;
    
    CGPoint vector = ccpSub(targetPos, currentPos);
    double distance = sqrt( vector.x*vector.x + vector.y*vector.y );
    if(sqrt( vector.x*vector.x + vector.y*vector.y ) < 15.0){
        //NSLog(@"DONE!");
        if(self.keepRolling){
            // Pick a new coordinate
            //NSLog(@"KEEP MOVING!");
            int newX = (arc4random() % 100) - 50;
            int newY = (arc4random() % 100) - 50;
            targetPos = ccp(newX,newY);
        }
        return;
    }
    
    float heading = M_PI / 2 - atan2(point.y-currentPos.y, point.x - currentPos.x);
    
    int headingDegrees = heading * 180 / M_PI ;
    //headingDegrees -= 270; // Sphero 0 is off Y axis, coord 0 is off X
    while (headingDegrees < 0) headingDegrees += 360;

    NSLog(@"heading %i", headingDegrees);
    //headingDegrees = arc4random() % 360;
    
    [RKRollCommand sendCommandWithHeading:headingDegrees velocity:0.4];
    
}

@end

