//
//  RunScheduleCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 09/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "RunScheduleCell.h"
#import "RunScheduleSlotCell.h"
#import "LoadingView.h"

@interface RunScheduleCell () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RunScheduleCell {
    __weak IBOutlet UITableView *_tableView;
    int _week;
    NSIndexPath *_selectedSlot;
    int _selectedWeek;
}

- (void) layoutWithWeek:(int)week selectedSlotIndex:(NSIndexPath*)index selectedSlotWeek:(int)selectedWeek {
    
    _selectedSlot = index;
    _selectedWeek = selectedWeek;
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
        
        NSString *week = nil;
        if (_week == 0)
            week = @"Last week";
        else if (_week == 1)
            week = @"This week";
        else
            week = @"Next week";
        l.text = week;
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
    
    BOOL blink = _selectedSlot!=nil && indexPath.row==_selectedSlot.row && indexPath.section==_selectedSlot.section && _selectedWeek == _week;
    [cell layoutWithBlink:blink];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_week == 0) {
        
        [LoadingView showShortMessage:@"Last week slots cannot be modified"];
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CANCELPICKINGSLOT" object:nil];
        
        _selectedSlot = indexPath;
        _selectedWeek = _week;
        [_tableView reloadData];
        [_delegate slotWasSelectedAtIndex:indexPath forWeek:_week];
    }
}

@end
