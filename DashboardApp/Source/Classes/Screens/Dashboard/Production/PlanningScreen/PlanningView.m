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

@implementation PlanningView {
    
    __weak IBOutlet UICollectionView *_runsCollection;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UISlider *_slider;
    __weak IBOutlet UILabel *_targetTotalLabel;
    __weak IBOutlet UILabel *_operatorsTotalLabel;
    __weak IBOutlet UILabel *_hoursTotalLabel;
    __weak IBOutlet UIButton *_totalButton;
    __weak IBOutlet UILabel *_totalTimeLabel;
    __weak IBOutlet UIButton *_selectButton;
    
    IBOutletCollection(UIButton) NSArray *_buttons;
    
    int _selectedRunIndex;
    NSMutableArray *_runs;
    NSMutableArray *_processes;
    NSMutableDictionary *_selectedProcesses;
    NSMutableDictionary *_targets;
    
    int _operators;
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
        
        int target = [[alertView textFieldAtIndex:0].text intValue];
        if (target >= 0) {
            [self processTimeChangedTo:target];
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

#pragma mark - Layout

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
        
        __block float seconds = 0;
        if (_targets.count == 0)
            seconds = [self totalPerProduct]*_target;
        else {
            
            for (NSString *processNo in _selectedProcesses) {
                NSString *s = _selectedProcesses[processNo];
                seconds += [_targets[processNo] intValue]*[s intValue];
            }
        }
        float workPerDay = _operators*_hours*3600;
        
        [_totalButton setTitle:[NSString stringWithFormat:@"%.1f", seconds/workPerDay] forState:UIControlStateNormal];
    }
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
            [_tableView reloadData];
            [self resetTotals];
            _totalTimeLabel.text = [NSString stringWithFormat:@"%ds", [self totalPerProduct]];
            [self getDailyLog];
            
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
            NSMutableArray *daysArr = [NSMutableArray array];
            NSArray *days = [response firstObject][@"processes"];
            days = [days sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:false]]];
            for (int i=0; i<days.count; i++) {
                
                NSDictionary *dict = days[i];
                if ([dict[@"datetime"] isEqualToString:@"0000-00-00 00:00:00"] == true)
                    continue;
                
                DayLogModel *d = [DayLogModel objFromData:dict];
                if ([self dayLogAlreadyExists:d inArr:daysArr] == false)
                    [daysArr addObject:d];
            }
            [daysArr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:true]]];
            r.days = daysArr;
            
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

#pragma mark - Utils

- (void) resetTotals {
    
    _operators = 1;
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

- (BOOL) dayLogAlreadyExists:(DayLogModel*)log inArr:(NSArray*)arr {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in arr) {
        if ([c isDate:log.date inSameDayAsDate:d.date] && [d.processNo isEqualToString:log.processNo])
            return true;
    }
    
    return false;
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
