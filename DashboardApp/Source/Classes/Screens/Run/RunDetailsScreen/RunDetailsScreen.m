//
//  RunDetailsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 18/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunDetailsScreen.h"
#import "Defines.h"
#import "ProdAPI.h"
#import "RunPartsScreen.h"
#import "LoadingView.h"
#import "ProcessModel.h"
#import "DataManager.h"
#import "ServerManager.h"
#import "Constants.h"
#import "ProcessCell.h"
#import "DayLogModel.h"

@interface RunDetailsScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RunDetailsScreen {
    
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UILabel *_runNameLabel;
    __weak IBOutlet UILabel *_productNameLabel;

    __weak IBOutlet UIView *_yearsHolderView;
    __weak IBOutlet UILabel *_currentYearTitleLabel;
    __weak IBOutlet UILabel *_currentYearValueLabel;
    __weak IBOutlet UILabel *_lastYearTitleLabel;
    __weak IBOutlet UILabel *_lastYearValueLabel;
    __weak IBOutlet UILabel *_2YearsAgoTitleLabel;
    __weak IBOutlet UILabel *_2YearsAgoValueLabel;
    
    __weak IBOutlet UILabel *_priorityLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_flowLabel;
    __weak IBOutlet UILabel *_requestDateLabel;
    __weak IBOutlet UILabel *_updatedDateLabel;
    __weak IBOutlet UILabel *_shippingDateLabel;
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UILabel *_processTitleLabel;
    __weak IBOutlet UITextView *_processDetailsLabel;
    __weak IBOutlet UILabel *_personLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_dateAssignedLabel;
    __weak IBOutlet UILabel *_dateCompletedLabel;
    __weak IBOutlet UILabel *_qtyReworkLabel;
    __weak IBOutlet UILabel *_qtyRejectedLabel;
    __weak IBOutlet UILabel *_qtyGoodLabel;
    __weak IBOutlet UIView *_detailsHolderView;
    
    __weak IBOutlet UICollectionView *_dailyLogCollectionView;
    __weak IBOutlet UIActivityIndicatorView *_dailyLogSpinner;
    
    NSMutableArray *_processes;
    NSMutableArray *_days;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commonProcessesTaken) name:kNotificationCommonProcessesReceived object:nil];;
    
    [self getDailyLog];
    if ([[[DataManager sharedInstance] getCommonProcesses] count] == 0) {
        [LoadingView showLoading:@"Loading..."];
        [[ServerManager sharedInstance] getProcessList];
    } else {
        [self getProcessFlow];
    }
}

#pragma mark - Actions

- (void) commonProcessesTaken {
    [self getProcessFlow];
}

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) shortsButtonTapped {
    
    RunPartsScreen *screen = [[RunPartsScreen alloc] initWithNibName:@"RunPartsScreen" bundle:nil];
    screen.run = _run;
    [self.navigationController pushViewController:screen animated:true];
}

- (IBAction) enterDataButtonTapped {
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _processes.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 29;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ProcessCell";
    ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    [cell layoutWith:_processes[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self layoutWithProcess:_processes[indexPath.row]];
}

#pragma mark - Layout

- (void) initLayout {
    
    _titleLabel.text = cstrf(@"RUN %d", [_run getRunId]);
    
    [self fillContent];
    
    _yearsHolderView.layer.borderColor = ccolor(190, 190, 190).CGColor;
    _yearsHolderView.layer.borderWidth = 1;
}

- (void) layoutWithProcess:(ProcessModel*)model {
    
    _detailsHolderView.alpha = 1;
    
    _processTitleLabel.text = model.processName;
    _personLabel.text = model.person;
    _processDetailsLabel.text = model.instructions;
    _timeLabel.text = model.processingTime;
    _dateAssignedLabel.text = model.dateAssigned;
    _dateCompletedLabel.text = model.dateCompleted;
    _qtyGoodLabel.text = model.qtyGood;
    _qtyReworkLabel.text = model.qtyRework;
    _qtyRejectedLabel.text = model.qtyReject;
}

#pragma mark - Utils

- (void) fillContent {
    
    _runNameLabel.text = [NSString stringWithFormat:@"%@ - %d Units", [_run getProductName], [_run getQuantity]];
    _productNameLabel.text = [_run getProductNumber];
    
    [self fillYears];
    [self getSales];
    
    _priorityLabel.text = [_run getPriority] == 0 ? @"LOW" : @"HIGH";
    _statusLabel.text = [_run getStatus];
    _flowLabel.text = [_run getRunData][@"Version"];
    _requestDateLabel.text = [_run getRequestDate];
    _updatedDateLabel.text = [_run getRunData][@"Updated"];
    _shippingDateLabel.text = [_run getRunData][@"Shipping"];
}

- (void) fillYears {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    int y = (int)[c component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    _currentYearTitleLabel.text = cstrf(@"%d", y);
    _lastYearTitleLabel.text = cstrf(@"%d", y-1);
    _2YearsAgoTitleLabel.text = cstrf(@"%d", y-2);
}

- (void) getSales {
    
    [[ProdAPI sharedInstance] getSalesPerYearFor:[_run getProductNumber] completion:^(BOOL success, id response) {
       
        if (success) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                
                NSDictionary *d = [response firstObject];
                if ([d[@"Current Yr Sold"] length] == 0)
                    _currentYearValueLabel.text = @"-";
                else
                    _currentYearValueLabel.text = d[@"Current Yr Sold"];
                
                if ([d[@"Previous Yr Sold"] length] == 0)
                    _lastYearValueLabel.text = @"-";
                else
                    _lastYearValueLabel.text = d[@"Previous Yr Sold"];
                
                if ([d[@"Current Yr Sold"] length] == 0)
                    _2YearsAgoValueLabel.text = @"-";
                else
                    _2YearsAgoValueLabel.text = d[@"Previous To Previous Yr Sold"];
            }
            
        } else {
            
        }
    }];
}

- (void) getProcessFlow {
    
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] getProcessFlowForRun:[_run getRunId] product:[_run getProductNumber] completion:^(BOOL success, id response) {
      
        if (success) {
            
            [LoadingView removeLoading];
            _processes = [NSMutableArray array];
            NSArray *processes = [response firstObject][@"processes"];
            NSString *rCat = [_run getRunData][@"Category"];
            for (NSDictionary *processData in processes) {
                
                NSDictionary *commonProcess = [[DataManager sharedInstance] getProcessForNo:processData[@"processno"]];
                NSString *c = commonProcess[@"category"];
                if ([c isEqualToString:rCat] || [c isEqualToString:@"Common"]) {
                    ProcessModel *model = [ProcessModel objectFromProcess:processData andCommon:commonProcess];
                    [_processes addObject:model];
                }
            }
            [_tableView reloadData];
            if (_processes.count > 0) {
                [self layoutWithProcess:_processes[0]];
                [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:false scrollPosition:UITableViewScrollPositionTop];
            }
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

- (void) getDailyLog {
    
    [_dailyLogSpinner startAnimating];
    [[ProdAPI sharedInstance] getDailyLogForRun:[_run getRunId] product:[_run getProductNumber] completion:^(BOOL success, id response) {
       
        [_dailyLogSpinner stopAnimating];
        if (success) {
            
            _days = [NSMutableArray array];
            NSArray *days = [response firstObject][@"processes"];
            for (NSDictionary *dict in days) {
                DayLogModel *d = [DayLogModel objFromData:dict];
                [_days addObject:d];
            }
            [_dailyLogCollectionView reloadData];
        }
    }];
}

@end
