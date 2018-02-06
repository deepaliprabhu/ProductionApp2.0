//
//  ProductionOverview.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProductionOverview.h"
#import "Defines.h"
#import "DataManager.h"
#import "Run.h"
#import "ProdAPI.h"
#import "NSDate+Utils.h"
#import "ProcessModel.h"
#import "DayLogModel.h"
#import "Constants.h"
#import "UserManager.h"

@implementation ProductionOverview {
    
    __weak IBOutlet UIButton *_targetButton;
    __weak IBOutlet UITableView *_processesTable;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
    
    NSMutableArray *_runs;
    NSMutableArray *_processesForThisWeek;
}

__CREATEVIEW(ProductionOverview, @"ProductionOverview", 0)

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(computeRuns) name:kNotificationCommonProcessesReceived object:nil];;
    
    _targetButton.layer.masksToBounds = true;
    _targetButton.layer.cornerRadius  = 7;
    _targetButton.layer.borderWidth   = 1;
    _targetButton.layer.borderColor   = ccolor(102, 102, 102).CGColor;
    
    [_spinner startAnimating];
    if ([[[DataManager sharedInstance] getCommonProcesses] count] == 0) {
        [[ServerManager sharedInstance] getProcessList];
    } else {
        [self computeRuns];
    }
    
    _targetButton.alpha = [[[UserManager sharedInstance] loggedUser] isAdmin];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadData {
    
    [_spinner startAnimating];
    
    [_runs removeAllObjects];
    [_processesForThisWeek removeAllObjects];
    [_processesTable reloadData];
    
    [self computeRuns];
}

#pragma mark - Actions

- (IBAction) targetButtonTapped {
    [_delegate goToTargets];
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _processesForThisWeek.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier2 = @"ProductionProcessCell";
    ProductionProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil][0];
        cell.delegate = self;
    }
    
    [cell layoutWithData:_processesForThisWeek[indexPath.row]];
    
    return cell;
}

#pragma mark - CellProtocol

- (void) showDetailsForRunId:(int)runId {
    Run *r = [[DataManager sharedInstance] getRunWithId:runId];
    [_delegate showDetailsForRun:r];
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
                r.days = daysArr;
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
    
    _processesForThisWeek = [NSMutableArray array];
    for (Run *r in _runs) {
        
        for (ProcessModel *p in r.processes) {
            
            NSString *pers = nil;
            NSNumber *g = nil;
            int t = 0;
            for (DayLogModel *d in r.days) {
                if (d.processId == p.stepId) {
                    t += d.target;
                    
                    if ([cal isDate:d.date inSameDayAsDate:today]) {
                        g = @(d.goal);
                        pers = d.person;
                    }
                }
            }

            if (t < [r quantity]) {
             
                NSString *status = [NSString stringWithFormat:@"%d/%ld", t, (long)[r quantity]];
                NSString *goal = g == nil ? @"-" : [g stringValue];
                NSString *person = (pers == nil || pers.length == 0)? @"-" : pers;
                NSDictionary *d = @{@"run": @(r.runId), @"process": p.processName?p.processName:@"", @"status":status, @"target": goal, @"person": person};
                [_processesForThisWeek addObject:d];
            }
        }
    }
    
    [_spinner stopAnimating];
    [_processesTable reloadData];
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
