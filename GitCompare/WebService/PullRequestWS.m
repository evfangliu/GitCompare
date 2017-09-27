//
//  PullRequestWS.m
//  GitCompare
//
//  Created by Fangzhou Liu on 9/25/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullRequestWS.h"
#import "PullRequest.h"
@implementation PullRequestWS

-(id)init{
    if((self = [super init])){
    }
    return self;
}

-(void)loadPullRequestsFromURL:(NSString *) url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    if (!self.pullRequests) {
        self.pullRequests = [[NSMutableArray alloc] init];
    }
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
          for (NSDictionary *pulls in JSON)
          {
              long pullID = [[pulls objectForKey:@"number"] longValue];
              NSString *title = [pulls objectForKey:@"title"];
              NSString *dtCreated = [pulls objectForKey:@"created_at"];
              
              NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
              //The Z at the end of the string represents Zulu which is UTC
              [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
              [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
              
              NSDate* newTime = [dateFormatter dateFromString:dtCreated];
              
              PullRequest *pullRequest = [[PullRequest alloc] init];
              pullRequest.title = title;
              pullRequest.requestNumber = pullID;
              pullRequest.dtCreated = newTime;
              [self.pullRequests insertObject:pullRequest atIndex:0];
          }
           [self.delegate didFinishRequestWithPullRequests:self.pullRequests];
      }] resume];
}

@end
