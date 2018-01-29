//
//  DemandListView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DemandListView.h"
#import "DemandListViewCell.h"
#import "UIView+RNActivityView.h"
#import "ConnectionManager.h"
#import "DataManager.h"


@implementation DemandListView
__CREATEVIEW(DemandListView, @"DemandListView", 0);

- (void)initView {
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:0.5].CGColor;
    
    shippingOptionsArray = [@[@"--", @"Next Week", @"Shipped", @"Pick a date"] mutableCopy];
    //self.layer.cornerRadius = 8.0;
    demandsArray = [__DataManager getDemandList];
    [_tableView reloadData];
}

- (void)setDemandList:(NSMutableArray*)demandList {
    demandsArray = demandList;
    [_tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [demandsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DemandListViewCell";
    DemandListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    //cell.delegate = self;
    [cell setCellData:[demandsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    selectedDemand = demandsArray[indexPath.row];
    _titleLabel.text = selectedDemand[@"Product"];
   // [self showShippingDetailView];
    [_delegate showDetailForDemand:selectedDemand];
}

- (IBAction)closePressed:(id)sender {
    [_delegate closeSelected];
}

- (void)showShippingDetailView {
    _shippingDetailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _shippingDetailView.layer.borderWidth = 1.0f;
    _shippingDetailView.layer.cornerRadius = 6.0f;
    _shippingDetailView.frame = CGRectMake(self.frame.size.width/2-_shippingDetailView.frame.size.width/2, self.frame.size.height/2-_shippingDetailView.frame.size.height/2, _shippingDetailView.frame.size.width, _shippingDetailView.frame.size.height);
    [self addSubview:_shippingDetailView];
}

- (IBAction)cancelEditPressed:(id)sender {
    [_shippingDetailView removeFromSuperview];
}

- (IBAction)saveEditPressed:(id)sender {
    [_shippingDetailView removeFromSuperview];
    if ([_pickShippingButton.titleLabel.text isEqualToString:@"Pick Shipping"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please enter Shipping" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    DemandListViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    if ([selectedShipping isEqualToString:@"--"]) {
        [cell setExpectedDate:selectedShipping];
    }
    else {
        [cell setExpectedDate:[NSString stringWithFormat:@"%@(%d)",selectedShipping,[_qtyTF.text intValue]]];
    }
    
    [self updateDemand];
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
            [self addSubview:calendar];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
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
    DemandListViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:calendar.tag inSection:0]];
    [cell setExpectedDate:dateString];
    selectedIndex = 4;
    [_pickShippingButton setTitle:dateString forState:UIControlStateNormal];
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


@end
