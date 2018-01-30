//
//  OperatorTargetView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorTargetView.h"

@implementation OperatorTargetView {
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
}

+ (OperatorTargetView*) createView
{
    UINib *nib = [UINib nibWithNibName:@"OperatorTargetView" bundle:nil];
    OperatorTargetView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

- (void) reloadData {
    
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [_delegate goBackFromOperatorView];
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier2 = @"OperatorTargetCell";
    OperatorTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil][0];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark - CellProtocol

- (void) inputLogAt:(int)index {
    
}

@end
