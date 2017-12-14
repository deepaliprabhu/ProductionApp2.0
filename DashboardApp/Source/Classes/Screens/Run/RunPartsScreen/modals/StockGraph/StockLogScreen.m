//
//  StockLogScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "StockLogScreen.h"
#import "ActionModel.h"
#import "AuditActionCell.h"

@interface StockLogScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation StockLogScreen
{
    __weak IBOutlet UITableView *_tableView;
    
    NSMutableArray *_puneArray;
    NSMutableArray *_s2Array;
    NSMutableArray *_p2Array;
    NSMutableArray *_masonArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self computeData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return _puneArray.count;
    else if (section == 1)
        return _s2Array.count;
    else if (section == 2)
        return _p2Array.count;
    else
        return _masonArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (_puneArray.count == 0)
            return 0;
        else
            return 20;
    }
    else if (section == 1) {
        if (_s2Array.count == 0)
            return 0;
        else
            return 20;
    }
    else if (section == 2) {
        if (_p2Array.count == 0)
            return 0;
        else
            return 20;
    }
    else {
        if (_masonArray.count == 0)
            return 0;
        else
            return 20;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (_puneArray.count == 0)
            return nil;
        else
            return [self headerViewWithTitle:@"PUNE"];
    }
    else if (section == 1) {
        if (_s2Array.count == 0)
            return nil;
        else
            return [self headerViewWithTitle:@"S2"];
    }
    else if (section == 2) {
        if (_p2Array.count == 0)
            return nil;
        else
            return [self headerViewWithTitle:@"P2"];
    }
    else {
        if (_masonArray.count == 0)
            return nil;
        else
            return [self headerViewWithTitle:@"MASON"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"AuditActionCell";
    AuditActionCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }

    ActionModel *m = nil;
    if (indexPath.section == 0)
        m = _puneArray[indexPath.row];
    else if (indexPath.section == 1)
        m = _s2Array[indexPath.row];
    else if (indexPath.section == 2)
        m = _p2Array[indexPath.row];
    else
        m = _masonArray[indexPath.row];
    [cell layoutWith:m];
    
    return cell;
}

#pragma mark - Layout

- (UIView*) headerViewWithTitle:(NSString*)title {
 
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 20)];
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 20)];
    t.font = [UIFont fontWithName:@"Roboto-Bold" size:15];
    t.text = title;
    [v addSubview:t];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 19, 300, 1)];
    sep.backgroundColor = [UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1];
    sep.alpha = 0.5;
    [v addSubview:sep];
    
    return v;
}

#pragma mark - Utils

- (void) computeData {
    
    _masonArray = [NSMutableArray array];
    _puneArray = [NSMutableArray array];
    _p2Array = [NSMutableArray array];
    _s2Array = [NSMutableArray array];
    
    for (ActionModel *a in _actions) {
        
        if ([a.location isEqualToString:@"S2"])
            [_s2Array addObject:a];
        else if ([a.location isEqualToString:@"PUNE"])
            [_puneArray addObject:a];
        else if ([a.location isEqualToString:@"MASON"])
            [_masonArray addObject:a];
        else if ([a.location isEqualToString:@"P2"])
            [_p2Array addObject:a];
    }
    
    CGFloat h = 0;
    if (_masonArray.count > 0) {
        h += (20 + _masonArray.count*160);
    }
    if (_p2Array.count > 0) {
        h += (20 + _p2Array.count*160);
    }
    if (_s2Array.count > 0) {
        h += (20 + _s2Array.count*160);
    }
    if (_puneArray.count > 0) {
        h += (20 + _puneArray.count*160);
    }
    h = MIN(h, 700);
    self.preferredContentSize = CGSizeMake(300, h);
    
    [_tableView reloadData];
}

@end
