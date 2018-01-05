//
//  FailedTestsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FailedTestsScreen.h"
#import "FailReasonCell.h"

@interface FailedTestsScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FailedTestsScreen {
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_noFailesLabel;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _noFailesLabel.alpha = _failedCases.count==0;
    
    float h = 32;
    for (int i=0;i<_failedCases.count;i++) {
        h += [FailReasonCell heightForFail:_failedCases[i]];
    }
    
    h = MIN(h, 600);
    self.preferredContentSize = CGSizeMake(600, h);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _failedCases.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FailReasonCell heightForFail:_failedCases[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"FailReasonCell";
    FailReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    [cell layoutWithFail:_failedCases[indexPath.row]];
    
    return cell;
}

@end
