//
//  PullRequestListCell.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//  This is for the details (diffs) of a specific pull request

#ifndef PullRequestListCell_h
#define PullRequestListCell_h

#import <UIKit/UIKit.h>

@interface PullDetailCell : UITableViewCell
@property (nonatomic, weak) NSAttributedString *leftTextString;
@property (nonatomic, weak) NSAttributedString *rightTextString;
@property (nonatomic, weak) IBOutlet UILabel *fileNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *leftCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightCodeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)segmentChanged:(id)sender;

- (void)collapse;
- (void)expand;
@end

#endif /* PullRequestListCell_h */

