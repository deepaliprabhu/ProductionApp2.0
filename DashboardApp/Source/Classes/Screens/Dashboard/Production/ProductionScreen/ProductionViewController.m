//
//  ProductionViewController.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 24/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProductionViewController.h"
#import "LoadingView.h"
#import "Defines.h"
#import "ProdAPI.h"
#import "UserModel.h"
#import "OperatorCell.h"
#import "ProductionOverview.h"
#import "LayoutUtils.h"
#import "RunDetailsScreen.h"
#import "ProductionTargetView.h"
#import "OperatorTargetView.h"
#import "DataManager.h"
#import "NSDate+Utils.h"

@interface ProductionViewController () <UITableViewDelegate, UITableViewDataSource, ProductionOverviewProtocol, ProductionTargetViewProtocol, OperatorTargetViewProtocol>

@end

@implementation ProductionViewController {
    
    __weak IBOutlet UITableView *_operatorsTable;
    
    __weak IBOutlet UILabel *_todayLabel;
    __weak IBOutlet UIButton *_yesterdayButton;
    __weak IBOutlet UIButton *_tomorrowButton;
    
    __weak IBOutlet NSLayoutConstraint *_selectionViewLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *_selectionViewWidthConstraint;
    
    NSArray *_selectionConstants;
    NSMutableArray *_operators;
    
    ProductionOverview *_flowView1;
    ProductionTargetView *_flowView2;
    OperatorTargetView *_flowView3;
    
    NSMutableArray *_runs;
    NSMutableDictionary *_operatorsSchedule;
    
    int _selectedOperator;
    
    NSDate *_selectedDate;
}

- (void)viewDidLoad {
    
    _selectedOperator = -1;
    
    [super viewDidLoad];
    [self initLayout];
    [self getPersons];
    
    _selectionConstants = @[@[@(33), @(137)], @[@(189), @(68)], @[@(273), @(68)]];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) todayButtonTapped {
    
    _selectedDate = [NSDate date];
    [self changeSelectionTo:0];
}

- (IBAction) yesterdayButtonTapped {
    
    _selectedDate = [[NSDate date] dateByAddingTimeInterval:-3600*24];
    [self changeSelectionTo:1];
}

- (IBAction) tomorrowButtonTapped {
    
    _selectedDate = [[NSDate date] dateByAddingTimeInterval:3600*24];
    [self changeSelectionTo:2];
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _operators.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _operatorsTable.frame.size.width, 8)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"OperatorCell";
    OperatorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    UserModel *user = _operators[indexPath.row];
    NSArray *times = _operatorsSchedule[user.name];
    [cell layoutWithPerson:user time:[times[0] intValue] completed:[times[1] intValue] selected:_selectedOperator==indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedOperator = (int)indexPath.row;
    [tableView reloadData];
    
    UserModel *user = _operators[indexPath.row];
    
    if (_flowView3.alpha == 0 || [_flowView3.user.username isEqualToString:user.username] == false) {
        
        if (_flowView3.alpha == 1) {
            
            _flowView3.user = user;
            [_flowView3 reloadData];
        } else {
            
            BOOL firstLoad = false;
            if (_flowView3 == nil) {
                [self addFlowView3];
                firstLoad = true;
            }
            _flowView3.user = user;
            _flowView3.alpha = 0;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                if (_flowView1.alpha == 1)
                    _flowView1.alpha = 0;
                else
                    _flowView2.alpha = 0;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    _flowView3.alpha = 1;
                    if (firstLoad == false)
                        [_flowView3 reloadData];
                }];
            }];
        }
    }
}

#pragma mark - OperatorTargetViewProtocol

- (void) goBackFromOperatorView {
    
    _selectedOperator = -1;
    [_operatorsTable reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView3.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView1.alpha = 1;
            [_flowView1 reloadData];
        }];
    }];
}

- (void) newInputLogSet {
    
    [_operatorsSchedule removeAllObjects];
    [self computeRuns];
}

#pragma mark - ProductionTargetViewProtocol

- (void) goBackFromTargetView {
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView2.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView1.alpha = 1;
            [_flowView1 reloadData];
        }];
    }];
}

- (void) newTargeWasSet {
    
    [_operatorsSchedule removeAllObjects];
    [self computeRuns];
}

- (void) newProcessTimeWasSet {
    
    [_operatorsSchedule removeAllObjects];
    [self computeRuns];
}

#pragma mark - ProductionOverviewProcotol

- (void) goToTargets {
    
    BOOL firstLoad = false;
    if (_flowView2 == nil) {
        [self addFlowView2];
        firstLoad = true;
    }
    _flowView2.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView1.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView2.alpha = 1;
            if (firstLoad == false)
                [_flowView2 reloadData];
        }];
    }];
}

- (void) showDetailsForRun:(Run*)run {

    RunDetailsScreen *screen = [RunDetailsScreen new];
    screen.run = run;
    [self.navigationController pushViewController:screen animated:true];
}

- (NSDate *)selectedDate {
    return _selectedDate;
}

#pragma mark - Layout

- (void) initLayout {
    
    _selectedDate = [NSDate date];
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"dd MMM";
    _todayLabel.text = [[f stringFromDate:_selectedDate] uppercaseString];
    
    NSString *t = [[f stringFromDate: [_selectedDate dateByAddingTimeInterval:24*3600]] uppercaseString];
    [_tomorrowButton setTitle:t forState:UIControlStateNormal];
    
    NSString *y = [[f stringFromDate: [_selectedDate dateByAddingTimeInterval:-24*3600]] uppercaseString];
    [_yesterdayButton setTitle:y forState:UIControlStateNormal];
    
    [self addFlowView1];
}

- (void) changeSelectionTo:(int)index {
    
    if (_flowView1.alpha == 1)
        [_flowView1 reloadData];
    else if (_flowView2.alpha == 1)
        [_flowView2 reloadData];
    else
        [_flowView3 reloadData];
    
    _selectionViewLeadingConstraint.constant = [_selectionConstants[index][0] floatValue];
    _selectionViewWidthConstraint.constant = [_selectionConstants[index][1] floatValue];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) addFlowView1 {
    
    _flowView1 = [ProductionOverview createView];
    _flowView1.delegate = self;
    _flowView1.translatesAutoresizingMaskIntoConstraints = false;
    [LayoutUtils addContraintWidth:668 andHeight:687 forView:_flowView1];
    [self.view addSubview:_flowView1];
    [LayoutUtils addLeadingConstraintFromView:_flowView1 toView:self.view constant:356];
    [LayoutUtils addTopConstraintFromView:_flowView1 toView:self.view constant:81];
}

- (void) addFlowView2 {
    
    _flowView2 = [ProductionTargetView createView];
    _flowView2.delegate = self;
    _flowView2.operators = _operators;
    _flowView2.translatesAutoresizingMaskIntoConstraints = false;
    [LayoutUtils addContraintWidth:668 andHeight:687 forView:_flowView2];
    [self.view addSubview:_flowView2];
    [LayoutUtils addLeadingConstraintFromView:_flowView2 toView:self.view constant:356];
    [LayoutUtils addTopConstraintFromView:_flowView2 toView:self.view constant:81];
}

- (void) addFlowView3 {
    
    _flowView3 = [OperatorTargetView createView];
    _flowView3.delegate = self;
    _flowView3.parent = self;
    _flowView3.translatesAutoresizingMaskIntoConstraints = false;
    [LayoutUtils addContraintWidth:668 andHeight:687 forView:_flowView3];
    [self.view addSubview:_flowView3];
    [LayoutUtils addLeadingConstraintFromView:_flowView3 toView:self.view constant:356];
    [LayoutUtils addTopConstraintFromView:_flowView3 toView:self.view constant:81];
}

#pragma mark - Utils

- (void) getPersons {
    
    _operators = [NSMutableArray array];
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] getPersonsWithCompletion:^(BOOL success, id response) {
      
        if (success) {
            
            [LoadingView removeLoading];
            for (NSDictionary *dict in response) {
                
                UserModel *u = [UserModel objectFromData:dict];
                if ([u isOperator])
                    [_operators addObject:u];
            }
            
            [_operators sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]]];
            [_operatorsTable reloadData];
            [self computeRuns];
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

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
    
    _operatorsSchedule = [NSMutableDictionary dictionary];
    for (Run *r in _runs) {
        for (ProcessModel *p in r.processes) {
            for (DayLogModel *d in r.days) {
                if ((d.processId == p.stepId) && [cal isDate:d.date inSameDayAsDate:today] && (d.person.length > 0)) {
                    int time = [p.processingTime intValue]*d.goal;
                    int proc = [p.processingTime intValue]*d.target;
                    if (_operatorsSchedule[d.person] == nil)
                        _operatorsSchedule[d.person] = @[@(time), @(proc)];
                    else
                    {
                        NSArray *times = _operatorsSchedule[d.person];
                        _operatorsSchedule[d.person] = @[@([times[0] intValue]+time), @([times[1] intValue]+proc)]; 
                    }
                }
            }
        }
    }
    
    [_operatorsTable reloadData];
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
