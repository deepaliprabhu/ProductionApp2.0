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
}

- (void)viewDidLoad {
    
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
    
    [self changeSelectionTo:0];
}

- (IBAction) yesterdayButtonTapped {
    
    [self changeSelectionTo:1];
}

- (IBAction) tomorrowButtonTapped {
    
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
    
    [cell layoutWithPerson:_operators[indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_flowView3.alpha == 0) {
        
        if (_flowView3 == nil)
            [self addFlowView3];
        _flowView3.alpha = 0;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if (_flowView1.alpha == 1)
                _flowView1.alpha = 0;
            else
                _flowView2.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                _flowView3.alpha = 1;
            }];
        }];
    }
}

#pragma mark - OperatorTargetViewProtocol

- (void) goBackFromOperatorView {
    
    [_operatorsTable reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView3.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView1.alpha = 1;
        }];
    }];
}

#pragma mark - ProductionTargetViewProtocol

- (void) goBackFromTargetView {
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView2.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView1.alpha = 1;
        }];
    }];
}

#pragma mark - ProductionOverviewProcotol

- (void) goToTargets {
    
    if (_flowView2 == nil)
        [self addFlowView2];
    _flowView2.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        _flowView1.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _flowView2.alpha = 1;
        }];
    }];
}

- (void) showDetailsForRun:(Run*)run {

    RunDetailsScreen *screen = [RunDetailsScreen new];
    screen.run = run;
    [self.navigationController pushViewController:screen animated:true];
}

#pragma mark - Layout

- (void) initLayout {
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"dd MMM";
    _todayLabel.text = [[f stringFromDate:date] uppercaseString];
    
    NSString *t = [[f stringFromDate: [date dateByAddingTimeInterval:24*3600]] uppercaseString];
    [_tomorrowButton setTitle:t forState:UIControlStateNormal];
    
    NSString *y = [[f stringFromDate: [date dateByAddingTimeInterval:-24*3600]] uppercaseString];
    [_yesterdayButton setTitle:y forState:UIControlStateNormal];
    
    [self addFlowView1];
}

- (void) changeSelectionTo:(int)index {
    
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
    _flowView2.translatesAutoresizingMaskIntoConstraints = false;
    [LayoutUtils addContraintWidth:668 andHeight:687 forView:_flowView2];
    [self.view addSubview:_flowView2];
    [LayoutUtils addLeadingConstraintFromView:_flowView2 toView:self.view constant:356];
    [LayoutUtils addTopConstraintFromView:_flowView2 toView:self.view constant:81];
}

- (void) addFlowView3 {
    
    _flowView3 = [OperatorTargetView createView];
    _flowView3.delegate = self;
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
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

@end
