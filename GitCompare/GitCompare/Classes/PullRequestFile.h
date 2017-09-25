//
//  PullRequestFile.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/24/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#ifndef PullRequestFile_h
#define PullRequestFile_h

@interface PullRequestFile : NSObject

@property (nonatomic, copy) NSString *originalText;
@property (nonatomic, copy) NSString *headerParsedText;
@property (nonatomic, copy) NSAttributedString *leftParsedText;
@property (nonatomic, copy) NSAttributedString *rightParsedText;

-(void) splitOriginalText;
@end

#endif /* PullRequestFile_h */
