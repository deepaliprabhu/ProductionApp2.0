//
//  DemandsViewController.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/01/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "DemandsViewController.h"
#import "DataManager.h"
#import "DemandsViewCell.h"

@implementation DemandsViewController {
    __weak IBOutlet UIButton *_backButton;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initLayout];
    
    if (_productNumber == nil) {
        demandsArray = [[DataManager sharedInstance] getDemandList];
    } else {
        int i = [[DataManager sharedInstance] indexOfDemandForProduct:_productNumber];
        NSDictionary *d = [[DataManager sharedInstance] getDemandList][i];
        demandsArray = [NSMutableArray arrayWithObject:d];
    }
    
    [_tableView reloadData];
    [self selectProductAt:0];
}

#pragma mark - Actions

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [demandsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DemandsViewCell";
    DemandsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }

    [cell setCellData:[demandsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectProductAt:(int)indexPath.row];
}

#pragma mark - Layout

- (void) initLayout {

    _notesTextView.layer.borderWidth = 0.4f;
    _notesTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _statsView.layer.borderWidth = 0.4f;
    _statsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if (_productNumber == nil) {
        [_backButton setTitle:@"Dashboard" forState:UIControlStateNormal];
    } else {
        [_backButton setTitle:@"Run" forState:UIControlStateNormal];
    }
}

#pragma mark - Utils

- (void) selectProductAt:(int)index {
    
    selectedIndex = index;
    _rightPaneView.hidden = false;
    [self showDetailForDemand];
}

- (void) showDetailForDemand {
    
    NSMutableDictionary *demandData = demandsArray[selectedIndex];
    _productNameLabel.text = demandData[@"Product"];
    _notesTextView.text = demandData[@"Notes"];
    _urgentQtyLabel.text = demandData[@"urgent_qty"];
    _urgentDateLabel.text = demandData[@"urgent_when"];
    _longTermQtyLabel.text = demandData[@"long_term_qty"];
    _longTermDateLabel.text = demandData[@"long_when"];
    _stockQtyLabel.text = demandData[@"Mason_Stock"];
    _stockDateLabel.text = demandData[@"stock_when"];
    _daysOpenLabel.text = demandData[@"Days Open"];
    _runsLabel.text = demandData[@"Runs"];
}

@end
