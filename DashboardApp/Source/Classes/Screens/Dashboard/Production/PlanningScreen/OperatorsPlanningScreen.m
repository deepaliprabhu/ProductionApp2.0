//
//  OperatorsPlanningScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 27/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorsPlanningScreen.h"
#import "OperatorCell.h"
#import "LoadingView.h"
#import "FinalPlanningStepScreen.h"

@interface OperatorsPlanningScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation OperatorsPlanningScreen {
    
    __weak IBOutlet UITableView *_tableView;
    NSMutableDictionary *_selectedIndeces;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    
    _selectedIndeces = [NSMutableDictionary dictionary];
}

#pragma mark - Actions

- (IBAction) cancelButtonTapped {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction) nextButtonTapped {
 
    if (_selectedIndeces.count == 0) {
        [LoadingView showShortMessage:@"Select at least one operator"];
        return;
    }
    
    NSMutableArray *operators = [NSMutableArray array];
    for (NSNumber *idx in _selectedIndeces) {
        [operators addObject:_operators[[idx intValue]]];
    }
    [operators sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]]];
    
    FinalPlanningStepScreen *screen = [FinalPlanningStepScreen new];
    screen.run = _run;
    screen.operators = operators;
    screen.date = _date;
    screen.targets = _targets;
    screen.processes = _processes;
    [self.navigationController pushViewController:screen animated:true];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _operators.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"OperatorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UserModel *u = _operators[indexPath.row];
    cell.textLabel.text = u.name;
    
    if (_selectedIndeces[@(indexPath.row)] != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (_selectedIndeces[@(indexPath.row)] != nil) {
        [_selectedIndeces removeObjectForKey:@(indexPath.row)];
    } else {
        
        if (_selectedIndeces.count == _numberOfOperators) {
            [LoadingView showShortMessage:@"Too many operators"];
        } else {
            _selectedIndeces[@(indexPath.row)] = @(true);
        }
    }
    [tableView reloadData];
}

#pragma mark - Utils

- (void) initLayout
{
    self.title = [NSString stringWithFormat:@"Select up to %d operators", _numberOfOperators];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
}

@end
