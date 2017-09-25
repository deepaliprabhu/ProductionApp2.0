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
    _thisYearView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _thisYearView.layer.borderWidth = 1.0f;
    _lastYearView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lastYearView.layer.borderWidth = 1.0f;
    _prevLastYearView.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
    //operatorEntryView.hidden = true;
    //tasklistView.delegate = self;
    [_bottomPaneView addSubview:operatorEntryView];
    [self getProductSales];

    [self getPartsShort];
    [__ServerManager getProcessList];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProcesses) name:kNotificationCommonProcessesReceived object:nil];
}

- (void) initProcesses {
    commonProcessesArray = [__DataManager getCommonProcesses];
    [self getProcessFlow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}

- (IBAction)processStepsPressed:(id)sender {
    _tintView.hidden = false;
    runProcessStepsView.hidden = false;
    [runProcessStepsView initView];
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


- (void)getPartsShort {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/get_short_parts.php?id=%d",[run getRunId]];
    [connectionManager makeRequest:reqString withTag:1];
}

- (void)getProcessFlow {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getProcessFlow&process_ctrl_id=%@-%@-%@",[run getProductNumber], @"PC1",@"1.0"] withTag:2];
}

- (void)getProductSales {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://www.aginova.info/aginova/json/product_sales.php?pid=%@",[run getProductNumber]] withTag:3];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    //[self.view bringSubviewToFront:_scrollView];
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<pre>" withString:@""];
    
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
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
            else {
                processesArray = [[NSMutableArray alloc] init];
                NSDictionary *jsonDict = json[0];
                NSMutableArray* jsonProcessesArray = jsonDict[@"processes"];
                NSLog(@"json processes array=%@",jsonProcessesArray);
                for (int i=0; i < jsonProcessesArray.count; ++i) {
                    NSDictionary *processDict = jsonProcessesArray[i];
                    [self getProcessWithNo:processDict[@"processno"]];
                }
                [operatorEntryView setProcessesArray:processesArray];
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

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void)closeProcessStepsView {
    runProcessStepsView.hidden = true;
    _tintView.hidden = true;
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
