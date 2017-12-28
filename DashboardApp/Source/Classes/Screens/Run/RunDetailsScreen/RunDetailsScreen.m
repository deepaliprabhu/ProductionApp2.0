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
#import "DailyLogRawScreen.h"
#import "DailyLogCollectionCell.h"
#import "DailyLogInputScreen.h"

@interface RunDetailsScreen () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, DailyLogInputProtocol>

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

    __weak IBOutlet UIView *_dailyLogHolderView;
    __weak IBOutlet UICollectionView *_dailyLogCollectionView;
    __weak IBOutlet UIActivityIndicatorView *_dailyLogSpinner;
    __weak IBOutlet UIButton *_rawDataButton;
    
    __weak IBOutlet UILabel *_noProcessesLabel;
    __weak IBOutlet UILabel *_noDailyLogLabel;
    
    __weak IBOutlet UILabel *_graphTopLabel;
    
    __weak IBOutlet UILabel *_lockedLabel;
    
    NSMutableArray *_processes;
    NSMutableArray *_days;
    NSMutableArray *_filteredDays;
    int _maxDayLogValue;
    
    ProcessModel *_selectedProcess;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commonProcessesTaken) name:kNotificationCommonProcessesReceived object:nil];;
    
    if ([[[DataManager sharedInstance] getCommonProcesses] count] == 0) {
        [LoadingView showLoading:@"Loading..."];
        [[ServerManager sharedInstance] getProcessList];
    } else {
        [self getProcessFlow];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self fillContent];
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
    
    DailyLogInputScreen *screen = [[DailyLogInputScreen alloc] initWithNibName:@"DailyLogInputScreen" bundle:nil];
    screen.delegate = self;
    screen.process = _selectedProcess;
    screen.dayLog = [self todayLog];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:true completion:nil];
}

- (IBAction) rawButtonTapped {
 
    DailyLogRawScreen *screen = [[DailyLogRawScreen alloc] initWithNibName:@"DailyLogRawScreen" bundle:nil];
    screen.days = _days;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect rect = [_dailyLogHolderView convertRect:_rawDataButton.bounds toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:true];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _filteredDays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    DailyLogCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DailyLogCollectionCell" forIndexPath:indexPath];
    [cell layoutWithDayLog:_filteredDays[indexPath.row] maxVal:_maxDayLogValue];
    return cell;
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

    _selectedProcess = _processes[indexPath.row];
    [self layoutWithProcess:_selectedProcess];
    [self layoutDailyLogForProcess:_selectedProcess];
}

#pragma mark - DailyLogInputProtocol

- (void) newLogAdded:(NSDictionary*)data {
    
    DayLogModel *d = [DayLogModel objFromData:data];
    d.date = [NSDate date];
    [_days addObject:d];
    [self layoutDailyLogForProcess:_selectedProcess];
    [self getTargets];
}

- (void) updateLog:(NSDictionary *)data {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    int index = -1;
    for (int i=0; i<_days.count; i++) {
        DayLogModel *d = _days[i];
        if ([c isDateInToday:d.date]) {
            index = i;
        }
    }
    
    if (index != -1) {
        
        DayLogModel *d = [DayLogModel objFromData:data];
        d.date = [NSDate date];
        [_days replaceObjectAtIndex:index withObject:d];
        [self layoutDailyLogForProcess:_selectedProcess];
        [self getTargets];
    }
}

#pragma mark - Layout

- (void) initLayout {
    
    [_dailyLogCollectionView registerClass:[DailyLogCollectionCell class] forCellWithReuseIdentifier:@"DailyLogCollectionCell"];
    UINib *cellNib = [UINib nibWithNibName:@"DailyLogCollectionCell" bundle:nil];
    [_dailyLogCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"DailyLogCollectionCell"];
    
    _titleLabel.text = cstrf(@"RUN %d", [_run getRunId]);
    
    _yearsHolderView.layer.borderColor = ccolor(190, 190, 190).CGColor;
    _yearsHolderView.layer.borderWidth = 1;
    
    [self fillYears];
}

- (void) layoutWithProcess:(ProcessModel*)model {
    
    _detailsHolderView.alpha = 1;
    _dailyLogHolderView.alpha = 1;
    
    _processTitleLabel.text = model.processName;
    _personLabel.text = model.person;
    _processDetailsLabel.text = model.instructions;
    _timeLabel.text = model.processingTime;
    _dateAssignedLabel.text = model.dateAssigned;
    _dateCompletedLabel.text = model.dateCompleted;
    _qtyGoodLabel.text = model.qtyGood;
    _qtyReworkLabel.text = model.qtyRework;
    _qtyRejectedLabel.text = model.qtyReject;
    
    [_processDetailsLabel scrollRectToVisible:CGRectZero animated:false];
}

#pragma mark - Utils

- (DayLogModel*) todayLog {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *day in _days) {
        if ([c isDateInToday:day.date])
            return day;
    }
    
    return nil;
}

- (void) fillContent {
    
    _lockedLabel.alpha = _run.isLocked;
    
    _runNameLabel.text = [NSString stringWithFormat:@"%@ - %d Units", [_run getProductName], [_run getQuantity]];
    _productNameLabel.text = [_run getProductNumber];
    
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
    
    [self getSales];
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
    [[ProdAPI sharedInstance] getProcessFlowForProduct:[_run getProductNumber] completion:^(BOOL success, id response) {
      
        if (success) {
            
            [LoadingView removeLoading];
            _processes = [NSMutableArray array];
            NSArray *processes = [response firstObject][@"processes"];
            for (int i=0; i<processes.count;i++) {
                
                NSDictionary *processData = processes[i];
                NSDictionary *commonProcess = [[DataManager sharedInstance] getProcessForNo:processData[@"processno"]];
                ProcessModel *model = [ProcessModel objectFromProcess:processData andCommon:commonProcess];
                [_processes addObject:model];
                
                if ([commonProcess[@"processname"] isEqualToString:@"Passive Test"])
                    break;
            }
            [_tableView reloadData];
            if (_processes.count > 0) {
                _selectedProcess = _processes[0];
                [self layoutWithProcess:_selectedProcess];
                [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:false scrollPosition:UITableViewScrollPositionTop];
            }
        
            _noProcessesLabel.alpha = _processes.count == 0 ? 1 : 0;
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
        
        [self getDailyLog];
    }];
}

- (void) getDailyLog {
    
    [_dailyLogSpinner startAnimating];
    [[ProdAPI sharedInstance] getDailyLogForRun:[_run getRunId] product:[_run getProductNumber] completion:^(BOOL success, id response) {
       
        [_dailyLogSpinner stopAnimating];
        if (success) {
            
            _days = [NSMutableArray array];
            NSArray *days = [response firstObject][@"processes"];
            days = [days sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:false]]];
            for (NSDictionary *dict in days) {
                DayLogModel *d = [DayLogModel objFromData:dict];
                if ([self dayLogAlreadyExists:d] == false)
                    [_days addObject:d];
            }
            _rawDataButton.alpha = _days.count == 0 ? 0 : 1;
            [self getTargets];
            [self layoutDailyLogForProcess:_selectedProcess];
        }
    }];
}

- (BOOL) dayLogAlreadyExists:(DayLogModel*)log {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in _days) {
        if ([c isDate:log.date inSameDayAsDate:d.date])
            return true;
    }
    
    return false;
}

- (void) layoutDailyLogForProcess:(ProcessModel*)p {
    
    _filteredDays = [NSMutableArray array];
    _maxDayLogValue = 0;
    for (DayLogModel *d in _days) {
        
        if (d.date != nil && d.processId == p.stepId)
            [_filteredDays addObject: d];
        
        if ([d totalWork] > _maxDayLogValue) {
            _maxDayLogValue = [d totalWork];
        }
    }
    
    [_dailyLogCollectionView reloadData];
    _noDailyLogLabel.alpha = _filteredDays.count == 0 ? 1 : 0;
    
    if (_filteredDays.count > 0) {
        [_dailyLogCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_filteredDays.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:false];
    }
    
    _graphTopLabel.text = [NSString stringWithFormat:@"%.0f", ceilf(_maxDayLogValue*1.2f)];
}

- (void) getTargets {
    
    for (ProcessModel *p in _processes) {
        int target = [self getTodayTargetForProcess:p];
        p.qtyTarget = [NSString stringWithFormat:@"%d", target];
        p.processed = [self getProcessedForProcess:p];
    }
    
    [_tableView reloadData];
    if (_processes.count > 0) {
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:false scrollPosition:UITableViewScrollPositionTop];
    }
}

- (int) getProcessedForProcess:(ProcessModel*)p {
    
    int t = 0;
    for (DayLogModel *d in _days) {
        if (d.processId == p.stepId) {
            t += d.reject + d.rework + d.good;
        }
    }
    
    return t;
}

- (int) getTodayTargetForProcess:(ProcessModel*)p {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in _days) {
        
        if (d.date != nil && d.processId == p.stepId) {
            if ([c isDateInToday:d.date]) {
                return d.target;
            }
        }
    }
    
    return 0;
}

@end
