//
//  PurchasePartCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PurchasePartCell.h"

static NSDateFormatter *_dateFormatter = nil;

@implementation PurchasePartCell
{
    __unsafe_unretained IBOutlet UIView *_bgView;
    __unsafe_unretained IBOutlet UILabel *_statusLabel;
    __unsafe_unretained IBOutlet UILabel *_vendorLabel;
    __unsafe_unretained IBOutlet UILabel *_qtyLabel;
    __unsafe_unretained IBOutlet UILabel *_priceLabel;
    __unsafe_unretained IBOutlet UILabel *_expectedDateLabel;
    __unsafe_unretained IBOutlet UILabel *_createdDateLabel;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"dd MMM yyyy";
    });
}

- (void) layoutWith:(PurchaseModel*)m atIndex:(int)index {
    
    if (index%2 == 0) {
        _bgView.backgroundColor = [UIColor whiteColor];
    } else {
        _bgView.backgroundColor = [UIColor clearColor];
    }
    
    _createdDateLabel.text = [_dateFormatter stringFromDate:m.createdDate];

    if ([m.expectedDate compare:[NSDate date]] == NSOrderedAscending)
        _expectedDateLabel.text = [_dateFormatter stringFromDate:m.expectedDate];
    else {
        
        if (m.expectedDate == nil)
            _expectedDateLabel.text = @"-";
        else {
            
            int days = (int)[self daysBetweenDate:[NSDate date] andDate:m.expectedDate];
            if (days > 0)
                _expectedDateLabel.text = [NSString stringWithFormat:@"%d %@ left", days, days==1?@"day":@"days"];
            else {
                
                NSTimeInterval time = [m.expectedDate timeIntervalSinceDate:[NSDate date]];
                int hours = time/3600;
                _expectedDateLabel.text = [NSString stringWithFormat:@"%d %@ left", hours, hours==1?@"hour":@"hours"];
            }
        }
    }
    
    _statusLabel.text = m.status;
    _vendorLabel.text = m.vendor;
    _qtyLabel.text = m.qty;
    _priceLabel.text = [NSString stringWithFormat:@"%@$", m.price];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
