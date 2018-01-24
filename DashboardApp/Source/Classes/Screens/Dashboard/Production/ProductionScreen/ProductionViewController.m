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

@interface ProductionViewController () <UITableViewDelegate, UITableViewDataSource, ProductionOverviewProtocol>

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

#pragma mark - ProductionOverviewProcotol

- (void) goToTargets {
    
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
