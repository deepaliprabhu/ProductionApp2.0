//
//  RunProcessStepsView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 07/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunProcessStepsView.h"
#import "ServerManager.h"
#import "Constants.h"
#import "DataManager.h"
#import "UIImage+FontAwesome.h"

@implementation RunProcessStepsView

__CREATEVIEW(RunProcessStepsView, @"RunProcessStepsView", 0);


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initView {
    self.layer.cornerRadius = 8.0f;
    processStepsArray = [[NSMutableArray alloc] init];
    selectedProcessesArray = [[NSMutableArray alloc] init];
    _processFlowButton.layer.cornerRadius = 6.0f;
    _documentationButton.layer.cornerRadius = 6.0f;
    _historyButton.layer.cornerRadius = 6.0f;
    _reportsButton.layer.cornerRadius = 6.0f;
    _ganttButton.layer.cornerRadius = 6.0f;
    _submitButton.layer.cornerRadius = 8.0f;
    _submitButton.layer.borderWidth = 1.5f;
    _submitButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UIImage *iconCog = [UIImage imageWithIcon:@"fa-cog" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:20];
    [_createProcessImageView setImage:iconCog];
    UIImage *iconRight = [UIImage imageWithIcon:@"fa-chevron-circle-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_submitImageView setImage:iconRight];
    
    _runTitleLabel.text = [NSString stringWithFormat:@"%d - %@", [run getRunId], [run getProductName]];
    [__ServerManager getProcessList];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProcesses) name:kNotificationCommonProcessesReceived object:nil];
}

- (void) initProcesses {
    commonProcessesArray = [__DataManager getCommonProcesses];
    [_commonProcessesTableView reloadData];
    //[self.navigationController.view hideActivityView];
    [self getProcessFlow];
}

- (void)setUpWorkInstructionsForString:(NSString*)wiString {
    workInstructionsArray = [[NSMutableArray alloc] init];
    workInstructionsArray = [[wiString componentsSeparatedByString:@"\n"] mutableCopy];
    [_wiTableView reloadData];
}

- (void)setRun:(Run*)run_ {
    run = run_;
}

- (IBAction)addProcessFromListPressed:(id)sender {
    _commonProcessesView.hidden = false;
}

- (IBAction)createNewProcessPressed:(id)sender {
    
}

- (IBAction)closePressed:(id)sender {
    [_delegate closeProcessStepsView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_wiTableView]) {
        return 50.0f;
    }
    return 35.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_commonProcessesTableView]) {
        return [commonProcessesArray count];
    }
    else if ([tableView isEqual:_runProcessesTableView]) {
        return [processStepsArray count];
    }
    return [workInstructionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_commonProcessesTableView]) {
        static NSString *simpleTableIdentifier = @"CommonProcessesViewCell";
        CommonProcessesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        cell.delegate = self;
         [cell setCellData:[commonProcessesArray objectAtIndex:indexPath.row] index:indexPath.row isAdded:true];
        return cell;
    }
    else if ([tableView isEqual:_runProcessesTableView]){
        static NSString *simpleTableIdentifier = @"RunProcessStepsViewCell";
        RunProcessStepsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        cell.delegate = self;
        [cell setCellData:[processStepsArray objectAtIndex:indexPath.row] index:indexPath.row];
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = workInstructionsArray[indexPath.row];
        cell.textLabel.font = [cell.textLabel.font fontWithSize:11];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textColor = [UIColor grayColor];
       // cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
        
        return cell;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_commonProcessesTableView]) {
        [self setUpWorkInstructionsForString:commonProcessesArray[indexPath.row][@"workinstructions"]];
        [self showProcessInfoViewWithData:commonProcessesArray[indexPath.row]];
    }
    else if ([tableView isEqual:_runProcessesTableView]){
        [self setUpWorkInstructionsForString:processStepsArray[indexPath.row][@"workinstructions"]];
        [self showProcessInfoViewWithData:processStepsArray[indexPath.row]];
    }
    else {
        
    }
}

- (void)addButtonPressedAtIndex:(int)index {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *processDict = commonProcessesArray[index];
    [processStepsArray addObject:processDict];
    NSMutableDictionary *selectedProcessData = [[NSMutableDictionary alloc] init];
     [selectedProcessData setObject:processDict[@"processno"] forKey:@"processno"];
     [selectedProcessData setObject:[NSString stringWithFormat:@"%lu",selectedProcessesArray.count+1] forKey:@"stepid"];
     [selectedProcessData setObject:processDict[@"op1"] forKey:@"op1"];
     [selectedProcessData setObject:processDict[@"op2"] forKey:@"op2"];
     [selectedProcessData setObject:processDict[@"op3"] forKey:@"op3"];
     [selectedProcessData setObject:processDict[@"time"] forKey:@"time"];
    [selectedProcessData setObject:@"archive" forKey:@"processstatus"];
     [selectedProcessData setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"timestamp"];
     [selectedProcessData setObject:@"" forKey:@"comments"];
     [selectedProcessesArray addObject:selectedProcessData];
    [_runProcessesTableView reloadData];
}

- (void)crossButtonPressedAtIndex:(int)index {
    [processStepsArray removeObjectAtIndex:index];
    [_runProcessesTableView reloadData];
}

- (void)getProcessFlow {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getProcessFlow&process_ctrl_id=%@-%@-%@",[run getProductNumber], @"PC1",@"1.0"] withTag:3];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    if (tag == 1) {
        commonProcessesArray = [[NSMutableArray alloc] init];
    }
    if(tag == 4){
       // [self getProcessFlow];
        return;
    }
    
    NSLog(@"jsonData = %@", jsonData);
    
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        return;
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            if (tag == 1) {
                commonProcessesArray = json;
                //[self setupDropDownList];
               // [self getProcessFlow];
            }
            if (tag == 3) {
                processStepsArray = [[NSMutableArray alloc] init];
                NSDictionary *jsonDict = json[0];
                //[_pickApproverButton setTitle:jsonDict[@"approver"] forState:UIControlStateNormal];
                //[_pickOriginatorButton setTitle:jsonDict[@"originator"] forState:UIControlStateNormal];
               // _commentsTextView.text = jsonDict[@"comments"];
               // processCntrlId = jsonDict[@"process_ctrl_id"];
                [_statusButton setTitle:jsonDict[@"status"] forState:UIControlStateNormal];
                _versionLabel.text = jsonDict[@"version"];
                NSMutableArray* jsonProcessesArray = jsonDict[@"processes"];
                NSLog(@"json processes array=%@",jsonProcessesArray);
                for (int i=0; i < jsonProcessesArray.count; ++i) {
                    NSDictionary *processDict = jsonProcessesArray[i];
                    [self getProcessWithNo:processDict[@"processno"]];
                }
                NSLog(@"processes Array=%@",processStepsArray);
                [self filterProcesses];
                [_runProcessesTableView reloadData];
                [self tableView:_runProcessesTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
    // [_tableView reloadData];
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void)filterProcesses {
    NSString *runCategory = [run getRunData][@"Category"];
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (int i=0; i < processStepsArray.count; ++i) {
        NSMutableDictionary *processData = processStepsArray[i];
        NSMutableDictionary *commonProcessData = [__DataManager getProcessForNo:processData[@"processno"]];
        if(([commonProcessData[@"category"] isEqualToString:runCategory])||([commonProcessData[@"category"] isEqualToString:@"Common"])) {
            [filteredArray addObject:processData];
        }
    }
    processStepsArray = filteredArray;
    NSLog(@"filteredArray = %@",filteredArray);
}

- (void)getProcessWithNo:(NSString*)processNo {
    // NSLog(@"common processes:%@",commonProcessesArray);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
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
            [processStepsArray addObject:processData];
        }
    }
}


/*- (IBAction)submitButtonPressed:(id)sender {
    if (selectedProcessesArray.count > 0) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSMutableDictionary *processData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@-%@",[run getProductNumber],@"PC1",_versionLabel.text],@"process_ctrl_id",[NSString stringWithFormat:@"%@_%@_%@",[run getProductName], @"PC1", _versionLabel.text], @"process_ctrl_name",product[@"Product Id"],@"ProductId",_versionLabel.text, @"VersionId", @"archive", @"Status", @"Arvind", @"Originator", @"Mason", @"Approver", _commentsTextView.text,@"Comments", @"", @"Description",[dateFormat stringFromDate:[NSDate date]], @"Timestamp" , nil];
        _versionLabel.text = _versionTF.text;
        [__DataManager syncProcesses:selectedProcessesArray withProcessData:processData];
    }
}*/

- (void)showProcessInfoViewWithData:(NSMutableDictionary*)processData {
    _processInfoView.hidden = false;
    _processNameLabel.text = [NSString stringWithFormat:@"%@: %@",processData[@"stationid"],processData[@"processname"]];
    _timeLabel.text = processData[@"time"];
    _operator1Label.text = processData[@"op1"];
    _operator2Label.text = processData[@"op2"];
    _operator3Label.text = processData[@"op3"];
}

- (IBAction)closeProcessInfoView {
    _processInfoView.hidden = true;
}


@end
