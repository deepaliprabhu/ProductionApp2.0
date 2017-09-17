//
//  DemandListView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DemandListView.h"
#import "DemandListViewCell.h"

@implementation DemandListView
__CREATEVIEW(DemandListView, @"DemandListView", 0);

- (void)initView {
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:0.5].CGColor;
    //self.layer.cornerRadius = 8.0;
}

- (void)setDemandList:(NSMutableArray*)demandList {
    demandsArray = demandList;
    [_tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [demandsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DemandListViewCell";
    DemandListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    //cell.delegate = self;
    [cell setCellData:[demandsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[_delegate runSelectedAtIndex:indexPath.row];
}

- (IBAction)closePressed:(id)sender {
    [_delegate closeSelected];
}

@end
