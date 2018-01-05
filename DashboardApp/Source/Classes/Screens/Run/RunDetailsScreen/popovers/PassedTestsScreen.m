//
//  PassedTestsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 05/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "PassedTestsScreen.h"

@interface PassedTestsScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PassedTestsScreen {
    __weak IBOutlet UITableView *_tableView;
    
    NSMutableArray *_testers;
    NSMutableArray *_locations;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initData];
    float h = 60 + _testers.count*30 + _locations.count*30;
    h = MIN(600, h);
    self.preferredContentSize = CGSizeMake(200, h);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((section == 0) ? _testers.count : _locations.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headerViewWithTitle:section==0?@"Testers":@"Locations"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PassedTestsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PassedTestsCell"];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Light" size:16];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = indexPath.section==0 ? _testers[indexPath.row] : _locations[indexPath.row];
    
    return cell;
}

#pragma mark - Utils

- (void) initData {
    
    _testers = [NSMutableArray array];
    _locations = [NSMutableArray array];
    
    for (NSDictionary *d in _passedTests) {
        
        NSString *l = d[@"Location"];
        NSString *t = d[@"Tester"];
        if ([_testers indexOfObject:t] == NSNotFound)
            [_testers addObject:t];
        if ([_locations indexOfObject:l] == NSNotFound)
            [_locations addObject:l];
    }
    
    [_tableView reloadData];
}

- (UIView*) headerViewWithTitle:(NSString*)title {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    t.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    t.textColor = [UIColor blackColor];
    t.text = title;
    [v addSubview:t];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 200, 1)];
    sep.backgroundColor = [UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1];
    sep.alpha = 0.5;
    [v addSubview:sep];
    
    return v;
}

@end
