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

@implementation OperatorTargetView {
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
    __weak IBOutlet UILabel *_noWorkLabel;
    
    NSMutableArray *_runs;
    NSMutableArray *_processesForSelectedDay;
    
    int _selectedProcess;
}

+ (OperatorTargetView*) createView
{
    UINib *nib = [UINib nibWithNibName:@"OperatorTargetView" bundle:nil];
    OperatorTargetView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [_spinner startAnimating];
    [self computeRuns];
}

- (void) reloadData {
    
    [_spinner startAnimating];
    
    [_runs removeAllObjects];
    [_processesForSelectedDay removeAllObjects];
    [_tableView reloadData];
    
    [self computeRuns];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    _noWorkLabel.alpha = 0;
    [_delegate goBackFromOperatorView];
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

#pragma mark - CellProtocol

- (void) inputLogAt:(int)index {
    
    _selectedProcess = index;
    NSDictionary *data = _processesForSelectedDay[index];
    
    DailyLogInputScreen *screen = [[DailyLogInputScreen alloc] initWithNibName:@"DailyLogInputScreen" bundle:nil];
    screen.image = [self.superview screenshot];
    screen.delegate = self;
    screen.process = data[@"process"];
    screen.dayLog = data[@"dayModel"];
    screen.run = data[@"run"];
    [_parent presentViewController:screen animated:true completion:nil];
}

#pragma mark - DayLogInputProtocol

- (void) newLogAdded:(NSDictionary *)data {
    
}

- (void) updateLog:(NSDictionary *)data {
 
    DayLogModel *day = [DayLogModel objFromData:data];
    
    NSDictionary *dict = _processesForSelectedDay[_selectedProcess];
    Run *run = dict[@"run"];
    for (Run *r in _runs) {
        
        if ([r getRunId] == [run getRunId]) {
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:r.days];
            for (int i=0;i<arr.count;i++) {
                DayLogModel *d = arr[i];
                if ([d.processId isEqualToString:day.processId] && [d.processNo isEqualToString:day.processNo]) {
                    [arr replaceObjectAtIndex:i withObject:day];
                    break;
                }
            }
            r.days = arr;
            [self getRunningProcesses];
            break;
        }
    }
}

#pragma mark - Utils

- (void) computeRuns {
    
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
                            if ([date isThisWeek]) {
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
            }
            
            if (currentRequests == _runs.count) {
                [self getRunningProcesses];
            }
        }];
    }
}

- (void) getRunningProcesses {
    
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    _processesForSelectedDay = [NSMutableArray array];
    [_tableView reloadData];
    for (Run *r in _runs) {
        
        for (ProcessModel *p in r.processes) {
            
            DayLogModel *day = nil;
            int t = 0;
            for (DayLogModel *d in r.days) {
                if (d.processId == p.stepId) {
                    t += d.target;
                    
                    if ([cal isDate:d.date inSameDayAsDate:today] && [d.person isEqualToString:_user.name]) {
                        day = d;
                    }
                }
            }
            
            if (t < [r quantity] && day != nil) {
                
                NSString *status = [NSString stringWithFormat:@"%d/%ld", t, (long)[r quantity]];
                NSDictionary *d = @{@"run": r, @"process": p, @"status":status, @"dayModel": day};
                [_processesForSelectedDay addObject:d];
            }
        }
    }
    
    [_spinner stopAnimating];
    [_tableView reloadData];
    
    _noWorkLabel.alpha = _processesForSelectedDay.count == 0;
}

- (BOOL) dayLogAlreadyExists:(DayLogModel*)log inArr:(NSArray*)arr {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in arr) {
        if ([c isDate:log.date inSameDayAsDate:d.date] && [d.processId isEqualToString:log.processId])
            return true;
    }
    
    return false;
}

@end
