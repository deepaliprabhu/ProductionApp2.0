//
//  FailedTestsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FailedTestsScreen.h"

@interface FailedTestsScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FailedTestsScreen {
    __weak IBOutlet UITableView *_tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(400, 600);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _failedCases.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *reasons = _failedCases[section][@"verdict"];
    NSArray *arr = [reasons componentsSeparatedByString:@","];
    return arr.count + 1;
}

@end
