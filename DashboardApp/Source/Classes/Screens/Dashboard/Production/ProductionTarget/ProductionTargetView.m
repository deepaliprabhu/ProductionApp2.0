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
#import "OperatorsPickerScreen.h"

@implementation ProductionTargetView {
    
    __weak IBOutlet UICollectionView *_runsCollection;
    __weak IBOutlet UITableView *_processesTable;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
    
    NSMutableArray *_runs;
    
    int _selectedRunIndex;
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

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [_delegate goBackFromTargetView];
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
    [cell layoutWithData:arr[indexPath.row] atRow:indexPath.row];
    
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

#pragma mark - CellProtocol

- (void) showOperatorsForRow:(int)row rect:(CGRect)rect {
    
    OperatorsPickerScreen *screen = [[OperatorsPickerScreen alloc] init];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [popover presentPopoverFromRect:rect inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
}

- (void) showTargetInputForRow:(int)row rect:(CGRect)rect {
    
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
                            if ([date isThisWeek]) {
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
        }
        
        [self getRunningProcessesFrom:processes andDays:daysArr];
    }];
}

- (void) getRunningProcessesFrom:(NSArray*)processes andDays:(NSArray*)days {
    
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    Run *r = _runs[_selectedRunIndex][@"run"];
    NSMutableArray *processesForSelectedRun = [NSMutableArray array];
    for (ProcessModel *p in processes) {
        
        NSString *pers = nil;
        NSNumber *g = nil;
        int t = 0;
        for (DayLogModel *d in days) {
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
            NSDictionary *d = @{@"process": p.processName?p.processName:@"", @"status":status, @"target": goal, @"person": person, @"processingTime":p.processingTime};
            [processesForSelectedRun addObject:d];
        }
    }
    
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

@end
