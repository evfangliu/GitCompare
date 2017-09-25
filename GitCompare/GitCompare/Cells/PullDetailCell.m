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

- (IBAction)toggleChanged:(id)sender {
    if(self.toggleSwitch.isOn)
    {
        [self expand];
    }
    else
    {
         [self collapse];
    }
}

- (void)collapse{
    self.leftCodeLabel.text = @"";
    self.rightCodeLabel.text = @"";
}

-(void)expand{
    self.leftCodeLabel.text = self.leftTextString;
    self.rightCodeLabel.text = self.rightTextString;
}
@end

