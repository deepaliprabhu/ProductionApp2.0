//
//  RunViewController.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunViewController.h"
#import "ConnectionManager.h"
#import "RunPartsViewCell.h"
#import "ServerManager.h"
#import "Constants.h"
#import "DataManager.h"
#import "UIView+RNActivityView.h"
#import "UIImage+FontAwesome.h"


@interface RunViewController ()

@end

@implementation RunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _processFlowButton.layer.cornerRadius = 6.0f;
    _documentationButton.layer.cornerRadius = 6.0f;
    _historyButton.layer.cornerRadius = 6.0f;
    _reportsButton.layer.cornerRadius = 6.0f;
    _ganttButton.layer.cornerRadius = 6.0f;
    _photoButton.layer.cornerRadius = 20.0f;
    _thisYearView.layer.borderColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f].CGColor;
    _thisYearView.layer.borderWidth = 1.0f;
    _lastYearView.layer.borderColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f].CGColor;
    _lastYearView.layer.borderWidth = 1.0f;
    _prevLastYearView.layer.borderColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f].CGColor;
    _prevLastYearView.layer.borderWidth = 1.0f;
    /*_inProcessView.layer.cornerRadius = 29.0f;
    _inProcessView.layer.borderColor = [UIColor grayColor].CGColor;
    _inProcessView.layer.borderWidth = 1.2f;
    _readyView.layer.cornerRadius = 29.0f;
    _readyView.layer.borderColor = [UIColor grayColor].CGColor;
    _readyView.layer.borderWidth = 1.2f;
    _reworkView.layer.cornerRadius = 29.0f;
    _reworkView.layer.borderColor = [UIColor grayColor].CGColor;
    _reworkView.layer.borderWidth = 1.2f;
    _rejectView.layer.cornerRadius = 29.0f;
    _rejectView.layer.borderColor = [UIColor grayColor].CGColor;
    _rejectView.layer.borderWidth = 1.2f;
    _shippedView.layer.cornerRadius = 29.0f;
    _shippedView.layer.borderColor = [UIColor grayColor].CGColor;
    _shippedView.layer.borderWidth = 1.2f;*/
    
    statusArray = [NSMutableArray arrayWithObjects:@"On Hold:Parts Short", @"On Hold:Low Priority",@"NEW: Parts Shortage", @"NEW: BOM Inspection", @"NEW: Ready To Submit", @"In Progress", @"Ready For Dispatch",@"Shipped", @"Closed",nil];
    
    dispatchArray = [@[@"--", @"Next Week", @"Shipped", @"Pick a date"] mutableCopy];
    
    _runTitleLabel.text = [NSString stringWithFormat:@"%d: %@ - %d Units",[run getRunId], [run getProductName], [run getQuantity]];
    _productIdLabel.text = [run getProductNumber];
    int priority = [run getPriority];
    if (priority == 0) {
        _priorityLabel.text = @"LOW";
    }
    else {
        _priorityLabel.text = @"HIGH";
    }
    _statusLabel.text = [run getStatus];
    _reqDateLabel.text = [run getRequestDate];
    _updatedDateLabel.text = [run getRunData][@"Updated"];
    _shippingDateLabel.text = [run getRunData][@"Shipping"];
    _versionLabel.text = [run getRunData][@"Version"];
    if ([run getRunData][@"Inprocess"]) {
        _inProcessLabel.text = [run getRunData][@"Inprocess"];
    }
    if ([run getRunData][@"Ready"]) {
        _readyLabel.text = [run getRunData][@"Ready"];
    }
    if ([run getRunData][@"Rework"]) {
        _reworkLabel.text = [run getRunData][@"Rework"];
    }
    if ([run getRunData][@"Reject"]) {
        _rejectLabel.text = [run getRunData][@"Reject"];
    }
    if ([run getRunData][@"Shipped"]) {
        _shippedLabel.text = [run getRunData][@"Shipped"];
    }
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[run getProductNumber]]];
    if (image) {
        [_photoButton setImage:image forState:UIControlStateNormal];
    }
    else {
        [_photoButton setImage:[UIImage imageNamed:@"placeholder.png"] forState:UIControlStateNormal];
    }
    
    runProcessStepsView = [RunProcessStepsView createView];
    runProcessStepsView.frame = CGRectMake(self.view.frame.size.width/2-runProcessStepsView.frame.size.width/2, self.view.frame.size.height/2-runProcessStepsView.frame.size.height/2, runProcessStepsView.frame.size.width, runProcessStepsView.frame.size.height);
    runProcessStepsView.hidden = true;
    [runProcessStepsView setRun:run];
    runProcessStepsView.delegate = self;
    [self.view addSubview:runProcessStepsView];
    
    operatorEntryView = [OperatorEntryView createView];
    operatorEntryView.frame = CGRectMake(0, 0, _bottomPaneView.frame.size.width, _bottomPaneView.frame.size.height);
    [operatorEntryView initView];
    operatorEntryView.delegate = self;
    [operatorEntryView setRun:run];
    [_bottomPaneView addSubview:operatorEntryView];
    [self getProductSales];

    [self getPartsShort];
    [__ServerManager getProcessList];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProcesses) name:kNotificationCommonProcessesReceived object:nil];
    
    UIImage *iconCogs = [UIImage imageWithIcon:@"fa-cogs" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    [_processFlowButton setImage:iconCogs forState:UIControlStateNormal];
    
    UIImage *iconList = [UIImage imageWithIcon:@"fa-list" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    [_ganttButton setImage:iconList forState:UIControlStateNormal];
    
    UIImage *iconBook = [UIImage imageWithIcon:@"fa-book" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    [_documentationButton setImage:iconBook forState:UIControlStateNormal];
    
    UIImage *iconHourGlass = [UIImage imageWithIcon:@"fa-hourglass-half" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    [_historyButton setImage:iconHourGlass forState:UIControlStateNormal];
    
    UIImage *iconFile = [UIImage imageWithIcon:@"fa-file" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    [_reportsButton setImage:iconFile forState:UIControlStateNormal];
    backgroundDimmingView = [self buildBackgroundDimmingView];
    [self.view addSubview:backgroundDimmingView];
    backgroundDimmingView.hidden = true;
}

- (void) initProcesses {
    commonProcessesArray = [__DataManager getCommonProcesses];
    [operatorEntryView setCommonProcessesArray:commonProcessesArray];
    [self getRunProcessFlow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)buildBackgroundDimmingView{
    UIView *bgView;
    //blur effect for iOS8
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat frameHeight = screenRect.size.height;
    CGFloat frameWidth = screenRect.size.width;
    CGFloat sideLength = frameHeight > frameWidth ? frameHeight : frameWidth;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        bgView = [[UIVisualEffectView alloc] initWithEffect:eff];
        bgView.frame = CGRectMake(0, 0, sideLength, sideLength);
    }
    else {
        bgView = [[UIView alloc] initWithFrame:self.view.frame];
        bgView.backgroundColor = [UIColor blackColor];
    }
    bgView.alpha = 0.7;
    return bgView;
}

- (void)showBackgroundDimmingView {
    backgroundDimmingView.hidden = false;
}

- (void)hideBackgroundDimmingView {
    backgroundDimmingView.hidden = true;
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}

- (IBAction)processStepsPressed:(id)sender {
    [self showBackgroundDimmingView];
    runProcessStepsView.hidden = false;
    [self.view bringSubviewToFront:runProcessStepsView];
    [runProcessStepsView initView];
}

- (IBAction)statsPressed:(id)sender {
    NSMutableDictionary *obj = [run getRunData];
    if (!([obj[@"Shipping"] isEqualToString:@""]||[obj[@"Shipping"] isEqualToString:@" "]||[obj[@"Shipping"] isEqualToString:@"--"])) {
        NSRange range = [obj[@"Shipping"] rangeOfString:@"("];
        NSString *shippingString = [obj[@"Shipping"] substringToIndex:range.location];
        if (![shippingString isEqualToString:@""]) {
            [_pickShippingButton setTitle:shippingString forState:UIControlStateNormal];
        }
        selectedShipping = shippingString;
        NSString *shippingCount= [obj[@"Shipping"] substringFromIndex:range.location];
        shippingCount = [shippingCount stringByReplacingOccurrencesOfString:@")" withString:@""];
        shippingCount = [shippingCount stringByReplacingOccurrencesOfString:@"(" withString:@""];
        _countTF.text = shippingCount;
    }
    else {
        if ([obj[@"Shipping"] isEqualToString:@"--"]) {
            [_pickShippingButton setTitle:@"--" forState:UIControlStateNormal];
            selectedShipping = @"--";
        }
    }
    selectedStatus = [run getStatus];
    [_pickStatusButton setTitle:[run getStatus] forState:UIControlStateNormal];
    _inProcessTF.text = [run getRunData][@"Inprocess"];
    _readyTF.text = [run getRunData][@"Ready"];
    _reworkTF.text = [run getRunData][@"Rework"];
    _rejectTF.text = [run getRunData][@"Reject"];
    _shippedTF.text = [run getRunData][@"Shipped"];
    
    UIImage *iconCross = [UIImage imageWithIcon:@"fa-times" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    [_closeEditButton setImage:iconCross forState:UIControlStateNormal];
    UIImage *iconTick = [UIImage imageWithIcon:@"fa-check" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    [_saveEditButton setImage:iconTick forState:UIControlStateNormal];
    _editStatsView.frame = CGRectMake(30, 70, _editStatsView.frame.size.width, _editStatsView.frame.size.height);
    [self.view addSubview:_editStatsView];
}

- (IBAction)closeEditPressed:(id)sender {
    [_editStatsView removeFromSuperview];
}

- (IBAction)saveEditPressed:(id)sender {
    [_editStatsView removeFromSuperview];
    _shippingDateLabel.text = [NSString stringWithFormat:@"%@(%@)",selectedShipping,_countTF.text];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_readyTF.text,@"Ready", _reworkTF.text, @"Rework", _inProcessTF.text, @"InProcess", _rejectTF.text, @"Reject", _shippedTF.text, @"Shipped", selectedStatus, @"Status",[NSString stringWithFormat:@"%@(%@)",selectedShipping,_countTF.text], @"Shipping", nil];
    [run updateRunData:dictionary];
    //[self updateRunData:dictionary];
    [__DataManager syncRun:[run getRunId]];
}

- (void)updateRunStats:(NSMutableDictionary*)statsData {
    _inProcessLabel.text = statsData[@"InProcess"];
    _reworkLabel.text = statsData[@"Rework"];
    _rejectLabel.text = statsData[@"Reject"];
    [run updateRunStats:statsData];
    [__DataManager syncRun:[run getRunId]];
}

- (IBAction)pickStatusPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :statusArray :nil :@"down"];
        dropDown.tag = 1;
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickShippingPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dispatchArray :nil :@"down"];
        dropDown.tag = 2;
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) selectedListIndex:(int)index {
    //selectedOperator = operatorArray[index];
    if (dropDown.tag == 1) {
        selectedStatus = statusArray[index];
    }
    else {
        if (index == 3) {
            CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
            self.calendar = calendar;
            calendar.delegate = self;
            // calendar.tag = tag;
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
            self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
            
            calendar.onlyShowCurrentMonth = NO;
            calendar.adaptHeightToNumberOfWeeksInMonth = YES;
            
            calendar.frame = CGRectMake(10, 260, 300, 320);
            [self.view addSubview:calendar];
        }
        else {
            selectedShipping = dispatchArray[index];
        }
    }
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    // dateItem.backgroundColor = [UIColor redColor];
    // dateItem.textColor = [UIColor whiteColor];
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return true;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    [_pickShippingButton setTitle:dateString forState:UIControlStateNormal];
    selectedShipping = dateString;
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor grayColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor grayColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (void)setRun:(Run*)run_ {
    run = run_;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [partsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RunPartsViewCell";
    RunPartsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    //cell.delegate = self;
    [cell setCellData:[partsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"() ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (void)setUpRunFlow {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *processData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d_%@-%@-%@",[run getRunId],[run getProductNumber],@"PC1", @"1.0"],@"run_flow_id", @"Arvind",@"updatedBy",[dateFormat stringFromDate:[NSDate date]], @"updatedTimestamp" , nil];
    [__DataManager syncRunProcesses:flowProcessesArray withProcessData:processData];
}

- (void)updateProcess:(NSMutableDictionary*)processesData {
    flowProcessesArray = [[NSMutableArray alloc] init];
    [flowProcessesArray addObject:processesData];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *processData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d_%@-%@-%@",[run getRunId],[run getProductNumber],@"PC1", @"1.0"],@"run_flow_id", @"Arvind",@"updatedBy",[dateFormat stringFromDate:[NSDate date]], @"updatedTimestamp" , nil];
    [__DataManager updateRunProcesses:flowProcessesArray withProcessData:processData];
}


- (void)getPartsShort {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/get_short_parts.php?id=%d",[run getRunId]];
    [connectionManager makeRequest:reqString withTag:1];
}

- (void)getProcessFlow {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getProcessFlow&process_ctrl_id=%@-%@-%@",[self urlEncodeUsingEncoding:[run getProductNumber]], @"PC1",@"1.0"] withTag:2];
}

- (void)getRunProcessFlow {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getRunProcessFlow&run_flow_id=%d_%@-%@-%@",[run getRunId],[run getProductNumber], @"PC1",@"1.0"] withTag:4];
}

- (void)getProductSales {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://www.aginova.info/aginova/json/product_sales.php?pid=%@",[run getProductNumber]] withTag:3];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    //[self.view bringSubviewToFront:_scrollView];
    flowProcessesArray = [[NSMutableArray alloc] init];
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<pre>" withString:@""];
    
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        if (tag == 4) {
            [self getProcessFlow];
            [self.navigationController.view hideActivityView];
        }
    }
    if (tag == 4) {
        [self.navigationController.view hideActivityView];
    }
    if ([json isKindOfClass:[NSArray class]]){
         NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            if (tag == 1) {
                partsArray = json;
                [_tableView reloadData];
                for (int i=0; i < json.count; ++i) {
                    
                }
            }
            else if (tag == 3) {
                NSMutableDictionary *jsonData = json[0];
                _thisYearCountLabel.text = jsonData[@"Current Yr Sold"];
                _lastYearCountLabel.text = jsonData[@"Previous Yr Sold"];
            }
            else if (tag == 4) {
                flowProcessesArray = [[NSMutableArray alloc] init];
                NSDictionary *jsonDict = json[0];
                NSMutableArray* jsonProcessesArray = jsonDict[@"processes"];
                if (jsonProcessesArray.count > 0) {
                    [operatorEntryView setProcessesArray:jsonProcessesArray];
                }
                else {
                    [self getProcessFlow];
                }
            }
            else {
                [self.navigationController.view hideActivityView];
                processesArray = [[NSMutableArray alloc] init];
                NSDictionary *jsonDict = json[0];
                NSMutableArray* jsonProcessesArray = jsonDict[@"processes"];
                NSLog(@"json processes array=%@",jsonProcessesArray);
               // flowProcessesArray = jsonProcessesArray;
                for (int i=0; i < jsonProcessesArray.count; ++i) {
                    NSDictionary *processDict = jsonProcessesArray[i];
                    [self getProcessWithNo:processDict[@"processno"]];
                    [self setProductProcessToFlow:processDict];
                }
               // [operatorEntryView setProcessesArray:processesArray];
                NSLog(@"flowProcessesArray=%@",flowProcessesArray);
                [self setUpRunFlow];
            }
        }
    }
}

- (void)getProcessWithNo:(NSString*)processNo {
    // NSLog(@"common processes:%@",commonProcessesArray);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-dd-MM"];
    for (int i=0; i < commonProcessesArray.count; ++i) {
        NSMutableDictionary *processData = commonProcessesArray[i];
        if ([processData[@"processno"] isEqualToString:processNo]) {
            /*NSMutableDictionary *selectedProcessData = [[NSMutableDictionary alloc] init];
             [selectedProcessData setObject:processData[@"processno"] forKey:@"processno"];
             [selectedProcessData setObject:[NSString stringWithFormat:@"%lu",selectedProcessesArray.count+1] forKey:@"stepid"];
             [selectedProcessData setObject:@"A" forKey:@"operator"];
             [selectedProcessData setObject:@"1" forKey:@"time"];
             [selectedProcessData setObject:@"1" forKey:@"points"];
             [selectedProcessData setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"timestamp"];
             [selectedProcessData setObject:@"Test" forKey:@"comments"];
             //[selectedProcessesArray addObject:selectedProcessData];*/
            [processesArray addObject:processData];
        }
    }
}

- (void)setProductProcessToFlow:(NSMutableDictionary*)processFlowData {
    // NSLog(@"common processes:%@",commonProcessesArray);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    for (int i=0; i < commonProcessesArray.count; ++i) {
        NSMutableDictionary *processData = commonProcessesArray[i];
        if ([processData[@"processno"] isEqualToString:processFlowData[@"processno"]]) {
            NSMutableDictionary *selectedProcessData = [[NSMutableDictionary alloc] init];
            [selectedProcessData setObject:processData[@"processno"] forKey:@"processno"];
            [selectedProcessData setObject:processData[@"op1"] forKey:@"operator"];
            [selectedProcessData setObject:@"" forKey:@"dateAssigned"];
            [selectedProcessData setObject:@"" forKey:@"dateCompleted"];
            [selectedProcessData setObject:@"" forKey:@"qtyEntered"];
            [selectedProcessData setObject:@"" forKey:@"qtyOkay"];
            [selectedProcessData setObject:@"" forKey:@"qtyRework"];
            [selectedProcessData setObject:@"" forKey:@"dateReject"];
            [selectedProcessData setObject:@"Open" forKey:@"status"];
            [selectedProcessData setObject:@"" forKey:@"rating"];
            [selectedProcessData setObject:@"" forKey:@"comments"];
            [selectedProcessData setObject:[NSString stringWithFormat:@"%lu",flowProcessesArray.count+1] forKey:@"stepid"];
            [flowProcessesArray addObject:selectedProcessData];
        }
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void)closeProcessStepsView {
    runProcessStepsView.hidden = true;
    [self hideBackgroundDimmingView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn called");
    [textField resignFirstResponder];
    return true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
