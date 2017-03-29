//
//  FTJobDetailViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTViewController.h"


@interface FTJobDetailViewController : FTViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, FTAPIJobDataObjectDelegate>

@property (nonatomic, strong) FTAPIJobDataObject *job;
@property (nonatomic, strong) NSString *jobName;


@end
