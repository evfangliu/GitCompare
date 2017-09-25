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

@interface MasterViewController ()
@property NSMutableArray *pullRequests;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.github.com/repos/magicalpanda/MagicalRecord/pulls"]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    if (!self.pullRequests) {
        self.pullRequests = [[NSMutableArray alloc] init];
    }
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          
          NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
          for (NSDictionary *pulls in JSON)
          {
              long pullID = [[pulls objectForKey:@"number"] longValue];
              NSString *title = [pulls objectForKey:@"title"];
              NSString *dtCreated = [pulls objectForKey:@"created_at"];
              
              NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
              //The Z at the end of the string represents Zulu which is UTC
              [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
              [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
              
              NSDate* newTime = [dateFormatter dateFromString:dtCreated];
              
              PullRequest *pullRequest = [[PullRequest alloc] init];
              pullRequest.title = title;
              pullRequest.requestNumber = pullID;
              pullRequest.dtCreated = newTime;
              [self.pullRequests insertObject:pullRequest atIndex:0];
          }
          dispatch_async(dispatch_get_main_queue(), ^{
              [self.tableView reloadData];
          });
          NSLog(@"Request reply: %@", requestReply);
      }] resume];
    
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"M/d/yy"];
    NSString* dtCreatedString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:pullRequest.dtCreated]];

    cell.numberLabel.text = [NSString stringWithFormat:@"#%ld created at %@", pullRequest.requestNumber, dtCreatedString];
    cell.nameLabel.text = pullRequest.title;
    
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
