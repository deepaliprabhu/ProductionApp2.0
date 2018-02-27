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
#import "OperatorsPickerScreen.h"

@interface FinalPlanningStepScreen () <UITableViewDelegate, UITableViewDataSource, OperatorsPickerScreenProtocol, UIAlertViewDelegate>

@end

@implementation FinalPlanningStepScreen {
    
    __weak IBOutlet UITableView *_tableView;
    NSMutableDictionary *_schedule;
    
    int _tempProcess;
    NSString *_tempOperator;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    _schedule = [NSMutableDictionary dictionary];
    [_tableView reloadData];
}

#pragma mark - Actions

- (IBAction) cancelButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) scheduleButtonTapped {
    
}

- (IBAction) addOperatorButtonTapped:(UIButton*)btn {
    
    _tempProcess = (int)btn.tag;
    
    OperatorsPickerScreen *screen = [[OperatorsPickerScreen alloc] init];
    screen.shouldRemoveNoneFeature = true;
    screen.delegate = self;
    screen.operators = _operators;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect r = [_tableView rectForFooterInSection:btn.tag];
    r.size.width = 100;
    r = [_tableView convertRect:r toView:self.view];
    [popover presentPopoverFromRect:r inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:true];
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
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 44)];
    view.backgroundColor = cclear;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 200, 44)];
    btn.backgroundColor = cclear;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.tag = section;
    [btn setTitle:@"Add operator" forState:UIControlStateNormal];
    [btn setTitleColor:ccolor(102, 102, 102) forState:UIControlStateNormal];
    [btn setTitleColor:ccblack forState:UIControlStateHighlighted];
    btn.titleLabel.font = ccFont(@"Roboto-Medium", 16);
    [btn addTarget:self action:@selector(addOperatorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProcessCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ProcessCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = ccFont(@"Roboto-Light", 18);
        }
        
        ProcessModel *p = _processes[indexPath.section];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", p.processNo, p.processName];
        cell.detailTextLabel.text = [_targets[p.processNo] stringValue];
        
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OperatorCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"OperatorCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = ccFont(@"Roboto-Light", 18);
        }
        
        ProcessModel *p = _processes[indexPath.section];
        NSDictionary *data = _schedule[p.processNo][indexPath.row-1];
        cell.textLabel.text = data[@"operator"];
        cell.detailTextLabel.text = [data[@"target"] stringValue];
        
        return cell;
    }
}

#pragma mark - OperatorPickerProtocol

- (void) operatorChangedTo:(UserModel *)person {

    _tempOperator = person.name;
    ProcessModel *p = _processes[_tempProcess];
    NSString *message = [NSString stringWithFormat:@"Insert a target value for %@:", _tempOperator];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:p.processName message:message delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        int value = [[alertView textFieldAtIndex:0].text intValue];
        if (value >= 0) {
            
            ProcessModel *p = _processes[_tempProcess];
            if (_schedule[p.processNo] == nil) {
                _schedule[p.processNo] = @[@{@"operator": _tempOperator, @"target": @(value)}];
            } else {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:_schedule[p.processNo]];
                [arr addObject:@{@"operator": _tempOperator, @"target": @(value)}];
                _schedule[p.processNo] = arr;
            }
            [_tableView reloadData];
        }
    }
}

#pragma mark - Layout

- (void) initLayout
{
    self.title = @"";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Schedule" style:UIBarButtonItemStyleDone target:self action:@selector(scheduleButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
}

@end
