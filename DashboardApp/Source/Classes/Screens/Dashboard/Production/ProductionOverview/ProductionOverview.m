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
#import "ProcessInfoScreen.h"
#import "UIView+RNActivityView.h"

@implementation ProductionOverview {
    
    __weak IBOutlet UITableView *_processesTable;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
    
    NSMutableArray *_runs;
    NSMutableArray *_processesForThisWeek;
}

__CREATEVIEW(ProductionOverview, @"ProductionOverview", 0)

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(computeRuns) name:kNotificationCommonProcessesReceived object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadData {
    
    [_spinner startAnimating];
    
    [_runs removeAllObjects];
    [_processesForThisWeek removeAllObjects];
    [_processesTable reloadData];
    
    if ([[[DataManager sharedInstance] getCommonProcesses] count] == 0) {
        [[ServerManager sharedInstance] getProcessList];
    } else {
        [self computeRuns];
    }
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProcessModel *p = _processesForThisWeek[indexPath.row][@"process"];
    ProcessInfoScreen *screen = [[ProcessInfoScreen alloc] initWithNibName:@"ProcessInfoScreen" bundle:nil];;
    screen.process = p;
    
    CGRect r = [tableView rectForRowAtIndexPath:indexPath];
    r = [tableView convertRect:r toView:self.superview];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [popover presentPopoverFromRect:r inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
}

#pragma mark - CellProtocol

- (void) showDetailsForRunId:(int)runId {
    Run *r = [[DataManager sharedInstance] getRunWithId:runId];
    [_delegate showDetailsForRun:r];
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
        [_processesForThisWeek removeAllObjects];
        [_spinner stopAnimating];
        [_processesTable reloadData];
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
    
    _processesForThisWeek = [NSMutableArray array];
    for (Run *r in _runs) {
        
        for (ProcessModel *p in r.processes) {
            
            NSString *pers = nil;
            NSNumber *g = nil;
            int t = 0;
            for (DayLogModel *d in r.days) {
                if ([d.processNo isEqualToString:p.processNo]) {
                    t += d.target;
                    
                    if ([cal isDate:d.date inSameDayAsDate:today]) {
                        g = @(d.goal + [g intValue]);
                        if (pers != nil) {
                            if ([pers intValue] == 0) {
                                pers = @"2";
                            } else {
                                pers = [NSString stringWithFormat:@"%d", [pers intValue] + 1];
                            }
                        } else {
                            pers = d.person;
                        }
                    }
                }
            }

            if (t < [r quantity]) {
             
                NSString *status = [NSString stringWithFormat:@"%d/%ld", t, (long)[r quantity]];
                NSString *goal = g == nil ? @"-" : [g stringValue];
                NSString *person = (pers == nil || pers.length == 0)? @"-" : pers;
                NSDictionary *d = @{@"run": @(r.runId), @"process": p, @"status":status, @"target": goal, @"person": person};
                [_processesForThisWeek addObject:d];
            }
        }
    }
    
    [self.superview hideActivityView];
    [_spinner stopAnimating];
    [_processesTable reloadData];
}

@end
