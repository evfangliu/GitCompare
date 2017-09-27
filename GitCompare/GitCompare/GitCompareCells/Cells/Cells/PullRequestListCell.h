//
//  PullRequestListCell.h
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//  This is the cell that is made on the Pull Request View to get all the Pull Requests' general info.
//
#ifndef PullRequestListCell_h
#define PullRequestListCell_h

#import <UIKit/UIKit.h>

@interface PullRequestListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@end

#endif /* PullRequestListCell_h */
