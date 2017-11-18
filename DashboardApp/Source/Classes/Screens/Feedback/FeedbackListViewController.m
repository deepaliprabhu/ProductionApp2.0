//
//  FeedbackListViewController.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FeedbackListViewController.h"
#import "FeedbackListViewCell.h"
#import "FeedbackDetailView.h"

@interface FeedbackListViewController ()

@end

@implementation FeedbackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFeedbacksList:(NSMutableArray*)feedbacksList {
    feedbacksArray = feedbacksList;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedbacksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"FeedbackListViewCell";
    FeedbackListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    //cell.delegate = self;
    [cell setCellData:[feedbacksArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [self showFeedbackDetail];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)showFeedbackDetail {
    FeedbackDetailView *feedbackDetailView = [FeedbackDetailView createView];
    feedbackDetailView.frame = CGRectMake(self.view.frame.size.width/2-feedbackDetailView.frame.size.width/2, self.view.frame.size.height/2-feedbackDetailView.frame.size.height/2, feedbackDetailView.frame.size.width, feedbackDetailView.frame.size.height);
    [feedbackDetailView initView];
    [feedbackDetailView setFeedbackData:feedbacksArray[selectedIndex]];
    [self.view addSubview:feedbackDetailView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
