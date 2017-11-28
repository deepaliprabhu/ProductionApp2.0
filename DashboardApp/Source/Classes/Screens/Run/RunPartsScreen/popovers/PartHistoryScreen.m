//
//  PartHistoryScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartHistoryScreen.h"
#import "ProdAPI.h"
#import "LoadingView.h"
#import "HistoryPriceCell.h"

@interface PartHistoryScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PartHistoryScreen
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_noHistoryLabel;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(330, 138);
    
    [self layoutPrices];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _part.priceHistory.count;
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

    [cell layoutWith:_part.priceHistory[indexPath.row] currentPrice:[_part.pricePerUnit floatValue] atIndex:(int)indexPath.row];
    
    return cell;
}

#pragma mark - Layout

- (void) layoutPrices {
    
    int c = (int)_part.priceHistory.count;
    if (c == 0)
        _noHistoryLabel.alpha = 1;
    else {
        _noHistoryLabel.alpha = 0;
        c = MIN(c, 15);
        self.preferredContentSize = CGSizeMake(330, 32+c*34);
    }
}

@end
