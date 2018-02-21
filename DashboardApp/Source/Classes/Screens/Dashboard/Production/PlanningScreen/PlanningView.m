//
//  PlanningView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 20/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "PlanningView.h"
#import "RunTargetCell.h"
#import "Run.h"
#import "DataManager.h"
#import "ProcessCell.h"
#import "LoadingView.h"
#import "ProdAPI.h"

@implementation PlanningView {
    
    __weak IBOutlet UICollectionView *_runsCollection;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UISlider *_slider;
    __weak IBOutlet UILabel *_targetTotalLabel;
    __weak IBOutlet UILabel *_operatorsTotalLabel;
    __weak IBOutlet UILabel *_hoursTotalLabel;
    __weak IBOutlet NSLayoutConstraint *_tableHeightConstraint;
    __weak IBOutlet UIButton *_totalButton;
    
    IBOutletCollection(UIButton) NSArray *_buttons;
    
    int _selectedRunIndex;
    NSArray *_runs;
    NSMutableArray *_processes;
    NSMutableDictionary *_selectedProcesses;
    
    UILabel *_totalTime;
    
    int _operators;
    int _hours;
    int _target;
}

__CREATEVIEW(PlanningView, @"PlanningView", 0)

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [_runsCollection registerClass:[RunTargetCell class] forCellWithReuseIdentifier:@"RunTargetCell"];
    UINib *cellNib = [UINib nibWithNibName:@"RunTargetCell" bundle:nil];
    [_runsCollection registerNib:cellNib forCellWithReuseIdentifier:@"RunTargetCell"];
    
    for (UIButton *b in _buttons) {
        b.layer.masksToBounds = true;
        b.layer.cornerRadius  = 6;
        b.layer.borderWidth   = 1;
        b.layer.borderColor   = ccolor(102, 102, 102).CGColor;
    }
}

- (void) reloadData {
    
    _runs = [[[DataManager sharedInstance] getRuns] sortedArrayUsingComparator:^NSComparisonResult(Run *obj1, Run *obj2) {
        return [obj1 getRunId] > [obj2 getRunId];
    }];
    [_runsCollection reloadData];
    
    _selectedRunIndex = 0;
    [self getProcessFlow];
}

#pragma mark - Actions

- (IBAction) sliderDidChange {
    
    int total = [_runs[_selectedRunIndex] getQuantity];
    _target = _slider.value*total;
    _targetTotalLabel.text = [NSString stringWithFormat:@"%d", _target];
    [self layoutTotal];
}

- (IBAction) operatorMinusButtonTapped {
    
    if (_operators == 0)
        return;
    
    _operators--;
    [self layoutLabels];
    [self layoutTotal];
}

- (IBAction) operatorPlusButtonTapped {
    
    _operators++;
    [self layoutLabels];
    [self layoutTotal];
}

- (IBAction) hoursMinusButtonTapped {
    
    if (_hours == 0)
        return;
    
    _hours--;
    [self layoutLabels];
    [self layoutTotal];
}

- (IBAction) hoursPlusButtonTapped {
    
    _hours++;
    [self layoutLabels];
    [self layoutTotal];
}

- (IBAction) totalButtonTapped {
    
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _runs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RunTargetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RunTargetCell" forIndexPath:indexPath];
    
    int row = (int)indexPath.row;
    Run *run = _runs[row];
    [cell layoutWithRun:[run getRunId] isSelected:row==_selectedRunIndex isFirst:row==0 isLast:row==_runs.count-1];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedRunIndex = (int)indexPath.row;
    [_runsCollection reloadData];
    [self getProcessFlow];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _processes.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 29;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 31;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self footerView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ProcessCell";
    ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    ProcessModel *p = _processes[indexPath.row];
    [cell layoutWithPlanning:p];
    
    cell.accessoryType = (_selectedProcesses[p.processNo] != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProcessModel *p = _processes[indexPath.row];
    if (_selectedProcesses[p.processNo] == nil)
        _selectedProcesses[p.processNo] = p.processingTime;
    else
        _selectedProcesses[p.processNo] = nil;
    
    [tableView reloadData];
    [self layoutTotal];
}

#pragma mark - Layout

- (UIView*) footerView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 31)];
    view.backgroundColor = ccolor(234, 235, 236);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 7, 200, 17)];
    label.backgroundColor = cclear;
    label.textColor = ccolor(102, 102, 102);
    label.font = ccFont(@"Roboto-Regular", 14);
    label.text = @"Total time per unit";
    [view addSubview:label];
    
    _totalTime = [[UILabel alloc] initWithFrame:CGRectMake(385, 5, 70, 21)];
    _totalTime.textAlignment = NSTextAlignmentCenter;
    _totalTime.backgroundColor = cclear;
    _totalTime.textColor = [UIColor blackColor];
    _totalTime.font = ccFont(@"Roboto-Medium", 16);
    _totalTime.text = [NSString stringWithFormat:@"%ds", [self totalPerProduct]];
    [view addSubview:_totalTime];
    
    return view;
}

- (void) layoutLabels {
    
    _operatorsTotalLabel.text = [NSString stringWithFormat:@"%d", _operators];
    _hoursTotalLabel.text = [NSString stringWithFormat:@"%d", _hours];
    _targetTotalLabel.text = [NSString stringWithFormat:@"%d", _target];
    
    Run *r = _runs[_selectedRunIndex];
    [_slider setValue:(float)_target/(float)[r getQuantity]];
}

- (void) layoutTotal {
    
    if (_hours == 0 || _operators == 0) {
        [_totalButton setTitle:@"∞" forState:UIControlStateNormal];
    } else {
        
        float seconds = [self totalPerProduct]*_target;
        float workPerDay = _operators*_hours*3600;
        
        [_totalButton setTitle:[NSString stringWithFormat:@"%.1f", seconds/workPerDay] forState:UIControlStateNormal];
    }
}

- (void) layoutTable {
    
    float min = MIN(_processes.count, 10.5);
    _tableHeightConstraint.constant = min*29;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Utils

- (void) resetTotals {
    
    _operators = 1;
    _hours = 8;
    Run *r = _runs[_selectedRunIndex];
    _target = [r getQuantity];
    [self layoutLabels];
    [self layoutTotal];
}

- (void) getProcessFlow {
    
    [LoadingView showLoading:@"Loading..."];
    Run *r = _runs[_selectedRunIndex];
    [[ProdAPI sharedInstance] getProcessFlowForProduct:[r getProductNumber] completion:^(BOOL success, id response) {
        
        if (success) {
            
            [LoadingView removeLoading];
            _processes = [NSMutableArray array];
            NSMutableArray *processes = [NSMutableArray arrayWithArray:[response firstObject][@"processes"]];
            [processes sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                
                int i1 = [obj1[@"stepid"] intValue];
                int i2 = [obj2[@"stepid"] intValue];
                if (i1<i2)
                    return NSOrderedAscending;
                else
                    return NSOrderedDescending;
            }];
            
            for (int i=0; i<processes.count;i++) {
                
                NSDictionary *processData = processes[i];
                NSDictionary *commonProcess = [[DataManager sharedInstance] getProcessForNo:processData[@"processno"]];
                ProcessModel *model = [ProcessModel objectFromProcess:processData andCommon:commonProcess];
                [_processes addObject:model];
                
                if ([r getCategory] == 0 && [commonProcess[@"processname"] isEqualToString:@"Passive Test"])
                    break;
            }
            
            [_processes sortUsingComparator:^NSComparisonResult(ProcessModel *obj1, ProcessModel *obj2) {
                
                int i1 = [obj1.stepId intValue];
                int i2 = [obj2.stepId intValue];
                if (i1<i2)
                    return NSOrderedAscending;
                else
                    return NSOrderedDescending;
            }];
            
            [self fillTimes];
            [_tableView reloadData];
            [self layoutTable];
            [self resetTotals];
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

- (void) fillTimes {
    
    _selectedProcesses = [NSMutableDictionary dictionary];
    for (ProcessModel *pr in _processes) {
        _selectedProcesses[pr.processNo] = pr.processingTime;
    }
}

- (int) totalPerProduct {
    
    int total = 0;
    for (NSString *obj in [_selectedProcesses allValues]) {
        total += [obj intValue];
    }
    return total;
}

@end
