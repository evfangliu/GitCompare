//
//  PullRequestWS.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/25/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//  Used to get the Pull Request basic info.
//

#ifndef PullRequestWS_h
#define PullRequestWS_h

#import <Foundation/Foundation.h>
@protocol PullRequestResponseDelegate <NSObject>
@required
-(void)didFinishRequestWithPullRequests:(NSMutableArray *)responsePR;
@end

@interface PullRequestWS : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) NSMutableArray *pullRequests;
@property (nonatomic, strong) NSObject < PullRequestResponseDelegate > *delegate;
-(void)loadPullRequestsFromURL:(NSString *) url;
@end

#endif /* PullRequestWS_h */
