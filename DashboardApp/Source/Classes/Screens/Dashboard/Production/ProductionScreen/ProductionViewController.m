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
#import "UserManager.h"
#import "OperatorCell.h"
#import "ProductionOverview.h"
#import "LayoutUtils.h"
#import "RunDetailsScreen.h"
#import "ProductionTargetView.h"
#import "OperatorTargetView.h"
#import "DataManager.h"
#import "NSDate+Utils.h"
#import "UIView+RNActivityView.h"
#import "PlanningView.h"

@interface ProductionViewController () <UITableViewDelegate, UITableViewDataSource, ProductionOverviewProtocol, ProductionTargetViewProtocol, OperatorTargetViewProtocol>

@end

@implementation ProductionViewController {
    
    __weak IBOutlet UITableView *_operatorsTable;
    
    __weak IBOutlet UIView *_overallBgView;
    __weak IBOutlet UIView *_targetsBgView;
    __weak IBOutlet UIView *_planningBgView;
    
    __weak IBOutlet UILabel *_todayLabel;
    __weak IBOutlet UIButton *_yesterdayButton;
    __weak IBOutlet UIButton *_tomorrowButton;
    __weak IBOutlet UIButton *_refreshButton;
    
    __weak IBOutlet UIImageView *_targetButtonArrowImage;
    
    __weak IBOutlet NSLayoutConstraint *_targetButtonHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_selectionViewLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *_selectionViewWidthConstraint;
    
    NSArray *_selectionConstants;
    NSMutableArray *_operators;
    
    ProductionOverview *_flowView1;
    ProductionTargetView *_flowView2;
    OperatorTargetView *_flowView3;
    PlanningView *_flowView4;
    
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
    [self reloadData];
    [self changeSelectionTo:0];
}

- (IBAction) yesterdayButtonTapped {
    
    _selectedDate = [[NSDate date] dateByAddingTimeInterval:-3600*24];
    [self reloadData];
    [self changeSelectionTo:1];
}

- (IBAction) tomorrowButtonTapped {
    
    _selectedDate = [[NSDate date] dateByAddingTimeInterval:3600*24];
    [self reloadData];
    [self changeSelectionTo:2];
}

- (IBAction) overallButtonTapped {
    
    if (_flowView1.alpha == 1)
        return;
    
    _selectedOperator = -1;
    _overallBgView.alpha = 1;
    _targetsBgView.alpha = 0;
    _planningBgView.alpha = 0;
    [_operatorsTable reloadData];
    
    [self goToOverall];
}

- (IBAction) targetsButtonTapped {
    
    if (_flowView2.alpha == 1)
        return;
    
    _selectedOperator = -1;
    _overallBgView.alpha = 0;
    _targetsBgView.alpha = 1;
    _planningBgView.alpha = 0;
    [_operatorsTable reloadData];
    
    [self goToTargets];
}

- (IBAction) planningButtonTapped {
    
    if(_flowView4.alpha == 1)
        return;
    
    _selectedOperator = -1;
    _overallBgView.alpha = 0;
    _targetsBgView.alpha = 0;
    _planningBgView.alpha = 1;
    [_operatorsTable reloadData];
    
    [self goToPlanning];
}

- (IBAction) refreshButtonTapped {
    
    if (_flowView1.alpha == 1) {
        [_flowView1 reloadData];
    } else if (_flowView2.alpha == 1) {
        [_flowView2 reloadData];
    } else if (_flowView3.alpha == 1) {
        [_flowView3 reloadData];
    } else {
        [_flowView4 reloadData];
    }
    
    [_operators removeAllObjects];
    [_runs removeAllObjects];
    [_operatorsSchedule removeAllObjects];
    [_operatorsTable reloadData];
    [self getPersons];
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
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"OperatorCell";
    OperatorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    UserModel *user = _operators[indexPath.row];
    NSArray *times = _operatorsSchedule[user.name];
    [cell layoutWithPerson:user times:times selected:_selectedOperator==indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedOperator = (int)indexPath.row;
    [tableView reloadData];
    
    UserModel *user = _operators[indexPath.row];
    if (_flowView3.alpha == 0 || [[_flowView3 getUserModel].username isEqualToString:user.username] == false) {
        
        _targetsBgView.alpha = 0;
        _overallBgView.alpha = 0;
        _planningBgView.alpha = 0;
        
        if (_flowView3.alpha == 1) {
            
            [_flowView3 setUserModel:user];
            [_flowView3 reloadData];
        } else {
            
            if (_flowView3 == nil) {
                [self addFlowView3];
            }
            [_flowView3 setUserModel:user];
            _flowView3.alpha = 0;
            
            [UIView animateWithDuration:0.2 animations:^{
                _flowView1.alpha = 0;
                _flowView2.alpha = 0;
                _flowView4.alpha = 0;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    _flowView3.alpha = 1;
                } completion:^(BOOL finished) {
                    [_flowView3 reloadData];
                }];
            }];
        }
    }
}

#pragma mark - OperatorTargetViewProtocol

- (void) newInputLogSet {
    
    [_operatorsSchedule removeAllObjects];
    [self computeRuns];
}

#pragma mark - ProductionTargetViewProtocol

- (void) newTargeWasSet {
    
    [_operatorsSchedule removeAllObjects];
    [self computeRuns];
}

- (void) newProcessTimeWasSet {
    
    [_operatorsSchedule removeAllObjects];
    [self computeRuns];
}

#pragma mark - ProductionOverviewProcotol

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
    
    if ([[[UserManager sharedInstance] loggedUser] isAdmin] == false) {
        
        _targetButtonArrowImage.alpha = 0;
        _targetButtonHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }
    
    _overallBgView.alpha = 1;
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
    else if (_flowView4.alpha == 1)
        [_flowView4 reloadData];
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
    [_flowView1 reloadData];
}

- (void) addFlowView2 {
    
    _flowView2 = [ProductionTargetView createView];
    _flowView2.delegate = self;
    _flowView2.operators = _operators;
    _flowView2.translatesAutoresizingMaskIntoConstraints = false;
    [LayoutUtils addContraintWidth:668 andHeight:687 forView:_flowView2];
    [self.view insertSubview:_flowView2 belowSubview:_flowView1];
//    [self.view addSubview:_flowView2];
    [LayoutUtils addLeadingConstraintFromView:_flowView2 toView:self.view constant:356];
    [LayoutUtils addTopConstraintFromView:_flowView2 toView:self.view constant:81];
}

- (void) addFlowView3 {
    
    _flowView3 = [OperatorTargetView createView];
    _flowView3.delegate = self;
    _flowView3.parent = self;
    _flowView3.translatesAutoresizingMaskIntoConstraints = false;
    [LayoutUtils addContraintWidth:668 andHeight:687 forView:_flowView3];
    [self.view insertSubview:_flowView3 belowSubview:_flowView1];
//    [self.view addSubview:_flowView3];
    [LayoutUtils addLeadingConstraintFromView:_flowView3 toView:self.view constant:356];
    [LayoutUtils addTopConstraintFromView:_flowView3 toView:self.view constant:81];
}

- (void) addFlowView4 {
    
    _flowView4 = [PlanningView createView];
    _flowView4.translatesAutoresizingMaskIntoConstraints = false;
    [LayoutUtils addContraintWidth:668 andHeight:687 forView:_flowView4];
    [self.view insertSubview:_flowView4 belowSubview:_flowView1];
    [LayoutUtils addLeadingConstraintFromView:_flowView4 toView:self.view constant:356];
    [LayoutUtils addTopConstraintFromView:_flowView4 toView:self.view constant:81];
}

#pragma mark - Utils

- (void) goToOverall {
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView2.alpha = 0;
        _flowView3.alpha = 0;
        _flowView4.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView1.alpha = 1;
        } completion:^(BOOL finished) {
            [_flowView1 reloadData];
        }];
    }];
}

- (void) goToTargets {
    
    if (_flowView2 == nil) {
        [self addFlowView2];
    }
    _flowView2.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView1.alpha = 0;
        _flowView3.alpha = 0;
        _flowView4.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView2.alpha = 1;
        } completion:^(BOOL finished) {
            [_flowView2 reloadData];
        }];
    }];
}

- (void) goToPlanning {
    
    if (_flowView4 == nil) {
        [self addFlowView4];
    }
    _flowView4.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView1.alpha = 0;
        _flowView3.alpha = 0;
        _flowView2.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView4.alpha = 1;
        } completion:^(BOOL finished) {
            [_flowView4 reloadData];
        }];
    }];
}

- (void) getPersons {
    
    _operators = [NSMutableArray array];
    [_operatorsTable reloadData];
    [[ProdAPI sharedInstance] getPersonsWithCompletion:^(BOOL success, id response) {
      
        if (success) {
            
            for (NSDictionary *dict in response) {
                
                UserModel *u = [UserModel objectFromData:dict];
                if ([u isOperator])
                    [_operators addObject:u];
            }
            
            [_operators sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]]];
            _flowView2.operators = _operators;
            [_operatorsTable reloadData];
            [self computeRuns];
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

- (void) reloadData {
    
    [_runs removeAllObjects];
    [_operatorsSchedule removeAllObjects];
    [_operatorsTable reloadData];
    
    [self computeRuns];
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
                            if ([date isSameWeekWithDate:_selectedDate]) {
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
        [_operatorsSchedule removeAllObjects];
        [_operatorsTable reloadData];
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
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    _operatorsSchedule = [NSMutableDictionary dictionary];
    for (Run *r in _runs) {
        for (ProcessModel *p in r.processes) {
            for (DayLogModel *d in r.days) {
                if ([d.processNo isEqualToString:p.processNo] && [cal isDate:d.date inSameDayAsDate:_selectedDate] && (d.person.length > 0)) {
                    int time = [p.processingTime intValue]*d.goal;
                    int proc = [p.processingTime intValue]*d.target;
                    if (_operatorsSchedule[d.person] == nil)
                        _operatorsSchedule[d.person] = @[@(time), @(proc), @(d.target), @(d.goal)];
                    else
                    {
                        NSArray *times = _operatorsSchedule[d.person];
                        _operatorsSchedule[d.person] = @[@([times[0] intValue]+time), @([times[1] intValue]+proc), @([times[2] intValue]+d.target), @([times[3] intValue]+d.goal)];
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
        if ([c isDate:log.date inSameDayAsDate:d.date] && [d.processNo isEqualToString:log.processNo])
            return true;
    }
    
    return false;
}

@end
