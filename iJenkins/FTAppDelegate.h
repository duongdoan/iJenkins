//
//  FTAppDelegate.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABPadLockScreenViewController.h"
#import "ABPadLockScreenSetupViewController.h"

#define kAppDelegate                                (FTAppDelegate *)[[UIApplication sharedApplication] delegate]
#define kAPIDownloadQueue                           [kAppDelegate apiDownloadQueue]


@class FTAccountsViewController;

@interface FTAppDelegate : UIResponder <UIApplicationDelegate, ABPadLockScreenViewControllerDelegate, ABPadLockScreenSetupViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FTAccountsViewController *viewController;

@property (nonatomic, strong) NSOperationQueue *apiDownloadQueue;
@property (nonatomic, assign) BOOL locked;

@end
