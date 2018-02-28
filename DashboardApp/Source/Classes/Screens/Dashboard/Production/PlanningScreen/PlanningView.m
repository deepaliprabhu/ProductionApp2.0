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
#import "LoadingView.h"
#import "ProdAPI.h"
#import "DayLogModel.h"
#import "NSDate+Utils.h"
#import "OperatorsPlanningScreen.h"

@implementation PlanningView {
    
    __weak IBOutlet UICollectionView *_runsCollection;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UISlider *_slider;
    __weak IBOutlet UILabel *_targetTotalLabel;
    __weak IBOutlet UILabel *_operatorsTotalLabel;
    __weak IBOutlet UILabel *_hoursTotalLabel;
    __weak IBOutlet UILabel *_totalOverallLabel;
    __weak IBOutlet UILabel *_totalTimeLabel;
    __weak IBOutlet UIButton *_selectButton;
    
    IBOutletCollection(UIButton) NSArray *_buttons;
    
    int _selectedRunIndex;
    NSMutableArray *_runs;
    NSMutableArray *_processes;
    NSMutableDictionary *_selectedProcesses;
    NSMutableDictionary *_targets;
    
    int _noOfOperators;
    int _hours;
    int _target;
    int _selectedIndex;
}

__CREATEVIEW(PlanningView, @"PlanningView", 0)

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    _targets = [NSMutableDictionary dictionary];
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
    
    _runs = [NSMutableArray array];
    for (Run *r in [[DataManager sharedInstance] getRuns]) {
        if ([r isLocked])
            [_runs addObject:r];
    }
    
    [_runs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
    [self setTargets];
}

- (IBAction) operatorMinusButtonTapped {
    
    if (_noOfOperators == 0)
        return;
    
    _noOfOperators--;
    [self layoutLabels];
    [self layoutTotal];
}

- (IBAction) operatorPlusButtonTapped {
    
    _noOfOperators++;
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

- (IBAction) selectButtonTapped {
    
    if (_selectedProcesses.count > 0) {
        [_selectedProcesses removeAllObjects];
        [_selectButton setImage:ccimg(@"deselectAllButton") forState:UIControlStateNormal];
    } else {
        
        for (ProcessModel *p in _processes) {
            _selectedProcesses[p.processNo] = p.processingTime;
        }
        [_selectButton setImage:ccimg(@"selectAllButton") forState:UIControlStateNormal];
    }
    
    [_tableView reloadData];
    [self layoutTotal];
    _totalTimeLabel.text = [NSString stringWithFormat:@"%ds", [self totalPerProduct]];
}

- (IBAction) nextButtonTapped {
    
    if (_targets == 0 || _noOfOperators == 0 || _selectedProcesses.count == 0) {
        [LoadingView showShortMessage:@"Set targets, operators or processes"];
        return;
    }
    
    [self getSlots];
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

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return _selectedProcesses.count ? 50 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (_selectedProcesses.count == 0) {
        return nil;
    } else {
        return [self nextButton];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PlanningProcessCell";
    PlanningProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.delegate = self;
    }
    
    ProcessModel *p = _processes[indexPath.row];
    Run *r = _runs[_selectedRunIndex];
    [cell layoutWithPlanning:p leftQty:[r getQuantity]-p.processed target:[_targets[p.processNo] intValue] atIndex:(int)indexPath.row];
    
    cell.accessoryType = (_selectedProcesses[p.processNo] != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProcessModel *p = _processes[indexPath.row];
    if (_selectedProcesses[p.processNo] == nil) {
        _selectedProcesses[p.processNo] = p.processingTime;
        [_selectButton setImage:ccimg(@"selectAllButton") forState:UIControlStateNormal];
    }
    else {
        _selectedProcesses[p.processNo] = nil;
        if (_selectedProcesses.count == 0)
            [_selectButton setImage:ccimg(@"deselectAllButton") forState:UIControlStateNormal];
    }
    
    [tableView reloadData];
    [self layoutTotal];
    _totalTimeLabel.text = [NSString stringWithFormat:@"%ds", [self totalPerProduct]];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        int value = [[alertView textFieldAtIndex:0].text intValue];
        if (value >= 0) {
            if (alertView.tag == 1) {
                [self targetChangedTo:value];
            } else {
                [self processTimeChangedTo:value];
            }
        }
    }
}

#pragma mark - CellProtocol

- (void) changeTimeForProcessAtIndex:(int)index {
 
    _selectedIndex = index;
    
    ProcessModel *p = _processes[index];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:p.processName message:@"Insert processing time for this process(seconds):" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void) changeTargetForProcessAtIndex:(int)index {
    
    _selectedIndex = index;
    
    ProcessModel *p = _processes[index];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:p.processName message:@"Insert a target value for this process:" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
}

#pragma mark - Layout

- (void) layoutLabels {
    
    _operatorsTotalLabel.text = [NSString stringWithFormat:@"%d", _noOfOperators];
    _hoursTotalLabel.text = [NSString stringWithFormat:@"%d", _hours];
    _targetTotalLabel.text = [NSString stringWithFormat:@"%d", _target];
    
    Run *r = _runs[_selectedRunIndex];
    [_slider setValue:(float)_target/(float)[r getQuantity]];
}

- (void) layoutTotal {
    
    if (_hours == 0 || _noOfOperators == 0) {
        _totalOverallLabel.text = @"∞";
    } else {
        
        __block float seconds = 0;
        if (_targets.count == 0)
            seconds = [self totalPerProduct]*_target;
        else {
            
            for (NSString *processNo in _selectedProcesses) {
                NSString *s = _selectedProcesses[processNo];
                seconds += [_targets[processNo] intValue]*[s intValue];
            }
        }
        float workPerDay = _noOfOperators*_hours*3600;
        _totalOverallLabel.text = [NSString stringWithFormat:@"%.1f", seconds/workPerDay];
    }
}

- (UIView*) nextButton {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 50)];
    view.backgroundColor = cclear;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 5, _tableView.bounds.size.width, 40);
    btn.backgroundColor = ccolor(234, 235, 236);
    [btn setTitle:@"Next >" forState:UIControlStateNormal];
    [btn setTitleColor:ccblack forState:UIControlStateHighlighted];
    [btn setTitleColor:ccolor(102, 102, 102) forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    btn.titleLabel.font = ccFont(@"Roboto-Regular", 21);
    [btn addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

#pragma mark - Services

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
            [self resetTotals];
            _totalTimeLabel.text = [NSString stringWithFormat:@"%ds", [self totalPerProduct]];
            [_tableView reloadData];
            [self getDailyLog];
            [_selectButton setImage:ccimg(@"selectAllButton") forState:UIControlStateNormal];
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

- (void) getDailyLog {
    
    [LoadingView showLoading:@"Loading..."];
    Run *r = _runs[_selectedRunIndex];
    [[ProdAPI sharedInstance] getDailyLogForRun:[r getRunId] product:[r getProductNumber] completion:^(BOOL success, id response) {
        
        if (success) {
            
            [LoadingView removeLoading];
            r.days = [DayLogModel daysFromResponse:response forRun:nil];
            
            [self computeStatusForProcesses];
        }
    }];
}

- (void) computeStatusForProcesses {
    
    Run *r = _runs[_selectedRunIndex];
    for (int i=0; i<_processes.count;i++) {
        
        ProcessModel *p = _processes[i];
        int t = 0;
        for (DayLogModel *d in r.days) {
            if ([d.processNo isEqualToString:p.processNo]) {
                t += d.target;
            }
        }
        
        p.processed = t;
        [_processes replaceObjectAtIndex:i withObject:p];
    }
    
    [_tableView reloadData];
    [self setTargets];
}

- (void) targetChangedTo:(int)value {
 
    Run *r = _runs[_selectedRunIndex];
    ProcessModel *p = _processes[_selectedIndex];
    if (value > [r getQuantity] - p.processed) {
        value = [r getQuantity] - p.processed;
    }
    
    _targets[p.processNo] = @(value);
    
    [_tableView reloadData];
    [self layoutTotal];
    _totalTimeLabel.text = [NSString stringWithFormat:@"%ds", [self totalPerProduct]];
}

- (void) processTimeChangedTo:(int)seconds {
    
    ProcessModel *p = _processes[_selectedIndex];
    
    NSArray *processes = [__DataManager getCommonProcesses];
    NSDictionary *dict = nil;
    int index = -1;
    for (int i=0; i<processes.count; i++) {
        NSDictionary *d = processes[i];
        if ([d[@"processno"] isEqualToString:p.processNo]) {
            dict = d;
            index = i;
            break;
        }
    }
    
    if (dict != nil) {
        
        NSString *secondsString = [NSString stringWithFormat:@"%d", seconds];
        NSMutableDictionary *processData = [NSMutableDictionary dictionaryWithDictionary:dict];
        [processData setObject:secondsString forKey:@"time"];
        
        [__DataManager updateProcessAtIndex:index process:processData];
        [__DataManager syncCommonProcesses];
        
        p.processingTime = secondsString;
        [_processes replaceObjectAtIndex:_selectedIndex withObject:p];
        if (_selectedProcesses[p.processNo] != nil)
            _selectedProcesses[p.processNo] = secondsString;
        
        [_tableView reloadData];
        [self layoutTotal];
        _totalTimeLabel.text = [NSString stringWithFormat:@"%ds", [self totalPerProduct]];
        
        [_delegate newProcessTimeWasSet];
    }
}

- (void) getSlots {
    
    [LoadingView showLoading:@"Loading..."];
    
    NSDateFormatter *f = [NSDateFormatter new];
    f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd";
    
    Run *r = _runs[_selectedRunIndex];
    [[ProdAPI sharedInstance] getSlotsForRun:[r getRunId] completion:^(BOOL success, id response) {
        
        if (success) {
            if ([response isKindOfClass:[NSArray class]]) {
                BOOL hasSlots = false;
                for (NSDictionary *d in response) {
                    
                    if ([d[@"STATUS"] isEqualToString:@"running"]) {
                        
                        NSString *dateStr = d[@"SCHEDULED"];
                        NSDate *date = [f dateFromString:dateStr];
                        if ([date isSameWeekWithDate:[_delegate selectedDate]]) {
                            hasSlots = true;
                            break;
                        }
                    }
                }
                
                if (hasSlots) {
                    [LoadingView removeLoading];
                    [self goToOperators];
                } else {
                    [LoadingView showShortMessage:@"This run is not scheduled for this week!"];
                }
            }
        } else {
            
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

#pragma mark - Utils

- (void) goToOperators {
    
    NSMutableArray *processes = [NSMutableArray array];
    for (NSString *processNo in _selectedProcesses) {
        
        for (ProcessModel *p in _processes) {
            if ([processNo isEqualToString:p.processNo] && [_targets[p.processNo] intValue] > 0) {
                [processes addObject:p];
                break;
            }
        }
    }
    [processes sortUsingComparator:^NSComparisonResult(ProcessModel *obj1, ProcessModel *obj2) {
        
        int p1 = [[obj1.processNo stringByReplacingOccurrencesOfString:@"P" withString:@""] intValue];
        int p2 = [[obj2.processNo stringByReplacingOccurrencesOfString:@"P" withString:@""] intValue];
        return (p1 < p2) ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    OperatorsPlanningScreen *screen = [[OperatorsPlanningScreen alloc] initWithNibName:@"OperatorsPlanningScreen" bundle:nil];
    screen.numberOfOperators = _noOfOperators;
    screen.operators = _operators;
    screen.targets = _targets;
    screen.date = [_delegate selectedDate];
    screen.processes = processes;
    screen.run = _runs[_selectedRunIndex];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [_parent presentViewController:nav animated:true completion:nil];
}

- (void) resetTotals {
    
    _noOfOperators = 1;
    _hours = 8;
    Run *r = _runs[_selectedRunIndex];
    _target = [r getQuantity];
    [self layoutLabels];
    [self setTargets];
}

- (void) fillTimes {
    
    _targets = [NSMutableDictionary dictionary];
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

- (void) setTargets {

    int qty = [_runs[_selectedRunIndex] getQuantity];
    for (ProcessModel *p in _processes) {
        
        if (_target > qty - p.processed) {
            [_targets setObject:@(qty - p.processed) forKey:p.processNo];
        } else {
            [_targets setObject:@(_target) forKey:p.processNo];
        }
    }
    
    [_tableView reloadData];
    [self layoutTotal];
}

@end
