//
//  PurchasePartCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PurchasePartCell.h"
#import "Defines.h"

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
    __unsafe_unretained IBOutlet UILabel *_idLabel;
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
    
    if ([m.status isEqualToString:@"Closed"])
    {
        _expectedDateLabel.text = [_dateFormatter stringFromDate:m.expectedDate];
        _expectedDateLabel.textColor = ccolor(65, 65, 65);
    }
    else {
        
        if (m.expectedDate == nil)
        {
            _expectedDateLabel.text = @"-";
            _expectedDateLabel.textColor = ccolor(233, 46, 40);
        }
        else
        {
            int days = (int)[self daysBetweenDate:[NSDate date] andDate:m.expectedDate];
            
            if (days > 0)
            {
                _expectedDateLabel.text = [NSString stringWithFormat:@"%dd to arrival", days];
                _expectedDateLabel.textColor = ccolor(67, 194, 81);
            }
            else
            {
                _expectedDateLabel.text = [NSString stringWithFormat:@"%dd pass arrival", (-1)*days];
                _expectedDateLabel.textColor = ccolor(233, 46, 40);
            }
        }
    }
    
    _idLabel.text = m.poID;
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
