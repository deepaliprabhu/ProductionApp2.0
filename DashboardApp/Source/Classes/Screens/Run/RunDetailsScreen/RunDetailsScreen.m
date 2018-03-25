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
#import "FailedTestsScreen.h"
#import "LayoutUtils.h"
#import "RunCommentsScreen.h"
#import "ProcessDetailsScreen.h"
#import "DayLogScreen.h"
#import "PODateScreen.h"
#import "PassedTestsScreen.h"
#import "LayoutUtils.h"
#import "DemandsViewController.h"
#import "UIView+Screenshot.h"
#import "NSDate+Utils.h"

@interface RunDetailsScreen () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, DailyLogInputProtocol, PODateScreenDelegate>

@end

@implementation RunDetailsScreen {
    
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UILabel *_runNameLabel;
    __weak IBOutlet UILabel *_productNameLabel;

    __weak IBOutlet UIView *_currentYearHolderView;
    __weak IBOutlet UILabel *_currentYearTitleLabel;
    __weak IBOutlet UILabel *_currentYearValueLabel;
    __weak IBOutlet UIView *_lastYearHolderView;
    __weak IBOutlet UILabel *_lastYearTitleLabel;
    __weak IBOutlet UILabel *_lastYearValueLabel;
    __weak IBOutlet UIView *_2YearsAgoHolderView;
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
    __weak IBOutlet UIButton *_processTitleButton;
    __weak IBOutlet NSLayoutConstraint *_processTitleButtonWidthConstraint;
    __weak IBOutlet UILabel *_qtyReworkLabel;
    __weak IBOutlet UILabel *_qtyRejectedLabel;
    __weak IBOutlet UILabel *_qtyGoodLabel;
    __weak IBOutlet UIView *_detailsHolderView;
    __weak IBOutlet NSLayoutConstraint *_detailsHolderViewHeightConstraint;

    __weak IBOutlet UIView *_dailyLogHolderView;
    __weak IBOutlet UICollectionView *_dailyLogCollectionView;
    __weak IBOutlet UIActivityIndicatorView *_dailyLogSpinner;
    __weak IBOutlet UIButton *_rawDataButton;
    
    __weak IBOutlet UILabel *_noProcessesLabel;
    __weak IBOutlet UILabel *_noDailyLogLabel;
    
    __weak IBOutlet UILabel *_graphTopLabel;
    
    __weak IBOutlet UILabel *_lockedLabel;
    
    __weak IBOutlet UIView *_testsView;
    __weak IBOutlet UIActivityIndicatorView *_testsSpinner;
    __weak IBOutlet UILabel *_passedTestsLabel;
    __weak IBOutlet UILabel *_failedTestsLabel;
    __weak IBOutlet UILabel *_reworkTestsLabel;
    
    NSMutableArray *_processes;
    NSMutableArray *_days;
    NSMutableArray *_filteredDays;
    NSMutableArray *_passiveTests;
    NSMutableArray *_activeTests;
    NSMutableArray *_premoldTests;
    NSMutableArray *_postmoldTests;
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
    
    if (_run.isLocked) {
        
        DailyLogInputScreen *screen = [[DailyLogInputScreen alloc] initWithNibName:@"DailyLogInputScreen" bundle:nil];
        screen.image = [self.view screenshot];
        screen.delegate = self;
        screen.process = _selectedProcess;
        screen.dayLog = [self todayLog];
        screen.run = _run;
        screen.operatorName = @"admin@aginova.com";
        [self presentViewController:screen animated:true completion:nil];
    } else {
        [LoadingView showShortMessage:@"Run has to be locked!"];
    }
}

- (IBAction) rawButtonTapped {
 
    NSMutableArray *days = [NSMutableArray array];
    for (DayLogModel *day in _days) {
        if ([day.processNo isEqualToString:_selectedProcess.processNo])
            [days addObject:day];
    }
    
    DailyLogRawScreen *screen = [[DailyLogRawScreen alloc] initWithNibName:@"DailyLogRawScreen" bundle:nil];
    screen.days = days;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect rect = [_dailyLogHolderView convertRect:_rawDataButton.bounds toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:true];
}

- (IBAction) passedTestsButtonTapped {
    
    NSArray *tests = [self selectedTests];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in tests) {
        
        if (dict[@"passed"]) {
            if ([dict[@"passed"] isEqualToString:@"true"])
                [arr addObject:dict];
        } else {
            if ([dict[@"OverallTestBool"] isEqualToString:@"True"])
                [arr addObject:dict];
        }
    }
    
    PassedTestsScreen *screen = [[PassedTestsScreen alloc] initWithNibName:@"PassedTestsScreen" bundle:nil];
    screen.passedTests = arr;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect rect = [_testsView convertRect:_passedTestsLabel.frame toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
}

- (IBAction) failedTestsButtonTapped {
    
    NSArray *tests = [self selectedTests];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in tests) {
        if (dict[@"passed"]) {
            if ([dict[@"passed"] isEqualToString:@"false"])
                [arr addObject:dict];
        } else {
            if ([dict[@"OverallTestBool"] isEqualToString:@"False"])
                [arr addObject:dict];
        }
    }
    
    FailedTestsScreen *screen = [[FailedTestsScreen alloc] initWithNibName:@"FailedTestsScreen" bundle:nil];
    screen.failedCases = arr;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect rect = [_testsView convertRect:_failedTestsLabel.frame toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
}

- (IBAction) titleButtonTapped {
    
    ProcessDetailsScreen *screen = [[ProcessDetailsScreen alloc] initWithNibName:@"ProcessDetailsScreen" bundle:nil];
    screen.details = _selectedProcess.instructions;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect rect = CGRectMake(540, 240, 10, 40);
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
}

- (IBAction) commentsButtonTapped {
    
    RunCommentsScreen *screen = [[RunCommentsScreen alloc] initWithNibName:@"RunCommentsScreen" bundle:nil];
    screen.run = _run;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:true completion:nil];
}

- (IBAction) demandButtonTapped {
    
    NSString *pr = [_run getProductNumber];
    if ([[DataManager sharedInstance] indexOfDemandForProduct:pr] >= 0) {
        
        DemandsViewController *demandsVC = [DemandsViewController new];
        demandsVC.productNumber = pr;
        [self.navigationController pushViewController:demandsVC animated:true];
    } else {
        
        [LoadingView showShortMessage:cstrf(@"No demand for %@", pr)];
    }
}

//- (IBAction) dateAssignedButtonTapped {
//
//    PODateScreen *screen = [[PODateScreen alloc] initWithNibName:@"PODateScreen" bundle:nil];
//    //    screen.purchase = _visiblePart.purchases[index];
//        screen.delegate = self;
//    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
//    CGRect rect = [_detailsHolderView convertRect:_dateAssignedLabel.frame toView:self.view];
//    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
//}
//
//- (IBAction) dateCompletedButtonTapped {
//
//    PODateScreen *screen = [[PODateScreen alloc] initWithNibName:@"PODateScreen" bundle:nil];
////    screen.purchase = _visiblePart.purchases[index];
//    screen.delegate = self;
//    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
//    CGRect rect = [_detailsHolderView convertRect:_dateCompletedLabel.frame toView:self.view];
//    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
//}

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

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DayLogModel *model = [_filteredDays[indexPath.row] firstObject];
    DayLogScreen *screen = [[DayLogScreen alloc] initWithNibName:@"DayLogScreen" bundle:nil];
    screen.log = model;
    
    UICollectionViewLayoutAttributes * theAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect rect = [collectionView convertRect:theAttributes.frame toView:collectionView.superview.superview.superview];
    rect.size.height = 190;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
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
    [self layoutSelectedProcess];
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

#pragma mark - PODateProtocol

- (void) expectedDateChangedForPO:(NSString *)po {
    
}

#pragma mark - Layout

- (void) initLayout {
    
    [_dailyLogCollectionView registerClass:[DailyLogCollectionCell class] forCellWithReuseIdentifier:@"DailyLogCollectionCell"];
    UINib *cellNib = [UINib nibWithNibName:@"DailyLogCollectionCell" bundle:nil];
    [_dailyLogCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"DailyLogCollectionCell"];
    
    _titleLabel.text = cstrf(@"[%@] RUN %d", [_run getCategory]==0?@"PCB":@"ASSM", [_run getRunId]);
    
    [self layoutYearView:_currentYearHolderView];
    [self layoutYearView:_lastYearHolderView];
    [self layoutYearView:_2YearsAgoHolderView];
    
    [self fillYears];
}

- (void) layoutYearView:(UIView*)view {
 
    view.layer.borderColor = ccolor(204, 204, 204).CGColor;
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = true;
    view.layer.cornerRadius = 6;
}

- (void) layoutProcessTitle {
    
    NSString *title = _selectedProcess.processName;
    if (_selectedProcess.processingTime.length > 0) {
        title = cstrf(@"%@ (time: %@)", title, _selectedProcess.processingTime);
    }
    _processTitleLabel.text = title;
    UIFont *f = [UIFont fontWithName:@"Roboto-Light" size:20];
    _processTitleButtonWidthConstraint.constant = [LayoutUtils widthForText:title withFont:f];
    [self.view layoutIfNeeded];
}

- (void) layoutSelectedProcess {
    
    if (_selectedProcess == nil) {
        _detailsHolderView.alpha = 0;
        _dailyLogHolderView.alpha = 0;
        return;
    }
    
    _detailsHolderView.alpha = 1;
    _dailyLogHolderView.alpha = 1;
    
    [self layoutProcessTitle];
    if (_days.count > 0)
        [self layoutQuantitiesForProcess:_selectedProcess.processNo];
    
    _passedTestsLabel.text = @"";
    _failedTestsLabel.text = @"";
    _reworkTestsLabel.text = @"";
    if ([_selectedProcess isPassiveTests]) {
        
        if (_passiveTests == nil) {
            [self getPassiveTests];
        } else {
            [self layoutPassiveTests];
        }
    } else if ([_selectedProcess isActiveTests]) {
        
        if (_activeTests == nil) {
            [self getActiveTests];
        } else {
            [self layoutActiveTests];
        }
    } else if ([_selectedProcess isPreMoldingTests]) {
        
        if (_premoldTests == nil) {
            [self getPreMoldingTests];
        } else {
            [self layoutPreMoldingTests];
        }
    } else if ([_selectedProcess isPostMoldingTests]) {
        
        if (_postmoldTests == nil) {
            [self getPostMoldingTests];
        } else {
            [self layoutPostMoldingTests];
        }
    } else {
        _testsView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            _detailsHolderViewHeightConstraint.constant = 230;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void) layoutPassiveTests {
    [self layoutTests:_passiveTests];
}

- (void) layoutActiveTests {
    [self layoutTests:_activeTests];
}

- (void) layoutTests:(NSArray*)tests {
    
    [self layoutTests];
    
    int pass = 0;
    int fail = 0;
    for (NSDictionary *d in tests) {
        
        if (d[@"passed"]) {
            
            if ([d[@"passed"] isEqualToString:@"false"])
                fail++;
            else
                pass++;
        } else {
            if ([d[@"OverallTestBool"] isEqualToString:@"False"])
                fail++;
            else
                pass++;
        }
    }
    
    _passedTestsLabel.text = [NSString stringWithFormat:@"%d", pass];
    _failedTestsLabel.text = [NSString stringWithFormat:@"%d", fail];
    _reworkTestsLabel.text = @"N/A";
}

- (void) layoutPreMoldingTests {
    
    [self layoutTests];
    [self layoutMoldingTests:_premoldTests];
}

- (void) layoutPostMoldingTests {
    
    [self layoutTests];
    [self layoutMoldingTests:_postmoldTests];
}

- (void) layoutMoldingTests:(NSArray*)tests {
    
    int pass = 0;
    int fail = 0;
    for (NSDictionary *d in tests) {
        
        if ([d[@"passed"] isEqualToString:@"false"])
            fail++;
        else
            pass++;
    }
    
    _passedTestsLabel.text = [NSString stringWithFormat:@"%d", pass];
    _failedTestsLabel.text = [NSString stringWithFormat:@"%d", fail];
    _reworkTestsLabel.text = @"N/A";
}

- (void) layoutTests {
    
    _testsView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        _detailsHolderViewHeightConstraint.constant = 260;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Services

- (void) getPassiveTests {
    
    [_testsSpinner startAnimating];
    [[ProdAPI sharedInstance] getPassiveTestsWithCompletion:^(BOOL success, id response) {
        
        [_testsSpinner stopAnimating];
        _passiveTests = [NSMutableArray array];
        if (success) {
            if ([response isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *d in response) {
                    if ([d[@"Run"] intValue] == _run.runId) {
                        [arr addObject:d];
                    }
                }
                [self removeDuplicatesFrom:arr to:_passiveTests];
            }
        }
        
        [self layoutPassiveTests];
    }];
}

- (void) getActiveTests {
    
    [_testsSpinner startAnimating];
    [[ProdAPI sharedInstance] getActiveTestsWithCompletion:^(BOOL success, id response) {
        
        [_testsSpinner stopAnimating];
        _activeTests = [NSMutableArray array];
        if (success) {
            if ([response isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *d in response) {
                    if ([d[@"Run"] intValue] == _run.runId) {
                        [arr addObject:d];
                    }
                }
                [self removeDuplicatesFrom:arr to:_activeTests];
            }
        }
        
        [self layoutActiveTests];
    }];
}

- (void) getPreMoldingTests {
 
    [_testsSpinner startAnimating];
    [[ProdAPI sharedInstance] getPreTestsWithCompletion:^(BOOL success, id response) {
       
        [_testsSpinner stopAnimating];
        _premoldTests = [NSMutableArray array];
        if (success) {
            if ([response isKindOfClass:[NSArray class]]) {
                for (NSDictionary *d in response) {
                    if ([d[@"run"] intValue] == _run.runId) {
                        [_premoldTests addObject:d];
                    }
                }
            }
        }
        
        [self layoutPreMoldingTests];
    }];
}

- (void) getPostMoldingTests {
    
    [_testsSpinner startAnimating];
    [[ProdAPI sharedInstance] getPostTestsWithCompletion:^(BOOL success, id response) {
        
        [_testsSpinner stopAnimating];
        _postmoldTests = [NSMutableArray array];
        if (success) {
            if ([response isKindOfClass:[NSArray class]]) {
                for (NSDictionary *d in response) {
                    if ([d[@"run"] intValue] == _run.runId) {
                        [_postmoldTests addObject:d];
                    }
                }
            }
        }
        
        [self layoutPostMoldingTests];
    }];
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
    //    [[ProdAPI sharedInstance] getProcessFlowForRun:[_run getRunId] product:[_run getProductNumber] completion:^(BOOL success, id response) {
    [[ProdAPI sharedInstance] getProcessFlowForProduct:[_run getProductNumber] completion:^(BOOL success, id response) {
        
        if (success) {
            
            [LoadingView removeLoading];
            _processes = [NSMutableArray array];
            NSMutableArray *processes = [NSMutableArray arrayWithArray:[response firstObject][@"processes"]];
            [processes sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
               
                int i1 = [obj1[@"stepid"] intValue];
                int i2 = [obj2[@"stepid"] intValue];
                if (i1<i2)
                    return NSOrderedAscending;
                else
                    return NSOrderedDescending;
            }];
            
            for (int i=0; i<processes.count;i++) {
                
                NSDictionary *processData = processes[i];
                NSDictionary *commonProcess = [[DataManager sharedInstance] getProcessForNo:processData[@"processno"]];
                ProcessModel *model = [ProcessModel objectFromProcess:processData andCommon:commonProcess];
                [_processes addObject:model];
                
                if ([_run getCategory] == 0 && [commonProcess[@"processname"] isEqualToString:@"Passive Test"])
                    break;
            }
            
            [_processes sortUsingComparator:^NSComparisonResult(ProcessModel *obj1, ProcessModel *obj2) {
                
                int i1 = [obj1.stepId intValue];
                int i2 = [obj2.stepId intValue];
                if (i1<i2)
                    return NSOrderedAscending;
                else
                    return NSOrderedDescending;
            }];
            
            [_tableView reloadData];
            if (_processes.count > 0) {
                _selectedProcess = _processes[0];
                [self layoutSelectedProcess];
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
            
            NSArray *days = [DayLogModel daysFromResponse:response forRun:nil];
            _days = [NSMutableArray arrayWithArray:days];
            _rawDataButton.alpha = _days.count == 0 ? 0 : 1;
            [self getTargets];
            [self layoutDailyLogForProcess:_selectedProcess];
        }
    }];
}

#pragma mark - Utils

- (DayLogModel*) todayLog {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *day in _days) {
        if ([c isDateInToday:day.date] && [_selectedProcess.processNo isEqualToString:day.processNo] && [day.person isEqualToString:@"admin@aginova.com"])
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

- (void) layoutQuantitiesForProcess:(NSString*)process {
    
    int total = 0;
    int rework = 0;
    int good = 0;
    for (DayLogModel *d in _days) {
        if ([d.processNo isEqualToString:process]) {
            total += d.target;
            rework += d.rework;
            good += d.good;
        }
    }
    
    _qtyGoodLabel.text = [NSString stringWithFormat:@"%d", good];
    _qtyReworkLabel.text = [NSString stringWithFormat:@"%d", rework];
    _qtyRejectedLabel.text = [NSString stringWithFormat:@"%d", total - good - rework];
}

- (void) layoutDailyLogForProcess:(ProcessModel*)p {
    
    _filteredDays = [NSMutableArray array];
    _maxDayLogValue = (int)_run.quantity;
    
    NSMutableArray *processDays = [NSMutableArray array];
    for (DayLogModel *d in _days) {
        if (d.date != nil && [d.processNo isEqualToString:p.processNo])
            [processDays addObject: d];
    }
    
    for (int i=0; i<processDays.count;i++) {
        
        NSMutableArray *arr = [NSMutableArray array];
        BOOL canGoNext = true;
        while (canGoNext) {
            
            DayLogModel *d1 = processDays[i];
            [arr addObject:d1];
            
            if (i+1 < processDays.count) {
                DayLogModel *d2 = processDays[i+1];
                canGoNext = [d1.date isSameDayWithDate:d2.date];
            } else {
                canGoNext = false;
            }
            if (canGoNext)
                i++;
        }
        [_filteredDays addObject:arr];
    }
    
    [_dailyLogCollectionView reloadData];
    _noDailyLogLabel.alpha = _filteredDays.count == 0 ? 1 : 0;
    
    if (_filteredDays.count > 0) {
        [_dailyLogCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_filteredDays.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:false];
    }
    
    _graphTopLabel.text = [NSString stringWithFormat:@"%d", _maxDayLogValue];
    [self layoutSelectedProcess];
}

- (void) getTargets {
    
    for (ProcessModel *p in _processes) {
//        int target = [self getTodayTargetForProcess:p];
//        p.qtyTarget = [NSString stringWithFormat:@"%d", target];
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
        if ([d.processNo isEqualToString:p.processNo]) {
            t += d.target;
//            t += d.reject + d.rework + d.good;
        }
    }
    
    return t;
}

- (int) getTodayTargetForProcess:(ProcessModel*)p {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in _days) {
        
        if (d.date != nil && [d.processNo isEqualToString:p.processNo]) {
            if ([c isDateInToday:d.date]) {
                return d.target;
            }
        }
    }
    
    return 0;
}

- (void) removeDuplicatesFrom:(NSMutableArray*)array to:(NSMutableArray*)toArr {
    
    for (NSDictionary *d1 in array) {
        
        BOOL shouldAdd = true;
        for (NSDictionary *d2 in array) {
            
            if ([d1[@"panelId"] isEqualToString:d2[@"panelId"]] && [d1[@"pcbId"] isEqualToString:d2[@"pcbId"]]) {
                if ([d2[@"CurrentDate"] longLongValue] > [d1[@"CurrentDate"] longLongValue]) {
                    shouldAdd = false;
                    break;
                }
            }
        }
        
        if (shouldAdd)
            [toArr addObject:d1];
    }
}

- (NSArray*) selectedTests {
    
    NSArray *tests = nil;
    if ([_selectedProcess isActiveTests])
        tests = _activeTests;
    else if ([_selectedProcess isPassiveTests])
        tests = _passiveTests;
    else if ([_selectedProcess isPreMoldingTests])
        tests = _premoldTests;
    else
        tests = _postmoldTests;
    
    return tests;
}

@end
