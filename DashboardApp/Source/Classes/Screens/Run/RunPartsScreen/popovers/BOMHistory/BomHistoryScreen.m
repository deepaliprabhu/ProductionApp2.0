//
//  BomHistoryScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "BomHistoryScreen.h"
#import "HistoryPriceCell.h"

@interface BomHistoryScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BomHistoryScreen {
    
    __weak IBOutlet UITableView *_tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    float height = _bomValues.count * 34 + 32;
    height = MIN(height, 680);
    self.preferredContentSize = CGSizeMake(190, height);
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bomValues.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier3 = @"HistoryPriceCell";
    HistoryPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil][0];
    }
    
    NSDictionary *dict = _bomValues[indexPath.row];
    [cell layoutWithBOMPrice:[dict[@"price"] floatValue] atDate:dict[@"time"]];
    
    return cell;
}

@end
