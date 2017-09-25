//
//  PullRequestListCell.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//
#ifndef PullRequestListCell_h
#define PullRequestListCell_h

#import <UIKit/UIKit.h>

@interface PullDetailCell : UITableViewCell
@property (nonatomic, weak) NSString *leftTextString;
@property (nonatomic, weak) NSString *rightTextString;
@property (nonatomic, weak) IBOutlet UILabel *fileNameLabel;
@property (nonatomic, weak) IBOutlet UISwitch *toggleSwitch;
@property (nonatomic, weak) IBOutlet UILabel *leftCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightCodeLabel;

- (IBAction)toggleChanged:(id)sender;

- (void)collapse;
- (void)expand;
@end

#endif /* PullRequestListCell_h */

