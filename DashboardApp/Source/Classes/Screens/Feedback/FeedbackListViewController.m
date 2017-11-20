//
//  FeedbackListViewController.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FeedbackListViewController.h"
#import "FeedbackListViewCell.h"

@interface FeedbackListViewController ()

@end

@implementation FeedbackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    statusArray = @[@"Open", @"Closed", @"All"];
    ownerArray = @[@"Pune",@"Lausanne", @"Mason", @"All"];
    categoryArray = @[@"Cosmetic",@"Hardware Failure", @"Logical Failure", @"Procedural Failure",@"Design Issue", @"Software/Firmware", @"All"];
    productArray = @[@"Sentinel Next", @"iCelsius Wireless", @"Receptor", @"All"];
    backgroundDimmingView = [self buildBackgroundDimmingView];
    [self.view addSubview:backgroundDimmingView];
    backgroundDimmingView.hidden = true;
    filteredArray = feedbacksArray;
    selectedStatus = @"Open";
    selectedCategory = @"All";
    selectedOwner = @"Pune";
    selectedProduct = @"All";
    [self filterList];
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

- (void)setFeedbacksList:(NSMutableArray*)feedbacksList {
    feedbacksArray = feedbacksList;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"FeedbackListViewCell";
    FeedbackListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    //cell.delegate = self;
    [cell setCellData:[filteredArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [self showFeedbackDetail];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void) closeFeedbackDetail {
    backgroundDimmingView.hidden = true;
}

- (void)showFeedbackDetail {
    backgroundDimmingView.hidden = false;
    FeedbackDetailView *feedbackDetailView = [FeedbackDetailView createView];
    feedbackDetailView.frame = CGRectMake(self.view.frame.size.width/2-feedbackDetailView.frame.size.width/2, self.view.frame.size.height/2-feedbackDetailView.frame.size.height/2, feedbackDetailView.frame.size.width, feedbackDetailView.frame.size.height);
    [feedbackDetailView setDelegate:self];
    [feedbackDetailView initView];
    [feedbackDetailView setFeedbackData:feedbacksArray[selectedIndex]];
    [self.view addSubview:feedbackDetailView];
}

- (IBAction)pickStatusPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :statusArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor grayColor];
        dropDown.tag = 1;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickCategoryPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :categoryArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor grayColor];
        dropDown.tag = 2;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickOwnerPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :ownerArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor grayColor];
        dropDown.tag = 3;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickProductPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :productArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor grayColor];
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
        selectedStatus = statusArray[index];
    }
    else if(dropDown.tag == 2){
        selectedCategory = categoryArray[index];
    }
    else if(dropDown.tag == 3){
        selectedOwner = ownerArray[index];
    }

    else {
        selectedProduct = productArray[index];
    }
    [self filterList];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (void)filterList {
    [self filterStatus];
    [self filterCategory];
    [self filterOwner];
    [self filterProduct];
    [_tableView reloadData];
}

- (void)filterStatus {
    filteredArray = [[NSMutableArray alloc] init];
    if ([selectedStatus isEqualToString:@"All"]) {
        filteredArray = feedbacksArray;
    }
    else {
        for (int i = 0; i < feedbacksArray.count; ++i) {
            NSMutableDictionary *feedbackData = feedbacksArray[i];
            if ([selectedStatus isEqualToString:@"Open"]) {
                if (![feedbackData[@"Status"] isEqualToString:@"Closed"]) {
                    [filteredArray addObject:feedbackData];
                }
            }
            else {
                if ([feedbackData[@"Status"] isEqualToString:selectedStatus]) {
                    [filteredArray addObject:feedbackData];
                }
            }
        }
    }
}

- (void)filterCategory {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([selectedCategory isEqualToString:@"All"]) {
        array = filteredArray;
    }
    else {
        for (int i = 0; i < filteredArray.count; ++i) {
            NSMutableDictionary *feedbackData = filteredArray[i];
            if ([feedbackData[@"Category"] isEqualToString:selectedCategory]) {
                [array addObject:feedbackData];
            }
        }
    }
    filteredArray = array;
}

- (void)filterOwner {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([selectedOwner isEqualToString:@"All"]) {
        array = filteredArray;
    }
    else {
        for (int i = 0; i < filteredArray.count; ++i) {
            NSMutableDictionary *feedbackData = filteredArray[i];
            if ([feedbackData[@"Owner"] isEqualToString:selectedOwner]) {
                [array addObject:feedbackData];
            }
        }
    }
    filteredArray = array;
}

- (void)filterProduct {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([selectedProduct isEqualToString:@"All"]) {
        array = filteredArray;
    }
    else {
        for (int i = 0; i < filteredArray.count; ++i) {
            NSMutableDictionary *feedbackData = filteredArray[i];
            if ([feedbackData[@"Product Name"] containsString:selectedProduct]) {
                [array addObject:feedbackData];
            }
        }
    }
    filteredArray = array;
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
