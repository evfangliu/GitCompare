//
//  PullRequestFile.m
//  GitCompare
//
//  Created by Fangzhou Liu on 9/24/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullRequestFile.h"

@implementation PullRequestFile

-(id)init{
    if((self = [super init])){
    }
    return self;
}

-(void) splitOriginalText{
    self.headerParsedText = [self.originalText componentsSeparatedByString: @"\n"][0];
}
@end

