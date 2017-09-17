//
//  InProcessView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "InProcessView.h"
#import "InProcessViewCell.h"
#import "DataManager.h"
#import <Parse/Parse.h>

@implementation InProcessView

__CREATEVIEW(InProcessView, @"InProcessView", 0);

- (void)initView {
    runsArray = [__DataManager getRuns];
    [self filterRuns];
    [self getRunCompletionStatus];
    __after(5, ^{
        [_tableView reloadData];
    });
}

- (void)filterRuns {
    NSMutableArray *filteredRuns = [[NSMutableArray alloc] init];
    for (int i=0; i < runsArray.count; ++i) {
        Run *run = runsArray[i];
        if ([[[run getStatus] lowercaseString] isEqualToString:@"in process"]||[[[run getStatus] lowercaseString] isEqualToString:@"in progress"]) {
            [filteredRuns addObject:run];
        }
    }
    runsArray = filteredRuns;
    [_delegate setInProcessLabel:runsArray.count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [runsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"InProcessViewCell";
    InProcessViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    //cell.delegate = self;
    Run *run = runsArray[indexPath.row];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[run getRunId]],@"RunId", [run getProductName], @"ProductName", [NSString stringWithFormat:@"%d",[run getQuantity]], @"Quantity", [run getProductNumber], @"ProductNumber",[NSString stringWithFormat:@"%d",[run getRunCompletion]], @"Completion", nil];
    [cell setCellData:dict];
    return cell;
}

- (void)getRunCompletionStatus {
    for (int i=0; i < runsArray.count; ++i) {
        Run *run = runsArray[i];
        [self getRunPlan:run];
    }
}

- (void)getRunPlan:(Run*)run {
    PFQuery *query = [PFQuery queryWithClassName:@"ProductionPlan"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[run getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (objects.count > 0) {
            [self getRunCompletion:objects forRun:run];
        }
    }];
}

- (void)getRunCompletion:(NSMutableArray*)operationsArray forRun:(Run*)run{
    int totalCount = operationsArray.count;
    int doneCount = 0;
    for (int i=0; i < operationsArray.count; ++i) {
        NSDictionary *operationData = operationsArray[i];
        if ([operationData[@"Status"] isEqualToString:@"CLOSED"]) {
            doneCount++;
        }
    }
    int percentage = (((float)doneCount/totalCount))*10;
    [run setRunCompletion:percentage];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
