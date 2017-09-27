//
//  MasterViewController.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRequestWS.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController <PullRequestResponseDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

