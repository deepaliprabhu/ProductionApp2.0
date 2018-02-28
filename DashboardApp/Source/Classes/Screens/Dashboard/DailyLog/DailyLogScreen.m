//
//  DailyLogScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "DailyLogScreen.h"
#import "Run.h"
#import "ProdAPI.h"
#import "DayLogModel.h"
#import "DataManager.h"
#import "LoadingView.h"
#import "DailyLogCell.h"
#import "DailyLogHeaderView.h"
#import "Constants.h"
#import "ServerManager.h"
#import "NSDate+Utils.h"

@interface DailyLogScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DailyLogScreen {
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_noLogsLabel;
    
    NSMutableArray *_allLogs;
    NSMutableArray *_days;
    int _totalRequests;
    int _currentRequest;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commonProcessedArrived) name:kNotificationCommonProcessesReceived object:nil];
    [[ServerManager sharedInstance] getProcessList];
    _allLogs = [NSMutableArray array];
    _days = [NSMutableArray array];
    [self getData];
}

#pragma mark - Actions

- (void) commonProcessedArrived {
    
    [_tableView reloadData];
}

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _days.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_days[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [DailyLogHeaderView height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    DailyLogHeaderView *view = [DailyLogHeaderView createView];
    DayLogModel *model = [_days[section] firstObject];
    [view layoutWithDate:model.date];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"DailyLogCell";
    DailyLogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    [cell layoutWithLog:_days[indexPath.section][indexPath.row]];
    
    return cell;
}

#pragma mark - Utils

- (void) getData {
    
    NSArray *runs = [[DataManager sharedInstance] getRuns];
    _totalRequests = (int)runs.count;
    _currentRequest = 0;
    
    if (_totalRequests > 0) {
        
        [LoadingView showShortMessage:@"Loading..."];
        for (Run *run in runs) {
            [self getDailyLogForRun:run];
        }
    } else {
        _noLogsLabel.alpha = 1;
    }
}

- (void) getDailyLogForRun:(Run*)run {
    
    [[ProdAPI sharedInstance] getDailyLogForRun:[run getRunId] product:[run getProductNumber] completion:^(BOOL success, id response) {
        
        if (success) {
            
            NSArray *singleDays = [DayLogModel daysFromResponse:response forRun:run];
            if (singleDays.count > 0) {
                [_allLogs addObjectsFromArray:singleDays];
                [_allLogs sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false]]];
                [self computeDays];
                [_tableView reloadData];
            }
        }
        
        _currentRequest++;
        if (_totalRequests == _currentRequest) {
            [LoadingView removeLoading];
            if (_allLogs.count == 0)
                _noLogsLabel.alpha = 1;
        }
    }];
}

- (void) computeDays {
    
    [_days removeAllObjects];
    [_tableView reloadData];
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in _allLogs) {
        
        int index = -1;
        for (int i=0; i<_days.count; i++) {
            DayLogModel *day = [_days[i] firstObject];
            if ([c isDate:[day.date firstDateOfWeek] inSameDayAsDate:[d.date firstDateOfWeek]]) {
                index = i;
                break;
            }
        }
        
        if (index != -1) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_days[index]];
            [arr addObject:d];
            [_days replaceObjectAtIndex:index withObject:arr];
        } else {
            [_days addObject:@[d]];
        }
    }
    
    [_tableView reloadData];
}

@end
