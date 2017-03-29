//
//  FTAppDelegate.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAppDelegate.h"
#import <LUIFramework/LUIFramework.h>
#import "FTAccountsViewController.h"
#import "Flurry.h"
#import "ABPadLockScreenView.h"
#import "ABPadButton.h"
#import "ABPinSelectionView.h"
#import "UIColor+HexValue.h"

@interface FTAppDelegate ()



@property (nonatomic, strong) NSString *thePin;
- (IBAction)setPin:(id)sender;
- (IBAction)lockApp:(id)sender;

@end

@implementation FTAppDelegate


#pragma mark Application delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _locked = YES;
    // Flurry analytics
    //[Flurry startSession:@"JZK5H9MRXHYP86K7DJX8"];
    
    // Remote localization from http://www.liveui.io
    //[[LUIURLs sharedInstance] setCustomApiUrlString:@"http://localhost/api.liveui.io/"];
    //[[LUIURLs sharedInstance] setCustomImagesUrlString:@"http://localhost/images.liveui.io/"];
    //[[LUIMain sharedInstance] setDebugMode:YES];
    [[LUIMain sharedInstance] setApiKey:@"919EA7C3-D530-48F2-B07C-7DC82680874A"];
    
    _viewController = [[FTAccountsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:_viewController];
    [_window setRootViewController:nc];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    _locked = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    _thePin = @"1234";
    //_thePin = [[NSUserDefaults standardUserDefaults] stringForKey:@"pin"];
    
    [[ABPadLockScreenView appearance] setBackgroundColor:[UIColor colorWithHexValue:@"282B35"]];
    
    UIColor* color = [UIColor colorWithRed:229.0f/255.0f green:180.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
    
    [[ABPadLockScreenView appearance] setLabelColor:[UIColor whiteColor]];
    [[ABPadLockScreenView appearance] setLabelColor:[UIColor blackColor]];
    [[ABPadButton appearance] setBackgroundColor:[UIColor clearColor]];
    //[[ABPadButton appearance] setBorderColor:color];
    [[ABPadButton appearance] setSelectedColor:color];
    
    [[ABPinSelectionView appearance] setSelectedColor:color];
    if (self.thePin)
    {
        //[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showLock) userInfo:nil repeats:NO];
        [self lockApp:self];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - Button Methods
- (IBAction)setPin:(id)sender
{
    ABPadLockScreenSetupViewController *lockScreen = [[ABPadLockScreenSetupViewController alloc] initWithDelegate:self complexPin:YES subtitleLabelText:@"You need a PIN to continue"];
    lockScreen.tapSoundEnabled = YES;
    lockScreen.errorVibrateEnabled = YES;
    
    lockScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    lockScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //	Example using an image
    //	UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper"]];
    //	backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    //	backgroundView.clipsToBounds = YES;
    //	[lockScreen setBackgroundView:backgroundView];
    
    [_viewController presentViewController:lockScreen animated:YES completion:nil];
}

- (IBAction)lockApp:(id)sender
{
    if (!self.thePin)
    {
        [[[UIAlertView alloc] initWithTitle:@"No Pin" message:@"Please Set a pin before trying to unlock" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    ABPadLockScreenViewController *lockScreen = [[ABPadLockScreenViewController alloc] initWithDelegate:self complexPin:NO];
    [lockScreen setAllowedAttempts:3];
    
    
    lockScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    lockScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    //	Example using an image
    //	UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper"]];
    //	backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    //	backgroundView.clipsToBounds = YES;
    //	[lockScreen setBackgroundView:backgroundView];
    
    [_viewController presentViewController:lockScreen animated:YES completion:nil];
}


#pragma mark - ABLockScreenDelegate Methods

- (BOOL)padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController validatePin:(NSString*)pin;
{
    NSLog(@"Validating pin %@", pin);
    
    return [self.thePin isEqualToString:pin];
}

- (void)unlockWasSuccessfulForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController
{
    [_viewController dismissViewControllerAnimated:YES completion:nil];
    FTAppDelegate *appDelegate = (FTAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.locked = NO;
    NSLog(@"Pin entry successfull");
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController
{
    NSLog(@"Failed attempt number %ld with pin: %@", (long)attemptNumber, falsePin);
}

- (void)unlockWasCancelledForPadLockScreenViewController:(ABPadLockScreenAbstractViewController *)padLockScreenViewController
{
    [_viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Pin entry cancelled");
}


#pragma mark - ABPadLockScreenSetupViewControllerDelegate Methods
- (void)pinSet:(NSString *)pin padLockScreenSetupViewController:(ABPadLockScreenSetupViewController *)padLockScreenViewController
{
    [_viewController dismissViewControllerAnimated:YES completion:nil];
    self.thePin = pin;
    NSLog(@"Pin set to pin %@", self.thePin);
}

- (void)unlockWasCancelledForSetupViewController:(ABPadLockScreenAbstractViewController *)padLockScreenViewController
{
    [_viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Pin Setup Cnaclled");
}

@end
