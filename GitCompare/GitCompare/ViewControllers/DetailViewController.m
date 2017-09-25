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
    
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    self.selectedSwitches = [[NSMutableDictionary alloc] init];
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
        self.title = [NSString stringWithFormat:@"Pull Request #%ld", self.currentPullRequest.requestNumber];
    }
    
    if(self.currentPullRequest.requestNumber > 0)
    {
    NSString *urlString = [NSString stringWithFormat:@"https://github.com/magicalpanda/MagicalRecord/pull/%ld.diff", self.currentPullRequest.requestNumber];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          
          NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSScanner *fileSplitter = [NSScanner scannerWithString:requestReply];
          NSArray *fileArray = [[NSMutableArray alloc] init];
          
          while(![fileSplitter isAtEnd]){
              PullRequestFile* pullRequestFile = [[PullRequestFile alloc] init];
              NSString *fileStringPart1 = nil;
              NSString *fileStringPart2 = nil;
              //scan until diff
              [fileSplitter scanString:@"diff --git a/" intoString:&fileStringPart1];
              [fileSplitter scanUpToString:@"diff --git" intoString:&fileStringPart2];
              pullRequestFile.originalText = [NSString stringWithFormat:@"%@%@",fileStringPart1, fileStringPart2];
              [pullRequestFile splitOriginalText];
              [self.pullRequestFiles insertObject:pullRequestFile atIndex:0];
          }
          //NSArray *fileArray = [requestReply componentsSeparatedByString:@"diff --git"];
         /* for(int i = 1; i < fileArray.count; i++)
          {
              PullRequestFile* pullRequestFile = [[PullRequestFile alloc] init];
              pullRequestFile.originalText = fileArray[i];
              [pullRequestFile splitOriginalText];
              pullRequestFile.leftParsedText = fileArray[i];
              pullRequestFile.rightParsedText = fileArray[i];
              [self.pullRequestFiles insertObject:pullRequestFile atIndex:0];
          }
          */
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self.tableView reloadData];
              });
          NSLog(@"Request reply: %@", requestReply);
      }] resume];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.leftTextString = pullRequestFile.leftParsedText;
    cell.rightTextString = pullRequestFile.rightParsedText;
    
     cell.fileNameLabel.text = pullRequestFile.headerParsedText;
    if([[self.selectedSwitches objectForKey:key] boolValue] == TRUE)
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
    
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.borderWidth = 1.0;
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.borderWidth = 1.0;
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
