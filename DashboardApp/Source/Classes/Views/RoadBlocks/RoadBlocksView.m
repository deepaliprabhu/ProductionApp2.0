//
//  InProcessView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RoadBlocksView.h"
#import "RoadBlocksViewCell.h"
#import "DataManager.h"

@implementation RoadBlocksView

__CREATEVIEW(RoadBlocksView, @"RoadBlocksView", 0);

- (void)initView {
    runsArray = [__DataManager getRuns];
    [self filterRuns];
    [_tableView reloadData];
}

- (void)filterRuns {
    NSMutableArray *filteredRuns = [[NSMutableArray alloc] init];
    for (int i=0; i < runsArray.count; ++i) {
        Run *run = runsArray[i];
        if ([[[run getStatus] lowercaseString] containsString:@"on hold"]) {
            [filteredRuns addObject:run];
        }
    }
    runsArray = filteredRuns;
    [_delegate setRoadBlocksLabel:runsArray.count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [runsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RoadBlocksViewCell";
    RoadBlocksViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    //cell.delegate = self;
    Run *run = runsArray[indexPath.row];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[run getRunId]],@"RunId", [run getProductName], @"ProductName", [NSString stringWithFormat:@"%d",[run getQuantity]], @"Quantity",[run getStatus],@"Status",[run getProductNumber], @"ProductNumber", nil];
    [cell setCellData:dict];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
