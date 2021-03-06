//
//  ProcessStepsViewController.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/12/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProcessStepsViewController.h"
#import "ServerManager.h"
#import "DataManager.h"
#import "Constants.h"
#import "RunProcessStepsViewCell.h"
#import "ProductListViewCell.h"
#import "UIImage+FontAwesome.h"
#import "UIImageView+WebCache.h"
#import "ConnectionManager.h"
#import "UIView+RNActivityView.h"
#import "UIAlertView+Blocks.h"
#import "UserManager.h"

@implementation ProcessStepsViewController {
    
    __weak IBOutlet UILabel *_editModeLabel;
    __weak IBOutlet UISwitch *_switchView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    productsArray = [[NSMutableArray alloc] init];
    processStepsArray = [[NSMutableArray alloc] init];
    filteredProductsArray = [[NSMutableArray alloc] init];
    indexArray = [[NSMutableArray alloc] init];
    filteredIndexArray = [[NSMutableArray alloc] init];
    alteredProcessesArray = [[NSMutableArray alloc] init];
    deletedProcessArray = [[NSMutableArray alloc] init];
    processStatus = @"Draft";
    pcbProductId = @"";
    
    productGroupsArray = [NSMutableArray arrayWithObjects:@"WAITING", @"ARGUS", @"RECEPTOR", @"GRILLVILLE", @"MISC.",nil];
    
    waitingArray = [NSMutableArray arrayWithObjects:@"Pune Pending", @"Mason Pending", @"Lausanne Pending",nil];

    control = [[DZNSegmentedControl alloc] initWithItems:productGroupsArray];
    control.tintColor = [UIColor colorWithRed:41.f/255.f green:169.f/255.f blue:244.f/255.f alpha:1.0];
    control.tag = 1;
    control.selectedSegmentIndex = 0;
    control.frame = CGRectMake(0, 0, screenRect.size.width/2, 50);
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [_leftPaneView addSubview:control];
    
    waitingControl = [[DZNSegmentedControl alloc] initWithItems:waitingArray];
    waitingControl.tintColor = [UIColor colorWithRed:41.f/255.f green:169.f/255.f blue:244.f/255.f alpha:1.0];
    waitingControl.tag = 2;
    waitingControl.frame = CGRectMake(0, 50, screenRect.size.width/2, 50);
    waitingControl.selectedSegmentIndex = 0;
    [waitingControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [_leftPaneView addSubview:waitingControl];
    
    
    if ([__DataManager getProductsArray].count > 0) {
        [self initProductList];
    }
    else {
        [__ServerManager getProductList];
    }
    
    if ([__DataManager getCommonProcesses].count > 0) {
        [self initProcesses];
    }
    else {
        [__ServerManager getProcessList];
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProductList) name:kNotificationProductsReceived object:nil];
    [center addObserver:self selector:@selector(initProcesses) name:kNotificationCommonProcessesReceived object:nil];
    [center addObserver:self selector:@selector(processUpdateSuccess) name:kNotificationProcessUpdateSuccessful object:nil];
    UIImage *iconCog = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_addStepButton setImage:iconCog forState:UIControlStateNormal];
    UIImage *iconRight = [UIImage imageWithIcon:@"fa-chevron-circle-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_submitButton setImage:iconRight forState:UIControlStateNormal];
    
    UIImage *iconPlus = [UIImage imageWithIcon:@"fa-plus-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor blueColor] fontSize:25];
    [_createStepButton setImage:iconPlus forState:UIControlStateNormal];
    [_createProductButton setImage:iconPlus forState:UIControlStateNormal];
    
    
    _submitButton.layer.cornerRadius = 8.0f;
    _submitButton.layer.borderWidth = 1.8f;
    _submitButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    _puneApprovalButton.layer.cornerRadius = 8.0f;
    _puneApprovalButton.layer.borderWidth = 1.8f;
    _puneApprovalButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _masonApprovalButton.layer.cornerRadius = 8.0f;
    _masonApprovalButton.layer.borderWidth = 1.8f;
    _masonApprovalButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _lausanneApprovalButton.layer.cornerRadius = 8.0f;
    _lausanneApprovalButton.layer.borderWidth = 1.8f;
    _lausanneApprovalButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _saveButton.layer.cornerRadius = 8.0f;
    _saveButton.layer.borderWidth = 1.5f;
    _saveButton.layer.borderColor = [UIColor grayColor].CGColor;
    [_saveButton setImage:iconRight forState:UIControlStateNormal];
    
    /*_closeButton.layer.cornerRadius = 8.0f;
    _closeButton.layer.borderWidth = 1.8f;
    _closeButton.layer.borderColor = [UIColor grayColor].CGColor;*/
    
    backgroundDimmingView = [self buildBackgroundDimmingView];
    [self.view addSubview:backgroundDimmingView];
    backgroundDimmingView.hidden = true;
    
    [_puneApprovalButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_masonApprovalButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_lausanneApprovalButton setTitle:@"Submit" forState:UIControlStateNormal];
    
    stationsArray = [NSMutableArray arrayWithObjects:@"S1-Store Activities",@"S2-Material Issue", @"S3-Contract Manufacturing",@"S4-Misc Activities",@"S5-Inspection & Testing", @"S6-Soldering", @"S7-Moulding", @"S8-Machanical Assembly", @"S9-Final Inspection", @"S10-Product Packaging", @"S11-Case Packaging",@"S12-Dispatch",nil];
    
    operatorArray = [NSMutableArray arrayWithObjects:@"Govind", @"Archana",@"Arvind",@"Pranali", @"Raman", @"Lalu", @"Venkatesh", @"Sadashiv", @"Sonali", @"Abhijith",nil];
    
    _editModeLabel.alpha = [[[UserManager sharedInstance] loggedUser] isAdmin];
    _switchView.alpha    = [[[UserManager sharedInstance] loggedUser] isAdmin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)buildBackgroundDimmingView {
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

- (void)selectedSegment:(DZNSegmentedControl *)control_ {
    if (control.selectedSegmentIndex == 0) {
        waitingControl.hidden = false;
        _productListTableView.frame = CGRectMake(_productListTableView.frame.origin.x, waitingControl.frame.origin.y+waitingControl.frame.size.height, _productListTableView.frame.size.width, _productListTableView.frame.size.height);
    }
    else {
        waitingControl.hidden = true;
        _productListTableView.frame = CGRectMake(_productListTableView.frame.origin.x, waitingControl.frame.origin.y, _productListTableView.frame.size.width, _productListTableView.frame.size.height);
    }
    filteredProductsArray = [self filteredProductsArrayForIndex:control.selectedSegmentIndex];
    [self resetSegmentTitles];
    [_productListTableView reloadData];
}

- (void) initProductList {
    productsArray = [__DataManager getProductsArray];
    filteredProductsArray = [self filteredProductsArrayForIndex:0];
    [self resetSegmentTitles];
    [_productListTableView reloadData];
  //  selectedProduct = filteredProductsArray[0];
    //[self loadProductProcessFlow:filteredProductsArray[0]];
    [waitingControl setSelectedSegmentIndex:2 animated:false];
    [self selectedSegment:waitingControl];
    [waitingControl setSelectedSegmentIndex:1 animated:false];
    [self selectedSegment:waitingControl];
    [waitingControl setSelectedSegmentIndex:0 animated:false];
    [self selectedSegment:waitingControl];
    [self filterPCBProducts];
}

- (void) initProcesses {
    commonProcessStepsArray = [__DataManager getCommonProcesses];
    filteredCommonProcessStepsArray = commonProcessStepsArray;
    [self setUpCommonProcessTable];
    [_commonProcessListTableView reloadData];
}

- (void) processUpdateSuccess {
    [self.navigationController.view hideActivityView];
    //[self initProductList];
    //[self initProcesses];
     [self getProcessFlowForProduct:selectedProduct];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Process changes updated successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alertView show];
    /*
    [_puneApprovalButton setTitle:@"Pending" forState:UIControlStateNormal];
    [_puneApprovalButton setBackgroundColor:[UIColor redColor]];*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_productListTableView]) {
        return [filteredProductsArray count];
    }
    else if ([tableView isEqual:_processListTableView]) {
        return [processStepsArray count];
    }
    else if ([tableView isEqual:_commonProcessListTableView]) {
        return [filteredCommonProcessStepsArray count];
    }
    return [workInstructionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_productListTableView]) {
        static NSString *simpleTableIdentifier = @"ProductListViewCell";
        ProductListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        cell.delegate = self;
        [cell setCellData:[filteredProductsArray objectAtIndex:indexPath.row] atIndex:indexPath.row forAdmin:screenIsForAdmin];
        return cell;
    }
    else if ([tableView isEqual:_processListTableView]){
        static NSString *simpleTableIdentifier = @"RunProcessStepsViewCell";
        RunProcessStepsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        cell.delegate = self;
        [cell setCellData:[processStepsArray objectAtIndex:indexPath.row] index:indexPath.row];
        return cell;
    }
    else if ([tableView isEqual:_commonProcessListTableView]){
        static NSString *simpleTableIdentifier = @"CommonProcessesViewCell";
        CommonProcessesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        cell.delegate = self;
        [cell setCellData:[filteredCommonProcessStepsArray objectAtIndex:indexPath.row] index:indexPath.row isAdded:[filteredIndexArray[indexPath.row] boolValue]];
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
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.numberOfLines = 2;
        // cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
        
        return cell;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_processListTableView]) {
        return true;
    }
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return true;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
   // [_processListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    if (sourceIndexPath.row != destinationIndexPath.row) {
        
        [UIAlertView showWithTitle:nil message:@"Are you sure you want to change the order of these Steps?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [self changeOrderFrom:(int)sourceIndexPath.row to:(int)destinationIndexPath.row];
            } else {
                [_processListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [dropDown hideDropDown:_pcbProductIdButton];
    dropDown = nil;

    if ([tableView isEqual:_productListTableView]) {
        _productDetailView.hidden = false;
        _changeOrderButton.hidden = true;
        [_changeOrderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_processListTableView setEditing:false];
        [_pcbProductIdButton setTitle:@"Select PCB" forState:UIControlStateNormal];
        [self setUpForButton:_puneApprovalButton withStatus:@"Submit"];
        [self setUpForButton:_masonApprovalButton withStatus:@"Submit"];
        [self setUpForButton:_lausanneApprovalButton withStatus:@"Submit"];
        selectedProduct = filteredProductsArray[indexPath.row];
        if([selectedProduct.processCntrlAlias isEqualToString:@""]) {
            [_processCntrlIdButton setTitle:selectedProduct.processCntrlId forState:UIControlStateNormal];
        }
        else {
            [_processCntrlIdButton setTitle:selectedProduct.processCntrlAlias forState:UIControlStateNormal];
        }
        [self loadProductProcessFlow:filteredProductsArray[indexPath.row]];
    }
    if ([tableView isEqual:_commonProcessListTableView]) {
        selectedProcessData = commonProcessStepsArray[indexPath.row];
        [self setUpWorkInstructionsForString:selectedProcessData[@"workinstructions"]];
        [self showProcessInfoViewWithData:selectedProcessData];
    }
    else if ([tableView isEqual:_processListTableView]){
        NSMutableDictionary *processData = processStepsArray[indexPath.row];
        selectedProcessData = [__DataManager getProcessForNo:processData[@"processno"]];
        [self setUpWorkInstructionsForString:selectedProcessData[@"workinstructions"]];
        [self showProcessInfoViewWithData:selectedProcessData];
    }
}

- (IBAction)changeOrderPressed:(UIButton*)sender {
    if (_processListTableView.isEditing) {
        [_processListTableView setEditing:false];
        [_changeOrderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else {
        [_processListTableView setEditing:true];
        [_changeOrderButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    [_processListTableView reloadData];
}

- (void) changeOrderFrom:(int)from to:(int)to {
    
    NSMutableDictionary *r = processStepsArray[from];
    if (from < to) {
        [processStepsArray insertObject:r atIndex:to+1];
        [processStepsArray removeObjectAtIndex:from];
    } else {
        [processStepsArray insertObject:r atIndex:to];
        [processStepsArray removeObjectAtIndex:from+1];
    }
    [self updateStepIds];
    //[_processListTableView reloadData];
}

- (void)updateStepIds {
    for (int i=0; i < processStepsArray.count; ++i) {
         NSMutableDictionary *processStepData = [processStepsArray[i] mutableCopy];
        [processStepData setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"stepid"];
        NSLog(@"replaced stepid = %@",processStepData[@"stepid"]);
        [processStepsArray replaceObjectAtIndex:i withObject:processStepData];
    }
    processStepsArray = [__DataManager reorderProcessSteps:processStepsArray];
    [_processListTableView reloadData];
}

- (IBAction) adminSwitchTapped {
    if (screenIsForAdmin) {
        screenIsForAdmin = false;
    }
    else {
        screenIsForAdmin = true;
    }
    filteredProductsArray = [self filteredProductsArrayForIndex:control.selectedSegmentIndex];
    [self resetSegmentTitles];
    [_productListTableView reloadData];
}

- (void)loadProductProcessFlow:(ProductModel*)product {
    if ([selectedProduct.productStatus isEqualToString:@"InActive"]) {
        _addStepButton.hidden = true;
    }
    else {
        if ([selectedProduct.status isEqualToString:@"Pune Approved"]||[selectedProduct.status isEqualToString:@"Mason Approved"]) {
            _addStepButton.hidden = true;
        }
        else
            _addStepButton.hidden = false;
    }
    _productNameLabel.text = product.name;
    _productIdLabel.text = product.productNumber;
    
    if (![product.pcbProductID isEqualToString:@"--"]&&![product.pcbProductID isEqualToString:@""]) {
        [_pcbProductIdButton setTitle:product.pcbProductID forState:UIControlStateNormal];
    }
    
    if ([product photoURL] == nil)
        [_productImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    else
    {
        //[_spinner startAnimating];
        [_productImageView sd_setImageWithURL:[product photoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //[_spinner stopAnimating];
        }];
    }
    
    if ([product getProcessSteps].count > 0) {
        _changeOrderButton.hidden = false;
        processStepsArray = [product getProcessSteps];
        [_processListTableView reloadData];
        [self setUpCommonProcessTable];
        if (![product.pcbProductID isEqualToString:@""]) {
            pcbProductId = product.pcbProductID;
        }
        [self setupForStatus:product.status];
        NSLog(@"product status = %@",product.status);
    }
    else {
        [self getProcessFlowForProduct:product];
    }
}

- (void)getProcessFlowForProduct:(ProductModel*)product {
    
    [self.navigationController.view showActivityViewWithLabel:@"Fetching process flow"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    processStepsArray = [[NSMutableArray alloc] init];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getProcessFlow&process_ctrl_id=%@-%@-%@",[self urlEncodeUsingEncoding:product.productNumber], @"PC1",@"1.0"] withTag:3];
}

- (void)deleteProcessFromListAtIndex:(int)index {
    [self.navigationController.view showActivityViewWithLabel:@"Removing Process"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    NSMutableDictionary *processData = deletedProcessArray[index];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=delFlowProcess&processno=%@&process_ctrl_id=%@",processData[@"processno"],processCntrlId] withTag:4];
}

- (void)deleteCommonProcessFromListAtIndex:(int)index {
    //[self.navigationController.view showActivityViewWithLabel:@"Deleting process"];
    //[self.navigationController.view hideActivityViewWithAfterDelay:60];
    NSMutableDictionary *processData = commonProcessStepsArray[index];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=delProcess&processno=%@",processData[@"processno"]] withTag:4];
    [commonProcessStepsArray removeObjectAtIndex:index];
    [_commonProcessListTableView reloadData];
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"() ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (void)addProcessToList:(NSMutableDictionary*)processData {
    [self.navigationController.view showActivityViewWithLabel:@"Adding new process"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=addProcess&processno=%@&processname=%@&desc=%@&wi=%@&stationid=%@&op1=%@&op2=%@&op3=%@&time=%@",processData[@"processno"], [self urlEncodeUsingEncoding:processData[@"processname"]],@"",[self urlEncodeUsingEncoding:processData[@"workinstructions"]], processData[@"stationid"], processData[@"op1"], processData[@"op2"], processData[@"op3"], processData[@"time"]] withTag:2];
    
}

- (void)updateGroup {
    //[self.navigationController.view showActivityViewWithLabel:@"Adding new process"];
    //[self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php\?call=update_product_group&productid=%@&group=%@",[self urlEncodeUsingEncoding:updatingProduct.productID],[updatingProduct.group uppercaseString]] withTag:5];
}

- (void)getMCNFile{
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://www.aginova.info/aginova/json/get_file.php?productid=%@",[self urlEncodeUsingEncoding:selectedProduct.productNumber]] withTag:6];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag {
    NSLog(@"jsonData = %@", jsonData);
    [self.navigationController.view hideActivityView];
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    if ([dataString isEqualToString:@"No MCN File Found!"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No MCN file found" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alertView.tag = 4;
        [alertView show];
    }
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        //return;
    }
    
    if (tag == 2) {
        [__ServerManager getProcessList];
        return;
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            if (tag == 6) {
                NSLog(@"MCN file = %@",json[2][@"specification file"]);
                NSURL *url = [NSURL URLWithString:[self urlEncodeUsingEncoding:json[2][@"specification file"]]];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            else {
                NSDictionary *jsonDict = json[0];
                NSMutableArray* jsonProcessesArray = jsonDict[@"processes"];
                NSLog(@"json processes array=%@",jsonProcessesArray);
                if (!jsonProcessesArray) {
                    [self.navigationController.view hideActivityView];
                }
                else {
                    _changeOrderButton.hidden = false;
                    processStepsArray=[jsonProcessesArray mutableCopy];
                }
                processCntrlId = jsonDict[@"process_ctrl_id"];
                processStatus = jsonDict[@"status"];
                pcbProductId = jsonDict[@"pcb_productid"];
                if (![pcbProductId isEqualToString:@""]) {
                    [_pcbProductIdButton setTitle:pcbProductId forState:UIControlStateNormal];
                }
                [self setupForStatus:jsonDict[@"status"]];
                NSLog(@"processes Array=%@",processStepsArray);
                processStepsArray = [__DataManager reorderProcessSteps:processStepsArray];
                processStepsArray = [self removeNullProcess:processStepsArray];
                [selectedProduct setProcessSteps:processStepsArray];
                selectedProduct.status = processStatus;
                selectedProduct.pcbProductID = pcbProductId;
                [_processListTableView reloadData];
            }
        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
    [_processListTableView reloadData];
    [self setUpCommonProcessTable];
}

- (NSMutableArray*)removeNullProcess:(NSMutableArray*)array  {
    NSMutableArray *alteredArray = [[NSMutableArray alloc] init];
    for (int i=0; i < array.count; ++i) {
        NSMutableDictionary *arrayData = array[i];
        if (![arrayData[@"processno"] isEqualToString:@""]) {
            [alteredArray addObject:arrayData];
        }
    }
    return alteredArray;
}

- (void)setupForStatus:(NSString*)status {
   // _processNoLabel.text = [NSString stringWithFormat:@"%@ (DRAFT)", processCntrlId];
    UIImage *iconApproved = [UIImage imageWithIcon:@"fa-check" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    UIImage *iconPending = [UIImage imageWithIcon:@"fa-exclamation-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    UIImage *iconSubmit = [UIImage imageWithIcon:@"fa-paper-plane" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:15];
    if ([status isEqualToString:@"OPEN"]||[status isEqualToString:@"Draft"]||[status isEqualToString:@"Open"]||[status isEqualToString:@"archive"]) {
        _addStepButton.hidden = false;
       // _processNoLabel.text = [NSString stringWithFormat:@"%@ (DRAFT)", processCntrlId];
        [self setUpForButton:_puneApprovalButton withStatus:@"Pending"];
        [self setUpForButton:_masonApprovalButton withStatus:@"Submit"];
        [self setUpForButton:_lausanneApprovalButton withStatus:@"Submit"];
    }
    else if([status isEqualToString:@"Pune Approved"]) {
        _addStepButton.hidden = true;
        [self setUpForButton:_puneApprovalButton withStatus:@"Approved"];
        [self setUpForButton:_masonApprovalButton withStatus:@"Pending"];
        [self setUpForButton:_lausanneApprovalButton withStatus:@"Submit"];
    }
    else if([status isEqualToString:@"Mason Approved"]) {
        _addStepButton.hidden = true;
        [self setUpForButton:_puneApprovalButton withStatus:@"Approved"];
        [self setUpForButton:_masonApprovalButton withStatus:@"Approved"];
        [self setUpForButton:_lausanneApprovalButton withStatus:@"Pending"];
    }
    else if([status isEqualToString:@"Lausanne Approved"]) {
        _addStepButton.hidden = true;
       // _processNoLabel.text = [NSString stringWithFormat:@"%@", processCntrlId];
        _processNoTF.textColor = [UIColor colorWithRed:73.f/255.f green:173.f/255.f blue:73.f/255.f alpha:1.f];
        [self setUpForButton:_puneApprovalButton withStatus:@"Approved"];
        [self setUpForButton:_masonApprovalButton withStatus:@"Approved"];
        [self setUpForButton:_lausanneApprovalButton withStatus:@"Approved"];
    }
    else if([status isEqualToString:@"Mason Rejected"]) {
        _addStepButton.hidden = false;
        [self setUpForButton:_puneApprovalButton withStatus:@"Pending"];
        [self setUpForButton:_masonApprovalButton withStatus:@"Rejected"];
        [self setUpForButton:_lausanneApprovalButton withStatus:@"Submit"];
    }
    else if([status isEqualToString:@"Lausanne Rejected"]) {
        _addStepButton.hidden = false;
        [self setUpForButton:_puneApprovalButton withStatus:@"Pending"];
        [self setUpForButton:_masonApprovalButton withStatus:@"Approved"];
        [self setUpForButton:_lausanneApprovalButton withStatus:@"Rejected"];
    }
}

- (void)setUpForButton:(UIButton*)button withStatus:(NSString*)status {
    UIImage *iconApproved = [UIImage imageWithIcon:@"fa-check" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    UIImage *iconPending = [UIImage imageWithIcon:@"fa-exclamation-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:15];
    UIImage *iconSubmit = [UIImage imageWithIcon:@"fa-paper-plane" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:15];
    
    if ([status isEqualToString:@"Approved"]) {
        [button setTitle:@"Approved" forState:UIControlStateNormal];
        [button setImage:iconApproved forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:73.f/255.f green:173.f/255.f blue:73.f/255.f alpha:1.f];
        button.tintColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        [button setUserInteractionEnabled:false];
    }
    else if ([status isEqualToString:@"Pending"]) {
        [button setTitle:@"Pending" forState:UIControlStateNormal];
        [button setImage:iconPending forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        button.tintColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        [button setUserInteractionEnabled:true];
    }
    else if ([status isEqualToString:@"Rejected"]) {
        [button setTitle:@"Rejected" forState:UIControlStateNormal];
        [button setImage:iconPending forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        button.tintColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        [button setUserInteractionEnabled:true];
    }
    else if ([status isEqualToString:@"Save"]) {
        [button setTitle:@"Submit" forState:UIControlStateNormal];
        [button setImage:iconPending forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:1.f/255.f green:172.f/255.f blue:235.f/255.f alpha:1.f];
        button.tintColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        [button setUserInteractionEnabled:true];
    }
    else {
        [button setTitle:@"Submit" forState:UIControlStateNormal];
        [button setImage:iconSubmit forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.tintColor = [UIColor lightGrayColor];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button setUserInteractionEnabled:false];
    }
}

- (IBAction)puneApprovalPressed:(id)sender {
    if ([_puneApprovalButton.titleLabel.text isEqualToString:@"Submit"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Are you sure you want to submit the changes" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
        alertView.tag = 4;
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Are you sure you want to approve the process for Pune" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
        alertView.tag = 1;
        [alertView show];
    }
}

- (IBAction)masonApprovalPressed:(id)sender {
    if ([selectedProduct.status isEqualToString:@"Mason Rejected"]) {
        [self showRemarkView];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Are you sure you want to approve the process for Mason" delegate:self cancelButtonTitle:@"Approve" otherButtonTitles:@"Reject",@"Cancel", nil];
        alertView.tag = 2;
        [alertView show];
    }
}

- (IBAction)lausanneApprovalPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Are you sure you want to approve the process for Lausanne" delegate:self cancelButtonTitle:@"Approve" otherButtonTitles:@"Reject",@"Cancel", nil];
    alertView.tag = 3;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        switch (alertView.tag) {
            case 0: {
                [self deleteCommonProcessFromListAtIndex:selectedIndex];
                [_addProcessView removeFromSuperview];
                backgroundDimmingView.hidden = true;
            }
                break;
            case 1: {
                [self setUpForButton:_puneApprovalButton withStatus:@"Approved"];
                [self setUpForButton:_masonApprovalButton withStatus:@"Pending"];
                [self setUpForButton:_lausanneApprovalButton withStatus:@"Submit"];
                processStatus = @"Pune Approved";
                [self submitForApprovalPressed:nil];
            }
                break;
            case 2: {
                [self setUpForButton:_puneApprovalButton withStatus:@"Approved"];
                [self setUpForButton:_masonApprovalButton withStatus:@"Approved"];
                [self setUpForButton:_lausanneApprovalButton withStatus:@"Pending"];
                processStatus = @"Mason Approved";
                [self submitForApprovalPressed:nil];
            }
                break;
            case 3: {
                [self setUpForButton:_puneApprovalButton withStatus:@"Approved"];
                [self setUpForButton:_masonApprovalButton withStatus:@"Approved"];
                [self setUpForButton:_lausanneApprovalButton withStatus:@"Approved"];
                processStatus = @"Lausanne Approved";
                [self submitForApprovalPressed:nil];
            }
                break;
            case 4: {
                [self submitForApprovalPressed:nil];
            }
                break;
            default:
                break;
        }
    }
    else if (buttonIndex == 1){
        switch (alertView.tag) {
            case 2: {
                [self showRemarkView];
            }
                break;
            case 3: {
                [self setUpForButton:_puneApprovalButton withStatus:@"Pending"];
                [self setUpForButton:_masonApprovalButton withStatus:@"Approved"];
                [self setUpForButton:_lausanneApprovalButton withStatus:@"Rejected"];
                processStatus = @"Lausanne Rejected";
                [self submitForApprovalPressed:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (void)showRemarkView {
    _remarkView.frame = CGRectMake(0, 0, _remarkView.frame.size.width, _remarkView.frame.size.height);
    //[self.view addSubview:_remarkView];
    UIViewController *vc = [UIViewController new];
    [vc setPreferredContentSize:CGSizeMake(_remarkView.frame.size.width, _remarkView.frame.size.height)];
    [vc.view addSubview:_remarkView];
    [vc.view setClipsToBounds:false];
    _remarkPopover = [[UIPopoverController alloc] initWithContentViewController:vc];
    [_remarkPopover presentPopoverFromRect:_masonApprovalButton.frame inView:_rightPaneView permittedArrowDirections:UIPopoverArrowDirectionDown animated:true];
}

- (IBAction)submitRemarkPressed:(id)sender {
    [self setUpForButton:_puneApprovalButton withStatus:@"Pending"];
    [self setUpForButton:_masonApprovalButton withStatus:@"Rejected"];
    [self setUpForButton:_lausanneApprovalButton withStatus:@"Submit"];
    processStatus = @"Mason Rejected";
    [self submitForApprovalPressed:nil];
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (NSMutableArray*) filteredProductsArrayForIndex:(int)index
{
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];

    if (index == 0) {
        for (int i=0; i < productsArray.count; ++i) {
            ProductModel *product = productsArray[i];
            if ([product.status isEqualToString:@"OPEN"]||[product.status isEqualToString:@"Draft"]||[product.status isEqualToString:@"Open"]||[product.status isEqualToString:@"Pune Approved"]||[product.status isEqualToString:@"Mason Approved"]||[product.status isEqualToString:@"Mason Rejected"]||[product.status isEqualToString:@"Lausanne Rejected"]) {
                if (!screenIsForAdmin&&([product.productStatus isEqualToString:@"InActive"])) {
                    //[filteredArray addObject:product];
                }
                else {
                    [filteredArray addObject:product];
                }
            }
        }
        filteredArray = [self filteredWaitingArray:filteredArray];
        return filteredArray;
    }
    for (int i=0; i < productsArray.count; ++i) {
        
        ProductModel *p = productsArray[i];
        if (!p.isVisible && !screenIsForAdmin) {
            continue;
        }
        if ([[p.name lowercaseString] containsString:@"sentinel"]|| [[p.group lowercaseString] isEqualToString:@"argus"])
        {
            if (index == 1)
                [filteredArray addObject:p];
        }
        else if ([[p.name lowercaseString] containsString:@"receptor"] || [[p.name lowercaseString] containsString:@"inspector"]|| [[p.group lowercaseString] isEqualToString:@"receptor"])
        {
            if (index == 2)
                [filteredArray addObject:p];
        }
        else if ([[p.name lowercaseString] containsString:@"grillville"] || [[p.group lowercaseString] isEqualToString:@"grillville"])
        {
            if (index == 3)
                [filteredArray addObject:p];
        }
        else if (index == 4)
            [filteredArray addObject:p];
    }
    return filteredArray;
}

- (NSMutableArray*)filteredWaitingArray:(NSMutableArray*)waitingProductsArray {
    [control setTitle:[NSString stringWithFormat:@"%@ (%lu)",productGroupsArray[0],(unsigned long)waitingProductsArray.count] forSegmentAtIndex:0];
    NSMutableArray *filteredWaitingArray = [[NSMutableArray alloc] init];
    for (int i =0; i < waitingProductsArray.count; ++i) {
        ProductModel *product = waitingProductsArray[i];
        switch (waitingControl.selectedSegmentIndex) {
            case 0: {
                if ([product.status isEqualToString:@"OPEN"]||[product.status isEqualToString:@"Draft"]||[product.status isEqualToString:@"Open"]||[product.status isEqualToString:@"Mason Rejected"]||[product.status isEqualToString:@"Lausanne Rejected"]){
                    [filteredWaitingArray addObject:product];
                }
            }
                break;
            case 1: {
                if ([product.status isEqualToString:@"Pune Approved"]) {
                    [filteredWaitingArray addObject:product];
                }
            }
                break;
            case 2: {
                if ([product.status isEqualToString:@"Mason Approved"]) {
                    [filteredWaitingArray addObject:product];
                }
            }
                break;
            default:
                break;
        }
    }
    [waitingControl setCount:[NSNumber numberWithInteger:filteredWaitingArray.count] forSegmentAtIndex:waitingControl.selectedSegmentIndex];
    return filteredWaitingArray;
}

- (void)resetSegmentTitles {
    for (int i=1; i < 5; ++i) {
        if (control.selectedSegmentIndex == i) {
            if (screenIsForAdmin) {
                int c = 0;
                for (ProductModel *p in filteredProductsArray)
                {
                    if ([p isVisible])
                        c = c + 1;
                }
                [control setTitle:[NSString stringWithFormat:@"%@ (%d/%lu)",productGroupsArray[i],c,(unsigned long)filteredProductsArray.count] forSegmentAtIndex:i];
            }
            else {
                [control setTitle:[NSString stringWithFormat:@"%@ (%lu)",productGroupsArray[i],(unsigned long)filteredProductsArray.count] forSegmentAtIndex:i];
            }
        }
        else {
            [control setTitle:productGroupsArray[i] forSegmentAtIndex:i];
        }
        [control setShowsCount:false];
    }
    [control reloadInputViews];
}

- (void)setUpCommonProcessTable {
    indexArray = [[NSMutableArray alloc] init];
    alteredIndexArray = [[NSMutableArray alloc] init];
    for (int i=0; i < commonProcessStepsArray.count; ++i) {
        NSMutableDictionary *processData = commonProcessStepsArray[i];
        if ([self isProcessNoAdded:processData[@"processno"]]) {
            [indexArray addObject:@"1"];
        }
        else {
            [indexArray addObject:@"0"];
        }
    }
    alteredIndexArray = indexArray;
    filteredIndexArray = indexArray;
    [_commonProcessListTableView reloadData];
}

- (BOOL)isProcessNoAdded:(NSString*)processNo {
    for (int i = 0; i < processStepsArray.count; ++i) {
        NSMutableDictionary *processData = processStepsArray[i];
        if ([processData[@"processno"] isEqualToString:processNo]) {
            return true;
        }
    }
    return false;
}

- (IBAction)showEditProcessView:(id)sender {
    [self setUpCommonProcessTable];
    alteredProcessesArray = processStepsArray;
    _editProcessFlowView.frame = CGRectMake(_rightPaneView.frame.origin.x, _rightPaneView.frame.origin.y, _rightPaneView.frame.size.width, _rightPaneView.frame.size.height);
    [self.view addSubview:_editProcessFlowView];
}

- (IBAction)saveEditPressed:(id)sender {
    if (alteredIndexArray.count > 0) {
        if ([processStatus isEqualToString:@"Draft"]) {
            [_puneApprovalButton setUserInteractionEnabled:true];
        }
    }
    [_editProcessFlowView removeFromSuperview];
    indexArray = alteredIndexArray;
    filteredIndexArray = indexArray;
    processStepsArray = [__DataManager reorderProcesses:alteredProcessesArray];
    [_processListTableView reloadData];
}

- (IBAction)closeEditPressed:(id)sender {
    [_editProcessFlowView removeFromSuperview];
}

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)addButtonPressedAtIndex:(int)index withValue:(BOOL)isAdded{
    if (isAdded) {
        [alteredIndexArray replaceObjectAtIndex:index withObject:@"1"];
        NSMutableDictionary *processData = commonProcessStepsArray[index];
        [self addProcessWithNo:processData[@"processno"]];
    }
    else {
        [alteredIndexArray replaceObjectAtIndex:index withObject:@"0"];
        NSMutableDictionary *processData = commonProcessStepsArray[index];
        [self removeProcessWithNo:processData[@"processno"]];
    }
    if (alteredIndexArray.count > 0) {
        if ([processStatus isEqualToString:@"Draft"]) {
            [_puneApprovalButton setUserInteractionEnabled:true];
        }
    }
    //[_editProcessFlowView removeFromSuperview];
    indexArray = alteredIndexArray;
    filteredIndexArray = indexArray;
    processStepsArray = [__DataManager reorderProcessSteps:alteredProcessesArray];
    [_processListTableView reloadData];
   // if ([[selectedProduct.status uppercaseString] isEqualToString:@"OPEN"]) {
        [self setUpForButton:_puneApprovalButton withStatus:@"Save"];
    //}
}

- (void)removeProcessWithNo:(NSString*)processNo {
    for (int i=0; i < alteredProcessesArray.count; ++i) {
        NSMutableDictionary *processData = processStepsArray[i];
        if ([processData[@"processno"] isEqualToString:processNo]) {
            [deletedProcessArray addObject:alteredProcessesArray[i]];
            [alteredProcessesArray removeObjectAtIndex:i];
            break;
        }
    }
}

- (void)addProcessWithNo:(NSString*)processNo {
    for (int i=0; i < commonProcessStepsArray.count; ++i) {
        NSMutableDictionary *processDict = commonProcessStepsArray[i];
        if ([processDict[@"processno"] isEqualToString:processNo]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSMutableDictionary *selectedProcess = [[NSMutableDictionary alloc] init];
            [selectedProcess setObject:processDict[@"processno"] forKey:@"processno"];
            [selectedProcess setObject:[NSString stringWithFormat:@"%lu",processStepsArray.count+1] forKey:@"stepid"];
            [selectedProcess setObject:processDict[@"op1"] forKey:@"operator1"];
            [selectedProcess setObject:processDict[@"op2"] forKey:@"operator2"];
            [selectedProcess setObject:processDict[@"op3"] forKey:@"operator3"];
            [selectedProcess setObject:processDict[@"time"] forKey:@"time"];
            [selectedProcess setObject:@"archive" forKey:@"processstatus"];
            [selectedProcess setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"timestamp"];
            [selectedProcess setObject:@"" forKey:@"comments"];
           // [selectedProcess setObject:@"" forKey:@"points"];
            //[selectedProcess setObject:@"" forKey:@"rating"];
            [alteredProcessesArray addObject:selectedProcess];
            break;
        }
    }
}

- (IBAction)submitForApprovalPressed:(id)sender {
    [self updateStepIds];
    
    [self.navigationController.view showActivityViewWithLabel:@"Saving process changes"];
    [self.navigationController.view hideActivityViewWithAfterDelay:3];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *processData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@-%@",selectedProduct.productNumber,@"PC1",@"1.0"],@"process_ctrl_id",[NSString stringWithFormat:@"%@_%@_%@",selectedProduct.name, @"PC1", @"1.0"], @"process_ctrl_name",selectedProduct.processCntrlAlias,@"alias",selectedProduct.productID,@"ProductId", pcbProductId, @"PCBProductId",@"1.0", @"VersionId", @"Draft", @"Status", @"Arvind", @"Originator", @"", @"Approver", _remarkTV.text,@"Comments", @"", @"Description",[dateFormat stringFromDate:[NSDate date]], @"Timestamp" , nil];
    if (![selectedProduct.processCntrlId isEqualToString:@"DRAFT"]) {
        [__DataManager updateProcesses:processStepsArray withProcessData:processData];
    }
    else {
        [__DataManager syncProcesses:processStepsArray withProcessData:processData];
    }
    _remarkTV.text = @"";
    
    //delete removed processes
    for (int i=0; i < deletedProcessArray.count; ++i) {
        [self deleteProcessFromListAtIndex:i];
    }
}

- (void)stateButtonPressedAtIndex:(int)index {
    ProductModel *product = filteredProductsArray[index];
    ProductListViewCell *cell = [_productListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    ProductAdminPopover *screen = [[ProductAdminPopover alloc] initWithNibName:@"ProductAdminPopover" bundle:nil];
    screen.product = product;
    screen.delegate = self;
    screen.sourceRect = cell.frame;
    _adminPopover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [_adminPopover presentPopoverFromRect:cell.frame inView:cell.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
}

- (void)updateGroupPressedAtIndex:(int)index {
    ProductListViewCell *cell = [_productListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    ProductModel *product = filteredProductsArray[index];
    updatingProduct = product;
    _nameLabel.text = product.name;
    [_groupButton setTitle:product.group forState:UIControlStateNormal];
    _updateGroupView.frame = CGRectMake(0, 0, _updateGroupView.frame.size.width, _updateGroupView.frame.size.height);
    UIViewController *vc = [UIViewController new];
    [vc setPreferredContentSize:CGSizeMake(_updateGroupView.frame.size.width, _updateGroupView.frame.size.height)];
    [vc.view addSubview:_updateGroupView];
    [vc.view setClipsToBounds:false];
    _groupPopover = [[UIPopoverController alloc] initWithContentViewController:vc];
    [_groupPopover presentPopoverFromRect:cell.frame inView:cell.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
}

- (IBAction)updateGroupPressed:(id)sender {
    updatingProduct.group = [_groupButton.titleLabel.text uppercaseString];
    [_updateGroupView removeFromSuperview];
    [_groupPopover dismissPopoverAnimated:true];
    [self updateGroup];
}

- (IBAction)cancelUpdateGroupPressed:(id)sender {
    [_updateGroupView removeFromSuperview];
    [_groupPopover dismissPopoverAnimated:true];
}


#pragma mark - ProductAdminPopoverDelegate

- (void) statusChangedForProducts {
    [_productListTableView reloadData];
    [self resetSegmentTitles];
   // [self layoutCountLabel];
}


- (void) presentPhotoPicker:(UIImagePickerController *)p {
    [self presentViewController:p animated:true completion:nil];
}

- (void) dismissPhotoPicker {
    [self dismissViewControllerAnimated:true completion:nil];
}

// process detail popup view

- (void)showProcessInfoViewWithData:(NSMutableDictionary*)processData {
    backgroundDimmingView.hidden = false;
    [self.view bringSubviewToFront:backgroundDimmingView];
    _processInfoView.frame = CGRectMake(self.view.frame.size.width/2-_processInfoView.frame.size.width/2, self.view.frame.size.height/2-_processInfoView.frame.size.height/2, _processInfoView.frame.size.width, _processInfoView.frame.size.height);
    _processInfoView.layer.cornerRadius = 12.0f;
    _processNameLabel.text = [NSString stringWithFormat:@"%@: %@",processData[@"stationid"],processData[@"processname"]];
    _timeLabel.text = processData[@"time"];
    _operator1Label.text = processData[@"op1"];
    _operator2Label.text = processData[@"op2"];
    _operator3Label.text = processData[@"op3"];
    [self.view addSubview:_processInfoView];
}

- (void)setUpWorkInstructionsForString:(NSString*)wiString {
    workInstructionsArray = [[NSMutableArray alloc] init];
    workInstructionsArray = [[wiString componentsSeparatedByString:@"\n"] mutableCopy];
    [_wiTableView reloadData];
}

- (IBAction)closeProcessInfoView {
    backgroundDimmingView.hidden = true;
    [_processInfoView removeFromSuperview];
}

// add process functions

- (IBAction)createProcessPressed:(id)sender {
    [self showAddProcessView];
}

- (void)showAddProcessView {
    NSMutableDictionary *lastProcess = commonProcessStepsArray[commonProcessStepsArray.count-1];
    int processNo = [[lastProcess[@"processno"] stringByReplacingOccurrencesOfString:@"P" withString:@""] intValue]+1;
    _processNoTF.enabled = true;
    _processNoTF.userInteractionEnabled = true;
    _processNoTF.text = [NSString stringWithFormat:@"P%d",processNo];
    [_stationIdButton setTitle:@"Pick Station" forState:UIControlStateNormal];
    [_operator1Button setTitle:@"Pick Operator1" forState:UIControlStateNormal];
    [_operator2Button setTitle:@"Pick Operator2" forState:UIControlStateNormal];
    [_operator3Button setTitle:@"Pick Operator3" forState:UIControlStateNormal];
    _processNameTF.text = @"";
    _timeTF.text = @"";
    _workInstructionsTV.text = @"";
    backgroundDimmingView.hidden = false;
    [self.view bringSubviewToFront:backgroundDimmingView];
    _addProcessView.frame = CGRectMake(self.view.frame.size.width/2-_addProcessView.frame.size.width/2, self.view.frame.size.height/2-_addProcessView.frame.size.height/2, _addProcessView.frame.size.width, _addProcessView.frame.size.height);
    _addProcessView.layer.cornerRadius = 12.0f;
    [self.view addSubview:_addProcessView];
    _addProcessView.tag = 1;
    _deleteButton.hidden = true;
}

- (IBAction)saveNewProcessPressed:(id)sender {
    backgroundDimmingView.hidden = true;
    [_addProcessView removeFromSuperview];
}

- (IBAction)cancelNewProcessPressed:(id)sender {
    backgroundDimmingView.hidden = true;
    [_addProcessView removeFromSuperview];
}

- (IBAction)saveEditCommonPressed:(id)sender{
    NSMutableDictionary *processData = [[NSMutableDictionary alloc] init];
    NSLog(@"orig processData=%@",processData);
    
    [processData setObject:[NSString stringWithFormat:@"S%d",selectedStation+1] forKey:@"stationid"];
    if (![_operator1Button.titleLabel.text isEqualToString:@"Pick Operator1"]) {
        [processData setObject:_operator1Button.titleLabel.text forKey:@"op1"];
    }
    else {
        [processData setObject:@"" forKey:@"op1"];
    }
    if (![_operator2Button.titleLabel.text isEqualToString:@"Pick Operator2"]) {
        [processData setObject:_operator2Button.titleLabel.text forKey:@"op2"];
    }
    else {
        [processData setObject:@"" forKey:@"op2"];
    }
    if (![_operator3Button.titleLabel.text isEqualToString:@"Pick Operator3"]) {
        [processData setObject:_operator3Button.titleLabel.text forKey:@"op3"];
    }
    else {
        [processData setObject:@"" forKey:@"op3"];
    }

    [processData setObject:_processNameTF.text forKey:@"processname"];
    [processData setObject:_timeTF.text forKey:@"time"];
    
    if (_addProcessView.tag == 1) {
        NSMutableDictionary *lastProcess = commonProcessStepsArray[commonProcessStepsArray.count-1];
        int processNo = [[lastProcess[@"processno"] stringByReplacingOccurrencesOfString:@"P" withString:@""] intValue]+1;
        if ([_processNoTF.text isEqualToString:@""]||[_processNameTF.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please fill in all details" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [processData setObject:[_processNoTF.text uppercaseString] forKey:@"processno"];
        [processData setObject:_workInstructionsTV.text forKey:@"workinstructions"];
        [processData setObject:@"" forKey:@"status"];
        [self addProcessToList:processData];
    }
    else {
        processData = [commonProcessStepsArray[selectedIndex] mutableCopy];
        [processData setObject:[NSString stringWithFormat:@"S%d",selectedStation+1] forKey:@"stationid"];
        [processData setObject:_operator1Button.titleLabel.text forKey:@"op1"];
        [processData setObject:_operator2Button.titleLabel.text forKey:@"op2"];
        [processData setObject:_operator3Button.titleLabel.text forKey:@"op3"];
        [processData setObject:_processNameTF.text forKey:@"processname"];
        [processData setObject:_processNoTF.text forKey:@"processno"];
        [processData setObject:_timeTF.text forKey:@"time"];
        [processData setObject:_workInstructionsTV.text forKey:@"workinstructions"];
        [processData setObject:@"" forKey:@"status"];
        [commonProcessStepsArray replaceObjectAtIndex:selectedIndex withObject:processData];
        [__DataManager updateProcessAtIndex:selectedIndex process:processData];
        [__DataManager syncCommonProcesses];
    }
    
    NSLog(@"edited processData=%@",processData);
    backgroundDimmingView.hidden = true;
    [_addProcessView removeFromSuperview];
}

- (IBAction)pickStationPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :stationsArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.tag = 1;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickOperatorPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :operatorArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor whiteColor];
        dropDown.tag = 3;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickGroupPressed:(id)sender {
    NSMutableArray *groupsArray = [NSMutableArray arrayWithObjects:@"ARGUS", @"GRILLVILLE", @"RECEPTOR", @"ICELSIUS", @"ICELSIUS BLUE", @"ICELSIUS WIRELESS", @"CORROSION", @"SUPPORT",@"OTHERS", nil];
    if(dropDown == nil) {
        CGFloat f = 150;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :groupsArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor whiteColor];
        dropDown.tag = 4;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) selectedListIndex:(int)index {
    if (dropDown.tag == 1) {
        selectedStation = index;
    }
    else if(dropDown.tag == 2){
        pcbProductId = pcbProductsArray[index];
        selectedProduct.pcbProductID = pcbProductId;
        [self setUpForButton:_puneApprovalButton withStatus:@"Save"];
    }
    else if(dropDown.tag == 3){
        selectedOperatorIndex = index;
    }
    else {
        
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (void)editProcessAtIndex:(int)index {
    _deleteButton.hidden = false;
    selectedIndex = index;
    NSMutableDictionary *processData = commonProcessStepsArray[index];
    NSLog(@"selected processData=%@",processData);
    _processNoTF.enabled = false;
    _processNoTF.userInteractionEnabled = false;
    int stationIndex = [[processData[@"stationid"] substringFromIndex:1] intValue];
    [_stationIdButton setTitle:stationsArray[stationIndex-1] forState:UIControlStateNormal];
    if (![processData[@"op1"] isEqualToString:@""]) {
        [_operator1Button setTitle:processData[@"op1"] forState:UIControlStateNormal];
    }
    if (![processData[@"op2"] isEqualToString:@""]) {
        [_operator2Button setTitle:processData[@"op2"] forState:UIControlStateNormal];
    }
    if (![processData[@"op3"] isEqualToString:@""]) {
        [_operator3Button setTitle:processData[@"op3"] forState:UIControlStateNormal];
    }
    _processNoTF.text = processData[@"processno"];
    _processNameTF.text = processData[@"processname"];
    _timeTF.text = processData[@"time"];
    _workInstructionsTV.text = processData[@"workinstructions"];
    backgroundDimmingView.hidden = false;
    [self.view bringSubviewToFront:backgroundDimmingView];
    _addProcessView.frame = CGRectMake(self.view.frame.size.width/2-_addProcessView.frame.size.width/2, self.view.frame.size.height/2-_addProcessView.frame.size.height/2, _addProcessView.frame.size.width, _addProcessView.frame.size.height);
    _addProcessView.layer.cornerRadius = 12.0f;
    [self.view addSubview:_addProcessView];
    _addProcessView.tag = 2;
}

- (IBAction)deleteCommonProcess:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Delete Option is disabled for now. Please contact Arthur/Deepali for deleting processes." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    alertView.tag = 0;
    [alertView show];
    
    /*[self deleteCommonProcessFromListAtIndex:selectedIndex];
    [_addProcessView removeFromSuperview];
    backgroundDimmingView.hidden = true;*/
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn called");
    [textField resignFirstResponder];
    return true;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        filteredCommonProcessStepsArray = commonProcessStepsArray;
        filteredIndexArray = indexArray;
        [_commonProcessListTableView reloadData];
    }
    else
        [self filteredSearchList:searchText];
}

- (void)filteredSearchList:(NSString*)searchText {
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    filteredIndexArray = [[NSMutableArray alloc] init];
    for (int i=0; i < commonProcessStepsArray.count ;++i) {
        NSMutableDictionary *processData = commonProcessStepsArray[i];
        if ([[processData[@"processname"] uppercaseString] containsString:[searchText uppercaseString]]) {
            [filteredArray addObject:processData];
            [filteredIndexArray addObject:indexArray[i]];
        }
    }
    filteredCommonProcessStepsArray = filteredArray;
    [_commonProcessListTableView reloadData];
}

- (void)filterPCBProducts {
    pcbProductsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<productsArray.count; ++i) {
        ProductModel *product = productsArray[i];
        if ([product.name containsString:@"PCB"]) {
            [pcbProductsArray addObject:product.productNumber];
        }
    }
}

- (IBAction)selectPCBPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :pcbProductsArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor whiteColor];
        dropDown.tag = 2;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)processCntrlIdButtonPressed:(id)sender {
    _aliasTF.text = @"";
    _processCntrlIdLabel.text = selectedProduct.processCntrlId;
    _aliasView.frame = CGRectMake(self.view.frame.size.width/2-_aliasView.frame.size.width/2, self.view.frame.size.height/2-_aliasView.frame.size.height/2, _aliasView.frame.size.width, _aliasView.frame.size.height);
    [self.view addSubview:_aliasView];
    backgroundDimmingView.hidden = false;
}

- (IBAction)cancelAliasPressed:(id)sender {
    [_aliasView removeFromSuperview];
    backgroundDimmingView.hidden = true;
}

- (IBAction)saveAliasPressed:(id)sender {
    if (![_aliasTF.text isEqualToString:@""]) {
        [_processCntrlIdButton setTitle:_aliasTF.text forState:UIControlStateNormal];
        [_aliasView removeFromSuperview];
        backgroundDimmingView.hidden = true;
        [selectedProduct setProcessCntrlAlias:_aliasTF.text];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please enter a valid alias name." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)refreshPressed:(id)sender {
    [__ServerManager getProductList];
    [__ServerManager getProcessList];
    [self getProcessFlowForProduct:selectedProduct];
}

- (IBAction)viewMCNPressed:(id)sender {
    [self getMCNFile];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
   /* if ([touch.view isKindOfClass:[UIView class]]) {
        [dropDown hideDropDown:_pcbProductIdButton];
        dropDown = nil;
    }
    
    if ([touch.view isKindOfClass:[UITableView class]]) {
        [dropDown hideDropDown:_pcbProductIdButton];
        dropDown = nil;
    }*/
    [dropDown hideDropDown:_pcbProductIdButton];
    dropDown = nil;
    [_workInstructionsTV resignFirstResponder];
}

- (void)keyboardDidShow: (NSNotification *) notif{
    self.view.transform = CGAffineTransformMakeTranslation(0, -220);
}

- (void)keyboardDidHide: (NSNotification *) notif{
    if (self.view.frame.origin.y < 0) {
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    
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
