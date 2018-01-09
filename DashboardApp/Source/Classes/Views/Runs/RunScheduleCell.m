//
//  RunScheduleCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 09/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "RunScheduleCell.h"
#import "RunScheduleSlotCell.h"

@interface RunScheduleCell () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RunScheduleCell {
    __weak IBOutlet UITableView *_tableView;
    NSString *_week;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void) layoutWithWeek:(NSString*)week {
    _week = week;
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 29;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 21;
    } else {
        return 4;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *v = [UIView new];
        v.frame = CGRectMake(0, 0, 82, 21);
        v.backgroundColor = [UIColor clearColor];
        
        UILabel *l = [UILabel new];
        l.frame = v.bounds;
        l.backgroundColor = [UIColor clearColor];
        l.textColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = _week;
        l.font = [UIFont fontWithName:@"Roboto-Regular" size:13];
        [v addSubview:l];
        
        return v;
        
    } else {
        UIView *v = [UIView new];
        v.frame = CGRectMake(0, 0, 82, 4);
        v.backgroundColor = [UIColor clearColor];
        return v;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"RunScheduleSlotCell";
    RunScheduleSlotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    return cell;
}

@end
