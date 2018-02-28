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
#import "OperatorTargetStepScreen.h"

@interface FinalPlanningStepScreen () <UITableViewDelegate, UITableViewDataSource, OperatorTargetStepScreenProtocol>

@end

@implementation FinalPlanningStepScreen {
    
    __weak IBOutlet UITableView *_tableView;
    NSMutableDictionary *_schedule;
    
    int _tempProcess;
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
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 20)];
    view.backgroundColor = cclear;
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 200, 44)];
//    btn.backgroundColor = cclear;
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.tag = section;
//    [btn setTitle:@"Add operator" forState:UIControlStateNormal];
//    [btn setTitleColor:ccolor(102, 102, 102) forState:UIControlStateNormal];
//    [btn setTitleColor:ccblack forState:UIControlStateHighlighted];
//    btn.titleLabel.font = ccFont(@"Roboto-Medium", 16);
//    [btn addTarget:self action:@selector(addOperatorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btn];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProcessCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ProcessCell"];
            cell.textLabel.font = ccFont(@"Roboto-Light", 18);
            cell.detailTextLabel.textColor = ccolor(51, 204, 51);
        }
        
        ProcessModel *p = _processes[indexPath.section];
        NSString *text = [NSString stringWithFormat:@"%@ %@", p.processNo, p.processName];
        if (text.length > 50) {
            text = [text substringToIndex:50];
            text = [NSString stringWithFormat:@"%@...", text];
        }
        cell.textLabel.text = text;
        cell.detailTextLabel.text = [_targets[p.processNo] stringValue];
        
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OperatorCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"OperatorCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = ccFont(@"Roboto-Light", 18);
            cell.detailTextLabel.textColor = ccolor(51, 204, 51);
            cell.indentationLevel = 2;
        }
        
        ProcessModel *p = _processes[indexPath.section];
        NSDictionary *data = _schedule[p.processNo][indexPath.row-1];
        cell.textLabel.text = data[@"operator"];
        cell.detailTextLabel.text = [data[@"target"] stringValue];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        
        _tempProcess = (int)indexPath.section;
        ProcessModel *p = _processes[_tempProcess];
        
        OperatorTargetStepScreen *screen = [[OperatorTargetStepScreen alloc] init];
        screen.delegate = self;
        screen.operators = _operators;
        screen.existingTargets = _schedule[p.processNo];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        CGRect r = [_tableView rectForRowAtIndexPath:indexPath];
        r = [_tableView convertRect:r toView:self.view];
        r.origin.x += 450;
        r.size.width -= 450;
        [popover presentPopoverFromRect:r inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:true];
    }
}

#pragma mark - OperatorPickerProtocol

- (void) operatorData:(NSArray*)data {
    
    ProcessModel *p = _processes[_tempProcess];
    _schedule[p.processNo] = data;
    [_tableView reloadData];
}

#pragma mark - Layout

- (void) initLayout
{
    self.title = @"Set operators";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Schedule" style:UIBarButtonItemStyleDone target:self action:@selector(scheduleButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
}

@end
