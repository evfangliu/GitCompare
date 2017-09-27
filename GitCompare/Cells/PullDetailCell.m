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

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    self.toggleSwitch.backgroundColor = self.backgroundColor;
}

-(IBAction)toggleChanged:(id)sender {
    if(self.toggleSwitch.isOn)
    {
        [self expand];
    }
    else
    {
        [self collapse];
    }
}

-(void)collapse{
   self.leftCodeLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
    self.rightCodeLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
}

-(void)expand{
    self.leftCodeLabel.attributedText = self.leftTextString;
    self.rightCodeLabel.attributedText = self.rightTextString;
}
@end

