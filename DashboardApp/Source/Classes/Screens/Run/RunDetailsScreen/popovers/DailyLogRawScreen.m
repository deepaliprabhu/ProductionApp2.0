//
//  DailyLogRawScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DailyLogRawScreen.h"
#import "DayLogModel.h"
#import "DailyLogRawCell.h"

@interface DailyLogRawScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DailyLogRawScreen {
    
    __weak IBOutlet UITableView *_tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat h = MIN(32+34*_days.count, 400);
    self.preferredContentSize = CGSizeMake(1000, h);
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _days.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"DailyLogRawCell";
    DailyLogRawCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    
    [cell layoutWithLog:_days[indexPath.row] atIndex:(int)indexPath.row];
    
    return cell;
}

@end
