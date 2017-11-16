//
//  FeedbackListView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 14/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FeedbackListView.h"
#import "FeedbackListViewCell.h"
#import "ServerManager.h"
#import "DataManager.h"

@implementation FeedbackListView
__CREATEVIEW(FeedbackListView, @"FeedbackListView", 0);

- (void)initView {
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:0.5].CGColor;
    [__ServerManager getFeedbacks];
}

- (void)setFeedbacksList:(NSMutableArray*)feedbacksList {
    feedbacksArray = feedbacksList;
    [_tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
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
}

- (IBAction)closePressed:(id)sender {
    [_delegate closeSelected];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
