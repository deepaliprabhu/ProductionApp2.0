//
//  OperatorTargetView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorTargetView.h"
#import "DataManager.h"
#import "ProdAPI.h"
#import "NSDate+Utils.h"
#import "ProcessModel.h"
#import "DayLogModel.h"
#import "UIView+Screenshot.h"
#import "LoadingView.h"
#import "WeeklyGraphCell.h"
#import "ProcessInfoScreen.h"
#import "UIView+RNActivityView.h"

@implementation OperatorTargetView {
    
    __weak IBOutlet UICollectionView *_weeklyGraph;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
    __weak IBOutlet UILabel *_noWorkLabel;
    
    UserModel *_user;
    UserModel *_tempUser;
    
    NSMutableArray *_runs;
    NSMutableArray *_processesForSelectedDay;
    NSMutableArray *_processesForSelectedWeek;
    
    int _selectedProcess;
    BOOL _alreadyLoading;
    long _maxQuantity;
}

+ (OperatorTargetView*) createView
{
    UINib *nib = [UINib nibWithNibName:@"OperatorTargetView" bundle:nil];
    OperatorTargetView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

- (void) setUserModel:(UserModel *)user {
    
    if (_alreadyLoading) {
        _tempUser = user;
    } else {
        _user = user;
    }
}

- (UserModel*) getUserModel {
    return _user;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [_weeklyGraph registerClass:[WeeklyGraphCell class] forCellWithReuseIdentifier:@"WeeklyGraphCell"];
    UINib *cellNib = [UINib nibWithNibName:@"WeeklyGraphCell" bundle:nil];
    [_weeklyGraph registerNib:cellNib forCellWithReuseIdentifier:@"WeeklyGraphCell"];
}

- (void) reloadData {
    
    if (_alreadyLoading == true)
        return;
    
    _alreadyLoading = true;
    
    _noWorkLabel.alpha = 0;
    [_spinner startAnimating];
    
    [_runs removeAllObjects];
    [_processesForSelectedDay removeAllObjects];
    [_processesForSelectedWeek removeAllObjects];
    [_tableView reloadData];
    [_weeklyGraph reloadData];
    
    [self computeRuns];
}

#pragma mark - Actions

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *firstDay = [[_delegate selectedDate] firstDateOfWeek];
    NSDate *selectedDate = [firstDay dateByAddingTimeInterval:indexPath.row*3600*24];
    NSUInteger c = [self processesForDay:selectedDate].count;
    return CGSizeMake([WeeklyGraphCell widthForProcessCount:c], 209);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WeeklyGraphCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeeklyGraphCell" forIndexPath:indexPath];
    NSDate *firstDay = [[_delegate selectedDate] firstDateOfWeek];
    NSDate *selectedDate = [firstDay dateByAddingTimeInterval:indexPath.row*3600*24];
    [cell layoutWithDay:selectedDate processes:[self processesForDay:selectedDate] max:_maxQuantity];
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _processesForSelectedDay.count;
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
    
    [cell layoutWithData:_processesForSelectedDay[indexPath.row] atRow:(int)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProcessModel *p = _processesForSelectedDay[indexPath.row][@"process"];
    ProcessInfoScreen *screen = [[ProcessInfoScreen alloc] initWithNibName:@"ProcessInfoScreen" bundle:nil];;
    screen.process = p;
    
    CGRect r = [tableView rectForRowAtIndexPath:indexPath];
    r = [tableView convertRect:r toView:self.superview];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [popover presentPopoverFromRect:r inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
}

#pragma mark - CellProtocol

- (void) inputLogAt:(int)index {
    
    if ([[_delegate selectedDate] isSameDayWithDate:[NSDate date]] == false) {
        
        [LoadingView showShortMessage:@"Daily log can be inserted only for today's processes"];
    } else {
        
        _selectedProcess = index;
        NSDictionary *data = _processesForSelectedDay[index];
        
        DailyLogInputScreen *screen = [[DailyLogInputScreen alloc] initWithNibName:@"DailyLogInputScreen" bundle:nil];
        screen.image = [self.superview screenshot];
        screen.delegate = self;
        screen.process = data[@"process"];
        screen.dayLog = data[@"dayModel"];
        screen.run = data[@"run"];
        screen.operatorName = _user.name;
        [_parent presentViewController:screen animated:true completion:nil];
    }
}

#pragma mark - DayLogInputProtocol

- (void) newLogAdded:(NSDictionary *)data {
    
}

- (void) updateLog:(NSDictionary *)data {
 
    [_delegate newInputLogSet];
    
    DayLogModel *day = [DayLogModel objFromData:data];
    
    NSDictionary *dict = _processesForSelectedDay[_selectedProcess];
    Run *run = dict[@"run"];
    for (Run *r in _runs) {
        
        if ([r getRunId] == [run getRunId]) {
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:r.days];
            for (int i=0;i<arr.count;i++) {
                DayLogModel *d = arr[i];
                if ([d.processNo isEqualToString:day.processNo]) {
                    [arr replaceObjectAtIndex:i withObject:day];
                    break;
                }
            }
            [arr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:true]]];
            r.days = arr;
            [self getRunningProcesses];
            break;
        }
    }
}

#pragma mark - Utils

- (void) computeRuns {
    
    [self.superview showActivityViewWithLabel:@"fetching data"];
    
    _runs = [NSMutableArray array];
    
    NSDateFormatter *f = [NSDateFormatter new];
    f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd";
    
    __block int currentRequest = 0;
    NSArray *runs = [[DataManager sharedInstance] getRuns];
    for (Run *r in runs) {
        
        [[ProdAPI sharedInstance] getSlotsForRun:[r getRunId] completion:^(BOOL success, id response) {
            
            currentRequest++;
            if (success) {
                if ([response isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in response) {
                        
                        if ([d[@"STATUS"] isEqualToString:@"running"]) {
                            
                            NSString *dateStr = d[@"SCHEDULED"];
                            NSDate *date = [f dateFromString:dateStr];
                            if ([date isSameWeekWithDate:[_delegate selectedDate]]) {
                                [_runs addObject:r];
                                break;
                            }
                        }
                    }
                }
            }
            
            if (currentRequest == runs.count) {
                [self getProcesses];
            }
        }];
    }
}

- (void) getProcesses {
    
    if (_runs.count == 0) {
        
        [self.superview hideActivityView];
        [_processesForSelectedWeek removeAllObjects];
        [_processesForSelectedDay removeAllObjects];
        [_tableView reloadData];
        [_spinner stopAnimating];
        _noWorkLabel.alpha = 1;
        [self computeGraph];
        
        return;
    }
    
    __block int currentRequests = 0;
    for (Run *r in _runs) {
        
        [[ProdAPI sharedInstance] getProcessFlowForProduct:[r getProductNumber] completion:^(BOOL success, id response) {
            
            currentRequests++;
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
                
                r.processes = pr;
            }
            
            if (currentRequests == _runs.count) {
                [self getDailyLog];
            }
        }];
    }
}

- (void) getDailyLog {
    
    __block int currentRequests = 0;
    for (Run *r in _runs) {
        
        [[ProdAPI sharedInstance] getDailyLogForRun:[r getRunId] product:[r getProductNumber] completion:^(BOOL success, id response) {
            
            currentRequests++;
            if (success) {
                r.days = [DayLogModel daysFromResponse:response forRun:nil];
            }
            
            if (currentRequests == _runs.count) {
                [self getRunningProcesses];
            }
        }];
    }
}

- (void) getRunningProcesses {
    
    NSDate *today = [_delegate selectedDate];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    _processesForSelectedWeek = [NSMutableArray array];
    _processesForSelectedDay = [NSMutableArray array];
    [_tableView reloadData];
    for (Run *r in _runs) {
        
        for (ProcessModel *p in r.processes) {
            
            DayLogModel *day = nil;
            int t = 0;
            for (DayLogModel *d in r.days) {
                if ([d.processNo isEqualToString:p.processNo]) {
                    t += d.target;
                    
                    if ([d.person isEqualToString:_user.name]) {
                        
                        if ([cal isDate:d.date inSameDayAsDate:today]) {
                            day = d;
                            NSDictionary *dict = @{@"run": r, @"process": p, @"dayModel": d};
                            [_processesForSelectedWeek addObject:dict];
                        } else if ([d.date isSameWeekWithDate:today]) {
                            NSDictionary *dict = @{@"run": r, @"process": p, @"dayModel": d};
                            [_processesForSelectedWeek addObject:dict];
                        }
                    }
                }
            }
            
            if (day != nil) {
                
                NSString *status = [NSString stringWithFormat:@"%d/%ld", t, (long)[r quantity]];
                NSDictionary *d = @{@"run": r, @"process": p, @"status":status, @"dayModel": day};
                [_processesForSelectedDay addObject:d];
            }
        }
    }
    
    [_spinner stopAnimating];
    [self.superview hideActivityView];
    [_tableView reloadData];
    
    _noWorkLabel.alpha = _processesForSelectedDay.count == 0;
    
    _alreadyLoading = false;
    if (_tempUser != nil) {
        _user = _tempUser;
        _tempUser = nil;
        [self reloadData];
    } else {
        [self computeGraph];
    }
}

- (void) computeGraph {
    
    [self computeYScale];
    [_weeklyGraph reloadData];
}

- (void) computeYScale {
 
    _maxQuantity = 0;
    for (NSDictionary *d in _processesForSelectedWeek) {
        Run *r = d[@"run"];
        _maxQuantity = MAX(_maxQuantity, [r quantity]);
    }
    
    for (int i=0; i<6; i++) {
        
        long val = _maxQuantity/6*(i+1);
        if (val > 10) {
            val = val/10 * 10;
        }

        UILabel *l = (UILabel*)[self viewWithTag:100+i];
        l.text = [NSString stringWithFormat:@"%ld", val];
    }
}

- (NSArray*) processesForDay:(NSDate*)day {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSCalendar *cal = [NSCalendar currentCalendar];
    for (NSDictionary *d in _processesForSelectedWeek) {
        
        DayLogModel *dayModel = d[@"dayModel"];
        if ([cal isDate:dayModel.date inSameDayAsDate:day]) {
            ProcessModel *p = d[@"process"];
            Run *r = d[@"run"];
            [arr addObject:@{@"process":p.processNo, @"run": @(r.runId), @"goal": @(dayModel.goal), @"processed":@(dayModel.target)}];
        }
    }
    
    [arr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"process" ascending:true]]];
    return arr;
}

@end
