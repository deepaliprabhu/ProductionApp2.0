//
//  TasklistView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "TasklistView.h"
#import "TasklistViewCell.h"
#import <Parse/Parse.h>

@implementation TasklistView
__CREATEVIEW(TasklistView, @"TasklistView", 0);

- (void)initView {
    [self getTasks];
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
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tasksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"TasklistViewCell";
    TasklistViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:[tasksArray objectAtIndex:indexPath.row] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // [_delegate runSelectedAtIndex:indexPath.row];
}

- (void)getTasks {
    PFQuery *query = [PFQuery queryWithClassName:@"TaskList"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        tasksArray = objects;
        [_tableView reloadData];
    }];
}

- (void) updateStatus:(BOOL)value forIndex:(int)index {
    PFObject *parseObj = tasksArray[index];
    if (value) {
        parseObj[@"Status"] = @"Closed";
    }
    else {
        parseObj[@"Status"] = @"Open";
    }
    [parseObj save];
}

- (void) deleteTaskAtIndex:(int)index {
    PFObject *parseObj = tasksArray[index];
    [parseObj delete];
    [tasksArray removeObjectAtIndex:index];
    [_tableView reloadData];
}

@end
