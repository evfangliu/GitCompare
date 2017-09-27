//
//  PullRequestListCell.m
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullDetailCell.h"
@implementation PullDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (IBAction)segmentChanged:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        [self collapse];
    } else if(self.segmentControl.selectedSegmentIndex == 1)
    {
        [self expand];
    }
}

- (void)collapse{
   self.leftCodeLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
    self.rightCodeLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
}

- (void)expand{
    self.leftCodeLabel.attributedText = self.leftTextString;
    self.rightCodeLabel.attributedText = self.rightTextString;
}
@end

