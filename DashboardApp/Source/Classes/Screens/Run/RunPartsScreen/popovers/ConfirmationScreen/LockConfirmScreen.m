//
//  LockConfirmScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "LockConfirmScreen.h"
#import "PartModel.h"

@interface LockConfirmScreen ()// <UITableViewDelegate, UITableViewDataSource>

@end

@implementation LockConfirmScreen
{
    __weak IBOutlet UITableView *_tableView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) cancelButtonTapped {
     [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction) saveButtonTapped {
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _parts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PartModel *p = _parts[section];
    return 1 + p.alternateParts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Layout

- (void) initLayout
{
    self.title = @"Confirmation";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
}

@end
