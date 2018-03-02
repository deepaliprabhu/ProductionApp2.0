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
#import "ProcessInfoScreen.h"
#import "UIView+RNActivityView.h"
#import "FinalPlanningStepScreen.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSelectedRun) name:@"NEWDAYPLANNED" object:nil];
    
    [_runsCollection registerClass:[RunTargetCell class] forCellWithReuseIdentifier:@"RunTargetCell"];
    UINib *cellNib = [UINib nibWithNibName:@"RunTargetCell" bundle:nil];
    [_runsCollection registerNib:cellNib forCellWithReuseIdentifier:@"RunTargetCell"];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadData {
    
    [_spinner startAnimating];
    
    _selectedRunIndex = 0;
    [_runs removeAllObjects];
    [_runsCollection reloadData];
    [_processesTable reloadData];
    [self computeRuns];
}

#pragma mark - Actions

- (void) reloadSelectedRun {
    [self getProcessesForSelectedRunShouldForce:true];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = _runs[_selectedRunIndex][@"processes"];
    ProcessModel *p = arr[indexPath.row][@"process"];
    ProcessInfoScreen *screen = [[ProcessInfoScreen alloc] initWithNibName:@"ProcessInfoScreen" bundle:nil];;
    screen.process = p;
    
    CGRect r = [tableView rectForRowAtIndexPath:indexPath];
    r = [tableView convertRect:r toView:self.superview];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [popover presentPopoverFromRect:r inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
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
    [self getProcessesForSelectedRunShouldForce:false];
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

- (void) showProcessTimeInputForRow:(int)row {
    
    _selectedProcess = row;
    
    NSMutableArray *localProcesses = [NSMutableArray arrayWithArray:_runs[_selectedRunIndex][@"processes"]];
    NSDictionary *data = localProcesses[_selectedProcess];
    ProcessModel *p = data[@"process"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:p.processName message:@"Insert processing time for this process(seconds):" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
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
        
        FinalPlanningStepScreen *screen = [FinalPlanningStepScreen new];
        screen.run = _runs[_selectedRunIndex][@"run"];
        screen.operators = _operators;
        screen.date = [_delegate selectedDate];
        screen.processes = @[p];
        screen.singleTargetPurpose = true;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [_parent presentViewController:nav animated:true completion:nil];
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
        [_runs replaceObjectAtIndex:_selectedRunIndex withObject:@{@"run":r, @"runId": @(r.runId), @"processes": localProcesses}];
        [_processesTable reloadData];
        
        [_delegate newProcessTimeWasSet];
    }
}

#pragma mark - Services

- (void) computeRuns {
    
    [self.superview showActivityViewWithLabel:@"fetching data"];
    
    _runs = [NSMutableArray array];
    
    NSDateFormatter *f = [NSDateFormatter new];
    f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd";
    
    NSArray *runs = [[DataManager sharedInstance] getRuns];
    NSUInteger requests = runs.count;
    __block NSUInteger currentRequests = 0;
    for (Run *r in runs) {
        
        [[ProdAPI sharedInstance] getSlotsForRun:[r getRunId] completion:^(BOOL success, id response) {
            
            if (success) {
                if ([response isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in response) {
                        
                        if ([d[@"STATUS"] isEqualToString:@"running"]) {
                            
                            NSString *dateStr = d[@"SCHEDULED"];
                            NSDate *date = [f dateFromString:dateStr];
                            if ([date isSameWeekWithDate:[_delegate selectedDate]]) {
                                [_runs addObject:@{@"run":r, @"runId":@(r.runId)}];
                                [_runs sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"runId" ascending:true]]];
                                break;
                            }
                        }
                    }
                }
            }

            currentRequests++;
            if (currentRequests == requests) {
                if (_runs.count == 0) {
                    [self.superview hideActivityView];
                    [_spinner stopAnimating];
                } else {
                    [self getProcessesForSelectedRunShouldForce:false];
                }
            }
            [_runsCollection reloadData];
        }];
    }
}

- (void) getProcessesForSelectedRunShouldForce:(BOOL)force {
    
    Run *r = _runs[_selectedRunIndex][@"run"];
    NSArray *pr = _runs[_selectedRunIndex][@"processes"];
    if (pr.count && force == false) {
        [self.superview hideActivityView];
        [_spinner stopAnimating];
        [_processesTable reloadData];
    } else {
        
        [self.superview showActivityViewWithLabel:@"fetching data"];
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
        
        NSArray *days = [NSArray array];
        if (success) {
            days = [DayLogModel daysFromResponse:response forRun:nil];
            r.days = days;
        }
        
        [self getRunningProcessesFrom:processes andDays:days];
    }];
}

- (void) getRunningProcessesFrom:(NSArray*)processes andDays:(NSArray*)days {
    
    NSDate *today = [_delegate selectedDate];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    Run *r = _runs[_selectedRunIndex][@"run"];
    NSMutableArray *processesForSelectedRun = [NSMutableArray array];
    for (ProcessModel *p in processes) {
        
        int t = 0;
        int goal = 0;
        for (DayLogModel *d in days) {
            if ([d.processNo isEqualToString:p.processNo]) {
                t += d.target;
                
                if ([cal isDate:d.date inSameDayAsDate:today]) {
                    goal += d.goal;
                }
            }
        }
        
        if (t < [r quantity]) {
            NSString *status = [NSString stringWithFormat:@"%d/%ld", t, (long)[r quantity]];
            NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"goal": @(goal), @"process": p, @"status":status, @"step": @([p.stepId intValue])}];
            [processesForSelectedRun addObject:d];
        }
    }
    
    [processesForSelectedRun sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"step" ascending:true]]];
    
    [_runs replaceObjectAtIndex:_selectedRunIndex withObject:@{@"run":r, @"runId": @(r.runId), @"processes": processesForSelectedRun}];
    [_processesTable reloadData];
    [_spinner stopAnimating];
    [self.superview hideActivityView];
}

#pragma mark - Utils

@end
