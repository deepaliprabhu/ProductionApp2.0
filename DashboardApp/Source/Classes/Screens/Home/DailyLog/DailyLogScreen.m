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

@interface DailyLogScreen ()

@end

@implementation DailyLogScreen {
    
    NSMutableArray *_allLogs;
    int _totalRequests;
    int _currentRequest;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _allLogs = [NSMutableArray array];
    [self getData];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
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
    }
}

- (void) getDailyLogForRun:(Run*)run {
    
    [[ProdAPI sharedInstance] getDailyLogForRun:[run getRunId] product:[run getProductNumber] completion:^(BOOL success, id response) {
        
        _currentRequest++;
        if (_totalRequests == _currentRequest)
            [LoadingView removeLoading];
        if (success) {
            
            NSMutableArray *singleDays = [NSMutableArray array];
            NSArray *days = [response firstObject][@"processes"];
            for (int i=0; i<days.count; i++) {
                
                NSDictionary *dict = days[i];
                if ([dict[@"datetime"] isEqualToString:@"0000-00-00 00:00:00"] == true)
                    continue;
                
                DayLogModel *d = [DayLogModel objFromData:dict];
                d.runId = [run getRunId];
                if ([self dayLogAlreadyExists:d inArray:singleDays] == false)
                    [singleDays addObject:d];
            }
            
            if (singleDays.count > 0) {
                [_allLogs addObjectsFromArray:singleDays];
                [_allLogs sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:true]]];
            }
        }
    }];
}

- (BOOL) dayLogAlreadyExists:(DayLogModel*)log inArray:(NSArray*)logs {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in logs) {
        if ([c isDate:log.date inSameDayAsDate:d.date] && [d.processId isEqualToString:log.processId])
            return true;
    }
    
    return false;
}

@end
