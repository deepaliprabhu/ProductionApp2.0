//
//  PODateScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PODateScreen.h"
#import "CKCalendarView.h"
#import "UIAlertView+Blocks.h"
#import "ProdAPI.h"
#import "LoadingView.h"

@interface PODateScreen () <CKCalendarDelegate>

@end

@implementation PODateScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CKCalendarView *c = [[CKCalendarView alloc] initWithStartDay:startMonday];
    c.delegate = self;
    c.onlyShowCurrentMonth = false;
    c.adaptHeightToNumberOfWeeksInMonth = true;
    [self.view addSubview:c];
    
    if (_purchase.expectedDate != nil)
        [c selectDate:_purchase.expectedDate makeVisible:true];
    
    self.preferredContentSize = c.bounds.size;
}

#pragma mark - CalendarDelegate

- (void) calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"dd MMM yyyy";
    
    NSString *message = [NSString stringWithFormat:@"The current expected date is %@. Are you sure you want to change it to %@", [f stringFromDate:_purchase.expectedDate], [f stringFromDate:date]];
    [UIAlertView showWithTitle:nil message:message cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
      
        if (buttonIndex == 1) {
            
            f.dateFormat = @"MM/dd/yyyy";
            [LoadingView showLoading:@"Saving..."];
            [[ProdAPI sharedInstance] setPurchase:_purchase.poID date:[f stringFromDate:date] completion:^(BOOL success, id response) {
               
                if (success) {
                    [LoadingView removeLoading];
                    _purchase.expectedDate = date;
                    [_delegate expectedDateChanged];
                    [self dismissViewControllerAnimated:true completion:nil];
                } else {
                    [LoadingView showShortMessage:@"Error, please try again later!"];
                }
            }];
        }
    }];
}

@end
