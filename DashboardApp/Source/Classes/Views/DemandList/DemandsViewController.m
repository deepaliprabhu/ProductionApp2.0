//
//  DemandsViewController.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/01/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "DemandsViewController.h"
#import "DataManager.h"
#import "DemandsViewCell.h"
#import "UIImage+FontAwesome.h"

@implementation DemandsViewController {
    __weak IBOutlet UIButton *_backButton;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _saveButton.layer.cornerRadius = 4.0f;
    _saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _saveButton.layer.borderWidth = 1.5f;
    UIImage *iconRight = [UIImage imageWithIcon:@"fa-chevron-circle-right" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_saveButton setImage:iconRight forState:UIControlStateNormal];
    
    [self initLayout];
    
    if (_productNumber == nil) {
        demandsArray = [[DataManager sharedInstance] getDemandList];
    } else {
        int i = [[DataManager sharedInstance] indexOfDemandForProduct:_productNumber];
        NSDictionary *d = [[DataManager sharedInstance] getDemandList][i];
        demandsArray = [NSMutableArray arrayWithObject:d];
    }
    
    [_tableView reloadData];
    
    shippingOptionsArray = [@[@"--", @"Next Week", @"Shipped", @"Pick a date"] mutableCopy];

    demandListView = [DemandListView createView];
    demandListView.frame = CGRectMake(0, 0, _leftPaneView.frame.size.width, _leftPaneView.frame.size.height);
    [demandListView initView];
    demandListView.delegate = self;
    [_leftPaneView addSubview:demandListView];
}

#pragma mark - Actions

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [demandsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DemandsViewCell";
    DemandsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }

    [cell setCellData:[demandsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedDemand = demandsArray[indexPath.row];
    selectedIndex = indexPath.row;
    _rightPaneView.hidden = false;
    [self showDetailForDemand];
}

#pragma mark - Layout

- (void) initLayout {

    _notesTextView.layer.borderWidth = 0.4f;
    _notesTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _statsView.layer.borderWidth = 0.4f;
    _statsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if (_productNumber == nil) {
        [_backButton setTitle:@"Dashboard" forState:UIControlStateNormal];
    } else {
        [_backButton setTitle:@"Run" forState:UIControlStateNormal];
    }
}

#pragma mark - Utils

- (void) selectProductAt:(int)index {
    
    selectedIndex = index;
    _rightPaneView.hidden = false;
    [self showDetailForDemand];
}

- (void) showDetailForDemand {
    
    NSMutableDictionary *demandData = demandsArray[selectedIndex];
    _productNameLabel.text = demandData[@"Product"];
    _notesTextView.text = demandData[@"Notes"];
    _urgentQtyLabel.text = demandData[@"urgent_qty"];
    _urgentDateLabel.text = demandData[@"urgent_when"];
    _longTermQtyLabel.text = demandData[@"long_term_qty"];
    _longTermDateLabel.text = demandData[@"long_when"];
    _stockQtyLabel.text = demandData[@"Mason_Stock"];
    _stockDateLabel.text = demandData[@"stock_when"];
    _daysOpenLabel.text = demandData[@"Days Open"];
    _runsLabel.text = demandData[@"Runs"];
}

- (void) showDetailForDemand:(NSMutableDictionary*)demandData {
    selectedDemand = demandData;
    _rightPaneView.hidden = false;
    _productNameLabel.text = demandData[@"Product"];
    _notesTextView.text = demandData[@"Notes"];
    /*_urgentQtyLabel.text = demandData[@"urgent_qty"];
    _urgentDateLabel.text = demandData[@"urgent_when"];
    _longTermQtyLabel.text = demandData[@"long_term_qty"];
    _longTermDateLabel.text = demandData[@"long_when"];
    _stockQtyLabel.text = demandData[@"Mason_Stock"];
    _stockDateLabel.text = demandData[@"stock_when"];
    _daysOpenLabel.text = demandData[@"Days Open"];*/
    _runsLabel.text = demandData[@"Runs"];
}

- (IBAction)pickShippingPressed:(UIButton*)sender {
    if(dropDown == nil) {
        CGFloat f = 235;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :shippingOptionsArray :nil :@"down"];
        dropDown.tag = 1;
        dropDown.backgroundColor = [UIColor grayColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickRunPressed:(UIButton*)sender {
    //selectedTag = tag;
    runsArray = [[NSMutableArray alloc] init];
    NSString *runString = selectedDemand[@"Runs"];
    if (![runString isEqualToString:@""]) {
        NSArray *components = [runString componentsSeparatedByString:@","];
        runsArray = [components mutableCopy];
    }
    if (runsArray.count > 0) {
        if(dropDown == nil) {
            CGFloat f = 235;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :runsArray :nil :@"down"];
            dropDown.tag = 2;
            dropDown.backgroundColor = [UIColor grayColor];
            dropDown.delegate = self;
        }
        else {
            [dropDown hideDropDown:sender];
            dropDown = nil;
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Runs associated with this Demand" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void) selectedListIndex:(int)index {
    if (dropDown.tag == 2) {
        selectedRunId = [runsArray[index] intValue];
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
            
            calendar.frame = CGRectMake(10, 10, 300, 320);
            [self.view addSubview:calendar];
        }
        else {
            selectedShipping = shippingOptionsArray[index];
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
    selectedShipping = dateString;
   // DemandListViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:calendar.tag inSection:0]];
    //[cell setExpectedDate:dateString];
    selectedIndex = 4;
   // [_pickShippingButton setTitle:dateString forState:UIControlStateNormal];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        //self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (IBAction)saveEditPressed:(id)sender {
   /* if ([_pickShippingButton.titleLabel.text isEqualToString:@"Pick Shipping"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please enter Shipping" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    /*DemandListViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    if ([selectedShipping isEqualToString:@"--"]) {
        [cell setExpectedDate:selectedShipping];
    }
    else {
        [cell setExpectedDate:[NSString stringWithFormat:@"%@(%d)",selectedShipping,[_qtyTF.text intValue]]];
    }*/
    
    [self updateDemand];
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"() ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}


- (void)updateDemand {
    NSString *encodedString;
    if ([selectedShipping isEqualToString:@"--"]) {
        encodedString = @"--";
    }
    else {
        encodedString = [self urlEncodeUsingEncoding:[NSString stringWithFormat:@"%@(%d)",selectedShipping, [_qtyTF.text intValue]]];
    }
    // [self.navigationController.view showActivityViewWithLabel:@"updating demand"];
    // [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    if (selectedRunId == 0) {
        NSString *reqString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?do=update&call=update_demand_details&demandid=%@&shipping=%@&RunID=%@",selectedDemand[@"Demand Id"],encodedString,@"NONE"];
        [connectionManager makeRequest:reqString withTag:5];
    }
    else {
        NSString *reqString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?do=update&call=update_demand_details&demandid=%@&shipping=%@&RunID=%d",selectedDemand[@"Demand Id"],encodedString,selectedRunId];
        [connectionManager makeRequest:reqString withTag:5];
    }
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    NSLog(@"jsonData = %@", jsonData);
    
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    if ([dataString isEqualToString:@"<pre>1"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data saved successfully" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        // [alertView show];
        return;
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            demandsArray = [[NSMutableArray alloc] init];
            for (int i=0; i < json.count; ++i) {
                NSMutableDictionary *demandData = json[i];
                //NSLog(@"demandData = %@",demandData);
                [demandsArray addObject:demandData];
            }
            //[self saveDemandDataInParse];
            [_tableView reloadData];
        }
        NSLog(@"part short string = %@", partShortString);
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
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
