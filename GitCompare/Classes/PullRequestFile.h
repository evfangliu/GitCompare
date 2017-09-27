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
//We store both the displayed text (which is an attributed string rendered onto the app)
//And the actual text, which is hidden but accessible incase we need it.
@property (nonatomic, copy) NSAttributedString *leftDisplayText;
@property (nonatomic, copy) NSAttributedString *rightDisplayText;
@property (nonatomic, copy) NSString *leftActualText;
@property (nonatomic, copy) NSString *rightActualText;

-(void) parseOriginalText;
@end

#endif /* PullRequestFile_h */
