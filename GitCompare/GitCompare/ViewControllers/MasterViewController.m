//
//  MasterViewController.m
//  GitCompare
//
//  Created by Fangzhou Liu on 9/22/17.
//  Copyright © 2017 Evan Inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PullRequestListCell.h"
#import "PullRequest.h"
#import "PullRequestWS.h"

@interface MasterViewController ()
@property NSMutableArray *pullRequests;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    PullRequestWS *pullRequestWS = [[PullRequestWS alloc] init];
    pullRequestWS.delegate = self;
    [pullRequestWS loadPullRequestsFromURL:@"https://api.github.com/repos/magicalpanda/MagicalRecord/pulls"];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didFinishRequestWithPullRequests:(NSMutableArray *)responsePR{
    self.pullRequests = responsePR;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pullDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PullRequest *pullRequest = self.pullRequests[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setPullRequestObject:pullRequest];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryOverlay && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //We remove the primary view when selecting a Pull Request for iPAD
            self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
            self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
        }
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pullRequests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PullRequestListCell *cell = (PullRequestListCell *) [tableView dequeueReusableCellWithIdentifier:@"PullRequestListCell" forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[PullRequestListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PullRequestListCell"];
    }
    PullRequest *pullRequest = self.pullRequests[indexPath.row];
    
    //Format the date
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"M/d/yy"];
    NSString* dtCreatedString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:pullRequest.dtCreated]];
    
    //Fill out info
    cell.numberLabel.text = [NSString stringWithFormat:@"#%ld created at %@", pullRequest.requestNumber, dtCreatedString];
    cell.nameLabel.text = pullRequest.title;
    
    //UI Stuff
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    //add alternating background UI
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 1.0;
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end
