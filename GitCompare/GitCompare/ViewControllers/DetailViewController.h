//
//  DetailViewController.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRequest.h"
#import "PullRequestFileWS.h"
@interface DetailViewController : UITableViewController <FileResponseDelegate>

@property (nonatomic, strong) PullRequest *currentPullRequest;
- (void)setPullRequestObject:(PullRequest *)newPullRequest;
@end

