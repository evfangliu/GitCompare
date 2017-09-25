//
//  DetailViewController.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRequest.h"
@interface DetailViewController : UITableViewController

@property (nonatomic, strong) PullRequest *currentPullRequest;
@property (nonatomic, strong) NSMutableDictionary *selectedSwitches;

- (void)setPullRequestObject:(PullRequest *)newPullRequest;
@end

