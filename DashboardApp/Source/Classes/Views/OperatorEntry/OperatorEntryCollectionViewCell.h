//
//  OperatorEntryCollectionViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "CKCalendarView.h"
#import "DropDownListView.h"


@protocol OperatorEntryCollectionViewDelegate;
@interface OperatorEntryCollectionViewCell : UICollectionViewCell<UITextFieldDelegate, CKCalendarDelegate, kDropDownListViewDelegate> {
    IBOutlet UITextField *_titleTF;
    
    DropDownListView * dropDownList;
    CKCalendarView *calendar;
    
    NSMutableArray *operatorArray;
    NSMutableDictionary *data;
    int row,col;
}
__pd(OperatorEntryCollectionViewDelegate);
- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)rowIndex colIndex:(int)colIndex;
- (void)removeCalendar;
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@end

@protocol OperatorEntryCollectionViewDelegate <NSObject>
- (void)tintViewDisplayed:(OperatorEntryCollectionViewCell*)cell;
- (void)updateProcessWithText:(NSString*)text row:(int)rowIndex col:(int)colIndex;
- (void)showEntryViewAtColIndex:(int)colIndex;
@end
