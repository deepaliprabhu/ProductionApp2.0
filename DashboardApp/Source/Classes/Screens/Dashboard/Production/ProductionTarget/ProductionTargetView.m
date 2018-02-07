//
//  ProductionTargetView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProductionTargetView.h"
#import "DataManager.h"
#import "ProdAPI.h"
#import "NSDate+Utils.h"
#import "RunTargetCell.h"
#import "ProcessModel.h"
#import "DayLogModel.h"
#import "LoadingView.h"

@implementation ProductionTargetView {
    
    __weak IBOutlet UICollectionView *_runsCollection;
    __weak IBOutlet UITableView *_processesTable;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
    
    NSMutableArray *_runs;
    
    int _selectedRunIndex;
    int _selectedProcess;
}

+ (ProductionTargetView*) createView
{
    UINib *nib = [UINib nibWithNibName:@"ProductionTargetView" bundle:nil];
    ProductionTargetView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [_runsCollection registerClass:[RunTargetCell class] forCellWithReuseIdentifier:@"RunTargetCell"];
    UINib *cellNib = [UINib nibWithNibName:@"RunTargetCell" bundle:nil];
    [_runsCollection registerNib:cellNib forCellWithReuseIdentifier:@"RunTargetCell"];
    
    [_spinner startAnimating];
    [self computeRuns];
}

- (void) reloadData {
    
    [_spinner startAnimating];
    
    _selectedRunIndex = 0;
    [_runs removeAllObjects];
    [_runsCollection reloadData];
    [_processesTable reloadData];
    [self computeRuns];
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_runs.count) {
        return [_runs[_selectedRunIndex][@"processes"] count];
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ProcessEditableCell";
    ProcessEditableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
        cell.delegate = self;
    }
    
    NSArray *arr = _runs[_selectedRunIndex][@"processes"];
    [cell layoutWithData:arr[indexPath.row] atRow:(int)indexPath.row];
    
    return cell;
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
    [cell layoutWithRun:[_runs[row][@"run"] getRunId] isSelected:row==_selectedRunIndex isFirst:row==0 isLast:row==_runs.count-1];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedRunIndex = (int)indexPath.row;
    [_runsCollection reloadData];
    [self getProcessesForSelectedRun];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
    
        int target = [[alertView textFieldAtIndex:0].text intValue];
        if (target >= 0) {
            if (alertView.tag == 1) {
                [self processTimeChangedTo:target];
            } else {
                [self targetChangedTo:target];
            }
        }
    }
}

#pragma mark - CellProtocol

- (void) showProcessTimeInputForRow:(int)row {
    
    _selectedProcess = row;
    
    NSMutableArray *localProcesses = [NSMutableArray arrayWithArray:_runs[_selectedRunIndex][@"processes"]];
    NSDictionary *data = localProcesses[_selectedProcess];
    ProcessModel *p = data[@"process"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:p.processName message:@"Insert processing time for this process(seconds):" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
}

- (void) showOperatorsForRow:(int)row rect:(CGRect)rect {
    
    NSDate *yesterday = [[NSDate date] dateByAddingTimeInterval:-24*3600];
    if ([[_delegate selectedDate] isSameDayWithDate:yesterday] == true) {
     
        [LoadingView showShortMessage:@"Operator cannot be changed for yesterday's processes"];
    } else {
        
        _selectedProcess = row;
        
        OperatorsPickerScreen *screen = [[OperatorsPickerScreen alloc] init];
        screen.delegate = self;
        screen.operators = _operators;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
        [popover presentPopoverFromRect:rect inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
    }
}

- (void) showTargetInputForRow:(int)row rect:(CGRect)rect {
    
    NSDate *yesterday = [[NSDate date] dateByAddingTimeInterval:-24*3600];
    if ([[_delegate selectedDate] isSameDayWithDate:yesterday] == true) {
        [LoadingView showShortMessage:@"Target cannot be changed for yesterday's processes"];
    } else {
        
        _selectedProcess = row;
        
        NSMutableArray *processes = [NSMutableArray arrayWithArray:_runs[_selectedRunIndex][@"processes"]];
        NSDictionary *dict = processes[_selectedProcess];
        ProcessModel *p = dict[@"process"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:p.processName message:@"Insert a target value for this process:" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
}

#pragma mark - OperatorProtocol

- (void) processTimeChangedTo:(int)seconds {
 
    NSMutableArray *localProcesses = [NSMutableArray arrayWithArray:_runs[_selectedRunIndex][@"processes"]];
    NSDictionary *data = localProcesses[_selectedProcess];
    ProcessModel *p = data[@"process"];
    
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
        
        Run *r = _runs[_selectedRunIndex][@"run"];
        NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:data];
        newDict[@"process"] = p;
        [localProcesses replaceObjectAtIndex:_selectedProcess withObject:newDict];
        [_runs replaceObjectAtIndex:_selectedRunIndex withObject:@{@"run":r, @"processes": localProcesses}];
        [_processesTable reloadData];
        
        [_delegate newProcessTimeWasSet];
    }
}

- (void) targetChangedTo:(int)newTarget {
    
    NSMutableArray *processes = [NSMutableArray arrayWithArray:_runs[_selectedRunIndex][@"processes"]];
    NSDictionary *dict = processes[_selectedProcess];
    
    DayLogModel *day = [DayLogModel new];
    if ([dict[@"dayModel"] isKindOfClass:[DayLogModel class]]) {
        DayLogModel *temp = dict[@"dayModel"];
        day.target = temp.target;
        day.rework = temp.rework;
        day.reject = temp.reject;
        day.goal   = temp.good;
        day.person = temp.person;
        day.comments = temp.comments;
    }
    day.date = [_delegate selectedDate];
    day.goal = newTarget;
    ProcessModel *p = dict[@"process"];
    day.processNo = p.processNo;
    day.processId = p.stepId;
    
    [self saveNew:day];
    [_delegate newTargeWasSet];
}

- (void) operatorChangedTo:(UserModel*)person {
    
    NSString *personName = person ? person.name : @"";
    
    NSMutableArray *processes = [NSMutableArray arrayWithArray:_runs[_selectedRunIndex][@"processes"]];
    NSDictionary *dict = processes[_selectedProcess];
    if ([dict[@"person"] isEqualToString:personName] == false) {
        
        DayLogModel *day = [DayLogModel new];
        if ([dict[@"dayModel"] isKindOfClass:[DayLogModel class]]) {
            DayLogModel *temp = dict[@"dayModel"];
            day.target = temp.target;
            day.rework = temp.rework;
            day.reject = temp.reject;
            day.goal   = temp.goal;
            day.goal   = temp.good;
            day.comments = temp.comments;
        }
        day.date = [_delegate selectedDate];
        day.person = personName;
        ProcessModel *p = dict[@"process"];
        day.processNo = p.processNo;
        day.processId = p.stepId;
        
        [self saveNew:day];
    }
}

#pragma mark - Services

- (void) computeRuns {
    
    _runs = [NSMutableArray array];
    
    NSDateFormatter *f = [NSDateFormatter new];
    f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd";
    
    NSArray *runs = [[DataManager sharedInstance] getRuns];
    for (Run *r in runs) {
        
        [[ProdAPI sharedInstance] getSlotsForRun:[r getRunId] completion:^(BOOL success, id response) {
            
            if (success) {
                if ([response isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in response) {
                        
                        if ([d[@"STATUS"] isEqualToString:@"running"]) {
                            
                            NSString *dateStr = d[@"SCHEDULED"];
                            NSDate *date = [f dateFromString:dateStr];
                            if ([date isSameWeekWithDate:[_delegate selectedDate]]) {
                                [_runs addObject:@{@"run":r}];
                                if (_runs.count == 1)
                                    [self getProcessesForSelectedRun];
                                break;
                            }
                        }
                    }
                }
            }

            [_runsCollection reloadData];
        }];
    }
}

- (void) getProcessesForSelectedRun {
    
    Run *r = _runs[_selectedRunIndex][@"run"];
    NSArray *pr = _runs[_selectedRunIndex][@"processes"];
    if (pr.count) {
        [_spinner stopAnimating];
        [_processesTable reloadData];
    } else {
        
        [_spinner startAnimating];
        [[ProdAPI sharedInstance] getProcessFlowForProduct:[r getProductNumber] completion:^(BOOL success, id response) {
            
            if (success) {
                
                NSMutableArray *pr = [NSMutableArray array];
                NSArray *processes = [response firstObject][@"processes"];
                for (int i=0; i<processes.count;i++) {
                    
                    NSDictionary *processData = processes[i];
                    NSDictionary *commonProcess = [[DataManager sharedInstance] getProcessForNo:processData[@"processno"]];
                    ProcessModel *model = [ProcessModel objectFromProcess:processData andCommon:commonProcess];
                    [pr addObject:model];
                    
                    if ([r getCategory] == 0 && [commonProcess[@"processname"] isEqualToString:@"Passive Test"])
                        break;
                }
                
                [self getDailyLogWithProcesses:pr];
            }
        }];
    }
}

- (void) getDailyLogWithProcesses:(NSArray*)processes {
    
    Run *r = _runs[_selectedRunIndex][@"run"];
    [[ProdAPI sharedInstance] getDailyLogForRun:[r getRunId] product:[r getProductNumber] completion:^(BOOL success, id response) {
        
        NSMutableArray *daysArr = [NSMutableArray array];
        if (success) {
            NSArray *days = [response firstObject][@"processes"];
            days = [days sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:false], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:false]]];
            for (int i=0; i<days.count; i++) {
                
                NSDictionary *dict = days[i];
                if ([dict[@"datetime"] isEqualToString:@"0000-00-00 00:00:00"] == true)
                    continue;
                
                DayLogModel *d = [DayLogModel objFromData:dict];
                if ([self dayLogAlreadyExists:d inArr:daysArr] == false)
                    [daysArr addObject:d];
            }
            [daysArr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:true]]];
        }
        
        [self getRunningProcessesFrom:processes andDays:daysArr];
    }];
}

- (void) getRunningProcessesFrom:(NSArray*)processes andDays:(NSArray*)days {
    
    NSDate *today = [_delegate selectedDate];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    Run *r = _runs[_selectedRunIndex][@"run"];
    NSMutableArray *processesForSelectedRun = [NSMutableArray array];
    for (ProcessModel *p in processes) {
        
        DayLogModel *dayModel = nil;
        int t = 0;
        for (DayLogModel *d in days) {
            if (d.processNo == p.processNo) {
                t += d.target;
                
                if ([cal isDate:d.date inSameDayAsDate:today]) {
                    dayModel = d;
                }
            }
        }
        
        if (t < [r quantity]) {
            NSString *status = [NSString stringWithFormat:@"%d/%ld", t, (long)[r quantity]];
            NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"process": p, @"status":status, @"step": @([p.stepId intValue])}];
            if (dayModel)
                d[@"dayModel"] = dayModel;
            [processesForSelectedRun addObject:d];
        }
    }
    
    [processesForSelectedRun sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"step" ascending:true]]];
    
    [_runs replaceObjectAtIndex:_selectedRunIndex withObject:@{@"run":r, @"processes": processesForSelectedRun}];
    [_processesTable reloadData];
    [_spinner stopAnimating];
}

#pragma mark - Utils

- (BOOL) dayLogAlreadyExists:(DayLogModel*)log inArr:(NSArray*)arr {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in arr) {
        if ([c isDate:log.date inSameDayAsDate:d.date] && [d.processId isEqualToString:log.processId])
            return true;
    }
    
    return false;
}

- (void) saveNew:(DayLogModel*)day {
    
    NSMutableArray *processes = [NSMutableArray arrayWithArray:_runs[_selectedRunIndex][@"processes"]];
    NSDictionary *dict = processes[_selectedProcess];
    
    NSString *json = [NSString stringWithFormat:@"[%@]" ,[ProdAPI jsonString:[day params]]];
    [LoadingView showLoading:@"Loading..."];
    Run *r = _runs[_selectedRunIndex][@"run"];
    [[ProdAPI sharedInstance] addDailyLog:json forRunFlow:[r getRunFlowId] completion:^(BOOL success, id response) {
        
        if (success) {
            [LoadingView removeLoading];
            
            NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            newDict[@"dayModel"] = day;
            [processes replaceObjectAtIndex:_selectedProcess withObject:newDict];
            
            [_runs replaceObjectAtIndex:_selectedRunIndex withObject:@{@"run":r, @"processes": processes}];
            [_processesTable reloadData];
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

@end
