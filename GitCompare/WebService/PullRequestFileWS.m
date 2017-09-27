//
//  PullRequestFileWS.m
//  GitCompare
//
//  Created by Fangzhou Liu on 9/25/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PullRequestFileWS.h"
#import "PullRequestFile.h"

@implementation PullRequestFileWS

-(id)init{
    if((self = [super init])){
    }
    return self;
}

-(void)loadFilesFromURL:(NSString *) url
{
    if (!self.files) {
        self.files = [[NSMutableArray alloc] init];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          
          NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSScanner *fileSplitter = [NSScanner scannerWithString:requestReply];
          if(![requestReply hasPrefix:@"diff"])
          {
               [self.delegate didFinishRequestWithFiles:NULL];
          }
          else
          {
              while(![fileSplitter isAtEnd]){
                  //This will loop and generate a file per "diff" block.
                  PullRequestFile* pullRequestFile = [[PullRequestFile alloc] init];
                  NSString *fileStringPart1 = nil;
                  NSString *fileStringPart2 = nil;
                  //scan until diff
                  [fileSplitter scanString:@"diff --git a/" intoString:&fileStringPart1];
                  [fileSplitter scanUpToString:@"diff --git" intoString:&fileStringPart2];
                  pullRequestFile.originalText = [NSString stringWithFormat:@"%@%@",fileStringPart1, fileStringPart2];
                  
                  [pullRequestFile parseOriginalText];
                  [self.files insertObject:pullRequestFile atIndex:0];
              }
            [self.delegate didFinishRequestWithFiles:self.files];
          }
      }] resume];
}

@end
