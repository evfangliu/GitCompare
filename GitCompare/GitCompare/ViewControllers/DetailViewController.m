//
//  DetailViewController.m
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import "DetailViewController.h"
#import "PullDetailCell.h"
#import "PullRequestFile.h"
@interface DetailViewController ()
@property NSMutableArray *pullRequestFiles;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    if (!self.pullRequestFiles) {
        self.pullRequestFiles = [[NSMutableArray alloc] init];
    }
    if(!self.selectedSwitches){
        self.selectedSwitches = [[NSMutableDictionary alloc] init];
    }
    //If this is on initial load, we basically want the screen to be blank but force the master view overlay to show up.
    if(self.currentPullRequest == nil)
    {
        self.currentPullRequest = [[PullRequest alloc] init];
        self.title = @"";
        
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
            self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
        }
    }
    else
    {
        //otherwise set it up to have a title and load the cells via call to github api.
        self.title = [NSString stringWithFormat:@"Pull Request #%ld", self.currentPullRequest.requestNumber];
        if(self.currentPullRequest.requestNumber > 0)
        {
            PullRequestFileWS *pullRequestFileWS = [[PullRequestFileWS alloc] init];
            pullRequestFileWS.delegate = self;
            NSString *urlString = [NSString stringWithFormat:@"https://github.com/magicalpanda/MagicalRecord/pull/%ld.diff", self.currentPullRequest.requestNumber];
            [pullRequestFileWS loadFilesFromURL:urlString];
        }
    }
    
    //So the dynamic row heights will work
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//We have a delegate such that when the api call is finished, we return here
-(void)didFinishRequestWithFiles:(NSMutableArray *)responseFiles{
    if(responseFiles != nil)
    {
        self.pullRequestFiles = responseFiles;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Pull Request Error"
                                                                       message:@"Diff not found!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Managing the detail item

- (void)setPullRequestObject:(PullRequest *)newPullRequest {
    self.currentPullRequest = newPullRequest;
    NSLog(@"%@", self.currentPullRequest.title);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pullRequestFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PullDetailCell";
    
    PullDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.toggleSwitch.tag = 1000 + indexPath.row;
    NSNumber *key = [NSNumber numberWithInteger:cell.toggleSwitch.tag];
    
    if(cell == nil)
    {
        cell = [[PullDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [self.selectedSwitches setObject:[NSNumber numberWithBool:FALSE] forKey:key];
    }
    
    PullRequestFile *pullRequestFile = self.pullRequestFiles[indexPath.row];
    cell.leftTextString = pullRequestFile.leftDisplayText;
    cell.rightTextString = pullRequestFile.rightDisplayText;
    cell.fileNameLabel.text = pullRequestFile.headerParsedText;
    
    if([[self.selectedSwitches objectForKey:key] boolValue])
    {
        [cell.toggleSwitch setOn:TRUE];
        [cell expand];
    }
    else
    {
        [cell.toggleSwitch setOn:FALSE];
        [cell collapse];
    }
    
    [cell.toggleSwitch addTarget:self action:@selector(switchRefresh:) forControlEvents:UIControlEventValueChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0;
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(void)switchRefresh:(UISwitch*)sender {
    //We update the dictionary for the switch's state and reload the table view.
    NSNumber *isChecked = [[NSNumber alloc] initWithBool:sender.isOn];
    NSNumber *key = [NSNumber numberWithInteger:sender.tag];
    [self.selectedSwitches setObject:isChecked forKey:key];
    [self.tableView reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



@end
