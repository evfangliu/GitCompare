//
//  PullRequestFile.m
//  GitCompare
//
//  Created by Fangzhou Liu on 9/24/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullRequestFile.h"
#import <UIKit/UIKit.h>
@implementation PullRequestFile

-(id)init{
    if((self = [super init])){
    }
    return self;
}

-(void) splitOriginalText{
    NSMutableAttributedString *buildLeftString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *buildRightString = [[NSMutableAttributedString alloc] init];
    NSString *buildHeaderString = [[NSAttributedString alloc] init];
    NSScanner *scanner = [NSScanner scannerWithString:self.originalText];
    
    UIColor *addColor = [UIColor greenColor];
    UIColor *minusColor = [UIColor redColor];
    NSDictionary *addColorAttr = @{NSForegroundColorAttributeName : addColor};
    NSDictionary *minusColorAttr = @{NSForegroundColorAttributeName : minusColor};
    
    NSInteger leftStart = 0;
    NSInteger rightStart = 0;
    while(![scanner isAtEnd]){
        
        [scanner scanString:@"diff --git a/" intoString:NULL];
        [scanner scanUpToString:@" b/" intoString:&buildHeaderString];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        [scanner scanString:@"@@ -" intoString:NULL];
        [scanner scanInteger:&leftStart];
        [scanner scanUpToString:@" +" intoString:NULL];
        [scanner scanInteger:&rightStart];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        while(![scanner isAtEnd]){
            NSString *line = nil;
             [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&line];
            if([line hasPrefix:@"+"])
            {
                [buildRightString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n\n", rightStart, [line substringFromIndex:1]] attributes:addColorAttr]];
                rightStart++;
            }
            else if([line hasPrefix:@"-"])
            {
                [buildLeftString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n\n", leftStart, [line substringFromIndex:1]] attributes:minusColorAttr]];
                leftStart++;
            }
            else
            {
                [buildLeftString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n\n", leftStart, [line substringFromIndex:0]]]];
                leftStart++;
                
                [buildRightString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n\n", rightStart, [line substringFromIndex:0]]]];
                rightStart++;
            }
        }
    }
    
    self.headerParsedText = buildHeaderString;
    self.leftParsedText = buildLeftString;
    self.rightParsedText = buildRightString;
}
@end

