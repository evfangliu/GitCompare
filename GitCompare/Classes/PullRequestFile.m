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

-(void) parseOriginalText{
    static NSInteger MAX_BLOCK_LINES = 50;
    static NSInteger MAX_TOTAL_LINES = 100;
    //We use attributed strings to highlight the changes, green for add, red for subtract
    //These are the display strings
    
    //Here are the two actual strings that we do not display
    NSMutableString *buildActualLeftString = [[NSMutableString alloc] init];
    NSMutableString *buildActualRightString = [[NSMutableString alloc] init];
    //Since we have to do some processing, separated buildStrings and finalBuildStrings.
    NSMutableAttributedString *buildLeftString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *buildRightString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *finalBuildLeftString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *finalBuildRightString = [[NSMutableAttributedString alloc] init];
    
    //Here is where we store the header string. We have two to compare them incase they are different.
    NSString *buildLeftHeaderString = [[NSString alloc] init];
    NSString *buildRightHeaderString = [[NSString alloc] init];
    
    //Choosing to parse using NSScanner
    NSScanner *scanner = [NSScanner scannerWithString:self.originalText];
    
    //Color highlights for the differences
    UIColor *addColor = [UIColor greenColor];
    UIColor *minusColor = [UIColor redColor];
    UIColor *clearColor = [UIColor clearColor];
    NSDictionary *clearColorAttr = @{NSForegroundColorAttributeName :clearColor};
    NSDictionary *addColorAttr = @{NSBackgroundColorAttributeName : [addColor colorWithAlphaComponent:(.25)]};
    NSDictionary *minusColorAttr = @{NSBackgroundColorAttributeName : [minusColor  colorWithAlphaComponent:(.25)]};
    
    //If there are multiple line blocks, we still need to return if there are too many lines.
    NSInteger totalLeftCount = 0;
    NSInteger totalRightCount = 0;
    
    //Process the diffs block
    [scanner scanString:@"diff --git a/" intoString:NULL];
    [scanner scanUpToString:@" b/" intoString:&buildLeftHeaderString];
    [scanner scanString:@"b/" intoString:NULL];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&buildRightHeaderString];
    [scanner scanUpToString:@"@@ -" intoString:NULL];
    
    //Now that we're at the @@ block, we loop for each @@ block
    while(![scanner isAtEnd]){
        NSString *innerString = [[NSString alloc] init];
        NSString *innerString2 = [[NSString alloc] init];
        [scanner scanString:@"@@ -" intoString:&innerString];
        [scanner scanUpToString:@"\n@@" intoString:&innerString2];
        NSScanner *innerScanner = [NSScanner scannerWithString:[NSString stringWithFormat:@"%@%@", innerString, innerString2]];
        [innerScanner setCharactersToBeSkipped:nil];
        
        //Here is the looping @@ block part
        while(![innerScanner isAtEnd]){
            //total line count keeps track of how many lines all the @@ block's take cumulatively
            //normal line count keeps track of each @@ block's line count
            NSInteger leftLineCount = 0;
            NSInteger rightLineCount = 0;
            NSInteger totalLeftBlockCount = 0;
            NSInteger totalRightBlockCount = 0;
            //We have a blockDifCounter to "fill" gaps when we have different number of blocks.
            NSInteger blockDifCounter = 0;
            
            NSMutableArray *leftBlockLineArray = [[NSMutableArray alloc] init];
            NSMutableArray *rightBlockLineArray = [[NSMutableArray alloc] init];
            //Process the @@ block
            [innerScanner scanString:@"@@ -" intoString:NULL];
            [innerScanner scanInteger:&leftLineCount];
            [innerScanner scanString:@"," intoString:NULL];
            [innerScanner scanInteger:&totalLeftBlockCount];
            [innerScanner scanString:@" +" intoString:NULL];
            [innerScanner scanInteger:&rightLineCount];
            [innerScanner scanString:@"," intoString:NULL];
            [innerScanner scanInteger:&totalRightBlockCount];
            
            //This is to make sure the displayed text isn't too long
            totalLeftCount += totalLeftBlockCount;
            totalRightCount += totalRightBlockCount;
            
            [innerScanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
            [innerScanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
        
            //If our number of lines are too high, just get out with the diff message
            if(totalRightBlockCount > MAX_BLOCK_LINES || totalLeftBlockCount > MAX_BLOCK_LINES || totalLeftCount > MAX_TOTAL_LINES || totalRightCount > MAX_TOTAL_LINES)
            {
                self.leftDisplayText = [[NSAttributedString alloc] initWithString:@"Large diffs are not rendered."];
                self.headerParsedText = buildLeftHeaderString;
                return;
            }
            else
            {
            //Now we loop for each line of changed code
                while(![innerScanner isAtEnd]){
                    NSString *line = nil;
                    [innerScanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&line];
                    [innerScanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
                
                    if([line hasPrefix:@"+"])
                    {
                        [buildRightString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n", rightLineCount, [line substringFromIndex:1]] attributes:addColorAttr]];
                        [buildRightString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                        
                        [buildActualRightString appendString:[NSString stringWithFormat:@"%@\n", [line substringFromIndex:1]]];
                        
                        rightLineCount++;
                        //We keep track of how much text is being added to left side, then make dummy text on right side if its uneven (and vice versa)
                        [leftBlockLineArray addObject:line];
                        blockDifCounter += 1;
                    }
                    else if([line hasPrefix:@"-"])
                    {
                        [buildLeftString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n", leftLineCount, [line substringFromIndex:1]] attributes:minusColorAttr]];
                        [buildLeftString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                        
                        [buildActualLeftString appendString:[NSString stringWithFormat:@"%@\n", [line substringFromIndex:1]]];
                        
                        leftLineCount++;
                        //We keep track of how much text is being added to left side, then make dummy text on right side if its uneven (and vice versa)
                        [rightBlockLineArray addObject:line];
                        blockDifCounter -= 1;
                    }
                    //this is when it should be added to both blocks
                    else
                    {
                        //Logic to put dummy blocks in
                        if(blockDifCounter > 0)
                        {
                            for (int i = 0; i < blockDifCounter; i++)
                            {
                                [buildLeftString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n", leftLineCount, [leftBlockLineArray[i] substringFromIndex:1]] attributes:clearColorAttr]];
                                [buildLeftString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                            }
                        }
                        else if(blockDifCounter < 0)
                        {
                            for (int i = 0; i < blockDifCounter * -1; i++)
                            {
                                [buildRightString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n", rightLineCount, [rightBlockLineArray[i] substringFromIndex:1]] attributes:clearColorAttr]];
                                [buildRightString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                            }
                        }
                        //Put stuff on both sides (not add or subtract)
                        [buildLeftString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n\n", leftLineCount, [line substringFromIndex:0]]]];
                       
                        [buildRightString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n\n", rightLineCount, [line substringFromIndex:0]]]];
                        
                        [buildActualRightString appendString:[NSString stringWithFormat:@"%@\n", [line substringFromIndex:1]]];
                        
                        [buildActualLeftString appendString:[NSString stringWithFormat:@"%@\n", [line substringFromIndex:1]]];
                        
                        leftLineCount++;
                        rightLineCount++;
                        
                        blockDifCounter = 0;
                        [leftBlockLineArray removeAllObjects];
                        [rightBlockLineArray removeAllObjects];
                    }
                }
                if(blockDifCounter > 0)
                {
                    for (int i = 0; i < blockDifCounter; i++)
                    {
                        [buildLeftString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n", leftLineCount, [leftBlockLineArray[i] substringFromIndex:1]] attributes:clearColorAttr]];
                    }
                }
                else if (blockDifCounter < 0)
                {
                    for (int i = 0; i < blockDifCounter * -1; i++)
                    {
                        [buildRightString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  %@\n", rightLineCount, [rightBlockLineArray[i] substringFromIndex:1]] attributes:clearColorAttr]];
                    }
                }
                blockDifCounter = 0;
                
                [leftBlockLineArray removeAllObjects];
                [rightBlockLineArray removeAllObjects];
                
                [finalBuildLeftString appendAttributedString:buildLeftString];
                [finalBuildRightString appendAttributedString:buildRightString];
                //reset the build string for the loop
                buildLeftString = [[NSMutableAttributedString alloc] init];
                buildRightString = [[NSMutableAttributedString alloc] init];
            }
        }
    }
    //Fill out the various text properties
    if([buildLeftHeaderString isEqualToString:buildRightHeaderString])
    {
        self.headerParsedText = buildLeftHeaderString;
        self.leftDisplayText = finalBuildLeftString;
        self.rightDisplayText = finalBuildRightString;
        self.leftActualText = buildActualLeftString;
        self.rightActualText = buildActualRightString;
        }
       else
       {
           self.headerParsedText = [NSString stringWithFormat:@"%@ -> %@", buildLeftHeaderString, buildRightHeaderString];
           self.leftDisplayText = [[NSAttributedString alloc] initWithString:@"File renamed."];
       }
}
@end

