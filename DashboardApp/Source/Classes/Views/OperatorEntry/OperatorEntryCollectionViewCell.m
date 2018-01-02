//
//  OperatorEntryCollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "OperatorEntryCollectionViewCell.h"

@implementation OperatorEntryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    operatorArray = [NSMutableArray arrayWithObjects:@"Arvind", @"Govind", @"Archana",@"Pranali", @"Raman", @"Lalu", @"Sadashiv", @"Sonali", @"Abhijith", @"Venkat",nil];
}

- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)rowIndex colIndex:(int)colIndex{
    row = rowIndex;
    col = colIndex;
    data = cellData;
    if (cellData[@"Title"]) {
        _titleTF.text = cellData[@"Title"];
    }
    if (rowIndex == 1) {
        _titleTF.userInteractionEnabled = false;
    }
    _titleTF.tag = rowIndex;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        [self showPopUpWithTitle:@"Set Operator" withOption:operatorArray xy:CGPointMake(16, 0) size:CGSizeMake(287, 260) isMultiple:NO];
        [_delegate tintViewDisplayed:self];
        return false;
    }
    else if (textField.tag > 1 && textField.tag < 6) {
        [_delegate showEntryViewAtColIndex:col];
        return false;
    }
    else {
        return true;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing called");
    if ((textField.tag == 6)||(textField.tag == 7)) {
        [_titleTF resignFirstResponder];
        calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        self.calendar = calendar;
        calendar.delegate = self;
        // calendar.tag = tag;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.minimumDate = [self.dateFormatter dateFromString:@"2012-09-20"];
        
        calendar.onlyShowCurrentMonth = NO;
        calendar.adaptHeightToNumberOfWeeksInMonth = YES;
        
        calendar.frame = CGRectMake(20, 0, 270, 270);
        [self.superview.superview.superview addSubview:calendar];
        [_delegate tintViewDisplayed:self];
        //[_delegate updateProcessWithText:_titleTF.text row:row col:col];
    }
    if (textField.tag == 0) {

    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing called");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn called");
    [_titleTF resignFirstResponder];
    [_delegate updateProcessWithText:_titleTF.text row:row col:col];
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
    _titleTF.text = dateString;
    [_delegate updateProcessWithText:_titleTF.text row:row col:col];
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

- (void)removeCalendar {
    [calendar removeFromSuperview];
    [dropDownList DropDownListViewDidCancel];
}


-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.superview.superview animated:YES];
    [dropDownList SetBackGroundDropDown_R:110 G:110.0 B:110.0 alpha:0.80];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    _titleTF.text = operatorArray[anIndex];
    [_delegate updateProcessWithText:_titleTF.text row:row col:col];
}


@end
