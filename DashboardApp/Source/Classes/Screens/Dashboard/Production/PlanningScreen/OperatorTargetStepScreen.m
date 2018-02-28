//
//  OperatorTargetStepScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorTargetStepScreen.h"
#import "OperatorTargetEditableCell.h"
#import "Defines.h"
#import "UserModel.h"

@interface OperatorTargetStepScreen () <UITableViewDelegate, UITableViewDataSource, OperatorTargetEditableCellProtocol>

@end

@implementation OperatorTargetStepScreen {
    
    __weak IBOutlet UITableView *_tableView;
    NSMutableDictionary *_targets;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    
    _targets = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in _existingTargets) {
        _targets[dict[@"operator"]] = dict[@"target"];
    }
    [_tableView reloadData];
}

#pragma mark - Actions

- (IBAction) cancelButtonTapped {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction) doneButtonTapped {
 
    NSMutableArray *data = [NSMutableArray array];
    for (NSString *operator in _targets) {
        
        if ([_targets[operator] intValue] > 0) {
            [data addObject:@{@"operator": operator, @"target": _targets[operator]}];
        }
    }
    [data sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"operator" ascending:true]]];
    
    [_delegate operatorData:data];
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _operators.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"OperatorTargetEditableCell";
    OperatorTargetEditableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = __bundle(@"OperatorTargetEditableCell", 0);
        cell.delegate = self;
    }
    
    UserModel *op = _operators[indexPath.row];
    [cell layoutWithOperator:op.name andTarget:_targets[op.name] atIndex:(int)indexPath.row];

    return cell;
}

#pragma mark - CellProtocol

- (void) setTarget:(int)target atIndex:(int)index {
 
    UserModel *op = _operators[index];
    [_targets setObject:@(target) forKey:op.name];
    [_tableView reloadData];
}

#pragma mark - Utils

- (void) initLayout
{
    self.title = @"Set targets";
    
    float h = MIN(_operators.count*44, 440);
    self.preferredContentSize = CGSizeMake(400, h);
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
}

@end
