//
//  FinalPlanningStepScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 27/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "FinalPlanningStepScreen.h"
#import "ProcessModel.h"
#import "Defines.h"
#import "OperatorTargetStepScreen.h"
#import "DayLogModel.h"
#import "NSDate+Utils.h"
#import "ProdAPI.h"
#import "LoadingView.h"

@interface FinalPlanningStepScreen () <UITableViewDelegate, UITableViewDataSource, OperatorTargetStepScreenProtocol>

@end

@implementation FinalPlanningStepScreen {
    
    __weak IBOutlet UITableView *_tableView;
    NSMutableDictionary *_schedule;
    
    int _tempProcess;
    int _currentRequest;
    int _totalRequests;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    _schedule = [NSMutableDictionary dictionary];
    [self checkForExistingTargets];
    [_tableView reloadData];
    
    if (_singleTargetPurpose) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self selectProcessAtIndex:0];
        });
    }
}

#pragma mark - Actions

- (IBAction) cancelButtonTapped {
    
    if (_singleTargetPurpose == true) {
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction) scheduleButtonTapped {
 
    _currentRequest = 0;
    _totalRequests = 0;
    for (NSString *processNo in _schedule) {
        _totalRequests += [_schedule[processNo] count];
    }
    
    if (_totalRequests == 0) {
        
        [self dismissViewControllerAnimated:true completion:nil];
        return;
    }
    
    [LoadingView showLoading:@"Saving..."];
    for (NSString *processNo in _schedule) {
        
        for (NSDictionary *schedule in _schedule[processNo]) {
            
            NSString *op = schedule[@"operator"];
            int target = [schedule[@"target"] intValue];
            
            DayLogModel *newDay = [DayLogModel new];
            
            for (DayLogModel *day in _run.days) {
                
                if ([_date isSameDayWithDate:day.date] && [processNo isEqualToString:day.processNo] && [op isEqualToString:day.person]) {
                    
                    newDay.dayLogID = day.dayLogID;
                    newDay.target = day.target;
                    newDay.rework = day.rework;
                    newDay.reject = day.reject;
                    newDay.good   = day.good;
                    newDay.comments = day.comments;
                    break;
                }
            }
            
            newDay.person = op;
            newDay.date = _date;
            newDay.goal = target;
            newDay.processNo = processNo;
            
            [self saveNew:newDay];
        }
    }
}

- (void) saveNew:(DayLogModel*)day {
    
    NSString *json = [NSString stringWithFormat:@"[%@]" ,[ProdAPI jsonString:[day params]]];
    [[ProdAPI sharedInstance] addDailyLog:json forRunFlow:[_run getRunFlowId] completion:^(BOOL success, id response) {
        
        _currentRequest++;
        if (_currentRequest == _totalRequests) {
            [LoadingView removeLoading];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWDAYPLANNED" object:nil];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _processes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ProcessModel *p = _processes[section];
    return 1 + [_schedule[p.processNo] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 20)];
    view.backgroundColor = cclear;
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProcessCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ProcessCell"];
            cell.textLabel.font = ccFont(@"Roboto-Light", 18);
            cell.detailTextLabel.textColor = ccolor(51, 204, 51);
        }
        
        ProcessModel *p = _processes[indexPath.section];
        NSString *text = [NSString stringWithFormat:@"%@ %@", p.processNo, p.processName];
        if (text.length > 50) {
            text = [text substringToIndex:50];
            text = [NSString stringWithFormat:@"%@...", text];
        }
        cell.textLabel.text = text;
        cell.detailTextLabel.text = [_targets[p.processNo] stringValue];
        
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OperatorCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"OperatorCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = ccFont(@"Roboto-Light", 18);
            cell.detailTextLabel.textColor = ccolor(51, 204, 51);
            cell.indentationLevel = 2;
        }
        
        ProcessModel *p = _processes[indexPath.section];
        NSDictionary *data = _schedule[p.processNo][indexPath.row-1];
        cell.textLabel.text = data[@"operator"];
        cell.detailTextLabel.text = [data[@"target"] stringValue];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        [self selectProcessAtIndex:(int)indexPath.section];
    }
}

#pragma mark - OperatorPickerProtocol

- (void) operatorData:(NSArray*)data {
    
    ProcessModel *p = _processes[_tempProcess];
    _schedule[p.processNo] = data;
    [_tableView reloadData];
}

#pragma mark - Layout

- (void) initLayout
{
    self.title = @"Set operators";
    
    if (_singleTargetPurpose == true) {
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.leftBarButtonItem = left;
    } else {
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.leftBarButtonItem = left;
    }
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Schedule" style:UIBarButtonItemStyleDone target:self action:@selector(scheduleButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - Utils

- (void) checkForExistingTargets {
    
    for (ProcessModel *p in _processes) {
        
        NSMutableArray *schedule = [NSMutableArray array];
        for (DayLogModel *day in _run.days) {
            
            if ([day.date isSameDayWithDate:_date] && [day.processNo isEqualToString:p.processNo]) {
                [schedule addObject:@{@"operator":day.person, @"target": @(day.goal)}];
            }
        }
        
        [schedule sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"operator" ascending:true]]];
        if (schedule.count > 0) {
            _schedule[p.processNo] = schedule;
        }
    }
}

- (void) selectProcessAtIndex:(int)index {
    
    _tempProcess = index;
    ProcessModel *p = _processes[_tempProcess];
    
    OperatorTargetStepScreen *screen = [[OperatorTargetStepScreen alloc] init];
    screen.delegate = self;
    screen.operators = _operators;
    screen.existingTargets = _schedule[p.processNo];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
    CGRect r = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    r = [_tableView convertRect:r toView:self.view];
    
    if (_singleTargetPurpose) {
        r.origin.x += 100;
        r.size.width -= 100;
        [popover presentPopoverFromRect:r inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:true];
    } else {
        r.origin.x += 450;
        r.size.width -= 450;
        [popover presentPopoverFromRect:r inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
    }
}

@end
