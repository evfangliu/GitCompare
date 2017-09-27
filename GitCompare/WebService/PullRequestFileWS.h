//
//  PullRequestFileWS.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/25/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//  Used to get the Pull Request File differences. 
//

#ifndef PullRequestFileWS_h
#define PullRequestFileWS_h


#import <Foundation/Foundation.h>
@protocol FileResponseDelegate <NSObject>
@required
-(void)didFinishRequestWithFiles:(NSMutableArray *)responseFiles;
@end

@interface PullRequestFileWS : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) NSMutableArray *files;
@property (nonatomic, strong) NSObject < FileResponseDelegate > *delegate;
-(void)loadFilesFromURL:(NSString *) url;
@end


#endif /* PullRequestFileWS_h */
