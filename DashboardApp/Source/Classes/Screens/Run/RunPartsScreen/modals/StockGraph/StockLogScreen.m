//
//  StockLogScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "StockLogScreen.h"
#import "ActionModel.h"
#import "AuditLogCell.h"

@interface StockLogScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation StockLogScreen
{
    __weak IBOutlet UITableView *_tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"AuditLogCell";
    AuditLogCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }

    [cell layoutWithModel:_actions[indexPath.row] atIndex:(int)indexPath.row];
    
    return cell;
}

#pragma mark - Layout

- (void) initLayout {
    
    CGFloat h = MIN(32+34*_actions.count, 700);
    self.preferredContentSize = CGSizeMake(700, h);
    
    [_tableView reloadData];
}

#pragma mark - Utils


@end
