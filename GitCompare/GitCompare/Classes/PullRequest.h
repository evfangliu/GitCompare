//
//  PullRequest.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/24/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#ifndef PullRequest_h
#define PullRequest_h
#import <Foundation/Foundation.h>
@interface PullRequest : NSObject

@property (nonatomic, assign) NSInteger requestNumber;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDate *dtCreated;

@end
#endif /* PullRequest_h */
