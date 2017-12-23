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


@interface ProcessStepsViewController ()

@end

@implementation ProcessStepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    productsArray = [[NSMutableArray alloc] init];
    processStepsArray = [[NSMutableArray alloc] init];
    filteredProductsArray = [[NSMutableArray alloc] init];
    indexArray = [[NSMutableArray alloc] init];
    alteredProcessesArray = [[NSMutableArray alloc] init];
    deletedProcessArray = [[NSMutableArray alloc] init];
    
    productGroupsArray = [NSMutableArray arrayWithObjects:@"Sentinel", @"Inspector", @"GrillVille", @"Misc.",nil];

    control = [[DZNSegmentedControl alloc] initWithItems:productGroupsArray];
    control.tintColor = [UIColor colorWithRed:41.f/255.f green:169.f/255.f blue:244.f/255.f alpha:1.0];
    // control.delegate = self;
    control.selectedSegmentIndex = 0;
    control.frame = CGRectMake(0, 80, screenRect.size.width/2, 50);
    
    [control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [_leftPaneView addSubview:control];
    [__ServerManager getProductList];
    [__ServerManager getProcessList];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProductList) name:kNotificationProductsReceived object:nil];
    [center addObserver:self selector:@selector(initProcesses) name:kNotificationCommonProcessesReceived object:nil];
    UIImage *iconCog = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_addStepButton setImage:iconCog forState:UIControlStateNormal];
    UIImage *iconRight = [UIImage imageWithIcon:@"fa-chevron-circle-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_submitButton setImage:iconRight forState:UIControlStateNormal];
    
    UIImage *iconPlus = [UIImage imageWithIcon:@"fa-plus-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor blueColor] fontSize:25];
    [_createStepButton setImage:iconPlus forState:UIControlStateNormal];
    
    _submitButton.layer.cornerRadius = 8.0f;
    _submitButton.layer.borderWidth = 1.5f;
    _submitButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    _saveButton.layer.cornerRadius = 8.0f;
    _saveButton.layer.borderWidth = 1.5f;
    _saveButton.layer.borderColor = [UIColor grayColor].CGColor;
    [_saveButton setImage:iconRight forState:UIControlStateNormal];
    
    _closeButton.layer.cornerRadius = 8.0f;
    _closeButton.layer.borderWidth = 1.5f;
    _closeButton.layer.borderColor = [UIColor grayColor].CGColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedSegment:(DZNSegmentedControl *)control {
    filteredProductsArray = [self filteredProductsArrayForIndex:control.selectedSegmentIndex];
    [self resetSegmentTitles];
    [_productListTableView reloadData];
}

- (void) initProductList {
    productsArray = [__DataManager getProductsArray];
    filteredProductsArray = [self filteredProductsArrayForIndex:0];
    [self resetSegmentTitles];
    [_productListTableView reloadData];
    selectedProduct = filteredProductsArray[0];
    [self loadProductProcessFlow:filteredProductsArray[0]];
}

- (void) initProcesses {
    commonProcessStepsArray = [__DataManager getCommonProcesses];
    [_commonProcessListTableView reloadData];
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
    return [commonProcessStepsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_productListTableView]) {
        static NSString *simpleTableIdentifier = @"ProductListViewCell";
        ProductListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
       // cell.delegate = self;
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
    else {
        static NSString *simpleTableIdentifier = @"CommonProcessesViewCell";
        CommonProcessesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        cell.delegate = self;
        [cell setCellData:[commonProcessStepsArray objectAtIndex:indexPath.row] index:indexPath.row isAdded:[indexArray[indexPath.row] boolValue]];
        return cell;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_productListTableView]) {
        selectedProduct = filteredProductsArray[indexPath.row];
        [self loadProductProcessFlow:filteredProductsArray[indexPath.row]];
    }
    else if ([tableView isEqual:_processListTableView]){
    }
    else {
        
    }
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
        _addStepButton.hidden = false;
    }
    _productNameLabel.text = product.name;
    _productIdLabel.text = product.productNumber;
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
        processStepsArray = [product getProcessSteps];
        [_processListTableView reloadData];
        [self setUpCommonProcessTable];
    }
    else {
        [self getProcessFlowForProduct:product];
    }
}

- (void)getProcessFlowForProduct:(ProductModel*)product {
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getProcessFlow&process_ctrl_id=%@-%@-%@",product.productNumber, @"PC1",@"1.0"] withTag:3];
}

- (void)deleteProcessFromListAtIndex:(int)index {
    NSMutableDictionary *processData = deletedProcessArray[index];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=delFlowProcess&processno=%@&process_ctrl_id=%@",processData[@"processno"],processCntrlId] withTag:4];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag {
    NSLog(@"jsonData = %@", jsonData);
    processStepsArray = [[NSMutableArray alloc] init];

    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        //return;
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            NSDictionary *jsonDict = json[0];
            NSMutableArray* jsonProcessesArray = jsonDict[@"processes"];
            NSLog(@"json processes array=%@",jsonProcessesArray);
            processStepsArray=[jsonProcessesArray mutableCopy];
            processCntrlId = jsonDict[@"process_ctrl_id"];
            NSLog(@"processes Array=%@",processStepsArray);
            [selectedProduct setProcessSteps:processStepsArray];
            [_processListTableView reloadData];
        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
    [_processListTableView reloadData];
    [self setUpCommonProcessTable];
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (NSMutableArray*) filteredProductsArrayForIndex:(int)index
{
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (int i=0; i < productsArray.count; ++i) {
        
        ProductModel *p = productsArray[i];
        if (!p.isVisible && !screenIsForAdmin) {
            continue;
        }
        if ([[p.name lowercaseString] containsString:@"sentinel"])
        {
            if (index == 0)
                [filteredArray addObject:p];
        }
        else if ([[p.name lowercaseString] containsString:@"receptor"] || [[p.name lowercaseString] containsString:@"inspector"])
        {
            if (index == 1)
                [filteredArray addObject:p];
        }
        else if ([[p.name lowercaseString] containsString:@"grillville"])
        {
            if (index == 2)
                [filteredArray addObject:p];
        }
        else if (index == 3)
            [filteredArray addObject:p];
    }
    return filteredArray;
}

- (void)resetSegmentTitles {
    for (int i=0; i < 4; ++i) {
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
    [_editProcessFlowView removeFromSuperview];
    indexArray = alteredIndexArray;
    processStepsArray = alteredProcessesArray;
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
            NSMutableDictionary *selectedProcessData = [[NSMutableDictionary alloc] init];
            [selectedProcessData setObject:processDict[@"processno"] forKey:@"processno"];
            [selectedProcessData setObject:[NSString stringWithFormat:@"%lu",processStepsArray.count+1] forKey:@"stepid"];
            [selectedProcessData setObject:processDict[@"op1"] forKey:@"op1"];
            [selectedProcessData setObject:processDict[@"op2"] forKey:@"op2"];
            [selectedProcessData setObject:processDict[@"op3"] forKey:@"op3"];
            [selectedProcessData setObject:processDict[@"time"] forKey:@"time"];
            [selectedProcessData setObject:@"archive" forKey:@"processstatus"];
            [selectedProcessData setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"timestamp"];
            [selectedProcessData setObject:@"" forKey:@"comments"];
            [alteredProcessesArray addObject:selectedProcessData];
            break;
        }
    }
}

- (IBAction)submitForApprovalPressed:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *processData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@-%@",selectedProduct.productNumber,@"PC1",@"1.0"],@"process_ctrl_id",[NSString stringWithFormat:@"%@_%@_%@",selectedProduct.name, @"PC1", @"1.0"], @"process_ctrl_name",selectedProduct.productID,@"ProductId",@"1.0", @"VersionId", @"Draft", @"Status", @"Arvind", @"Originator", @"", @"Approver", @"",@"Comments", @"", @"Description",[dateFormat stringFromDate:[NSDate date]], @"Timestamp" , nil];
    [__DataManager syncProcesses:processStepsArray withProcessData:processData];
    
    //delete removed processes
    for (int i=0; i < deletedProcessArray.count; ++i) {
        [self deleteProcessFromListAtIndex:i];
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
