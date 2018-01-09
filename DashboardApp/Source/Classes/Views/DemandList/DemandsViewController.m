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

@interface DemandsViewController ()

@end

@implementation DemandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _notesTextView.layer.borderWidth = 0.4f;
    _notesTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _statsView.layer.borderWidth = 0.4f;
    _statsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    demandsArray = [__DataManager getDemandList];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    //cell.delegate = self;
    [cell setCellData:[demandsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    _rightPaneView.hidden = false;
    [self showDetailForDemand];
}

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)showDetailForDemand {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
