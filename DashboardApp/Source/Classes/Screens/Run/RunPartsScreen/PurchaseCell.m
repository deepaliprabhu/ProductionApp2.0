//
//  PurchaseCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 10/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PurchaseCell.h"

static NSDateFormatter *_dateFormatter = nil;

@implementation PurchaseCell
{
    __unsafe_unretained IBOutlet UIView *_backgroundView;
    __unsafe_unretained IBOutlet UILabel *_titleLabel;
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
        _dateFormatter.dateFormat = @"dd.MM.yyyy";
    });
    
    _backgroundView.layer.shadowOffset = CGSizeMake(0, 1);
    _backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backgroundView.layer.shadowRadius = 2;
    _backgroundView.layer.shadowOpacity = 0.2;
}

- (void) layoutWith:(PurchaseModel*)m atIndex:(int)index {
    
    _createdDateLabel.text = [NSString stringWithFormat:@"created on %@", [_dateFormatter stringFromDate:m.createdDate]];
    
    if ([m.expectedDate compare:[NSDate date]] == NSOrderedAscending)
        _expectedDateLabel.text = [NSString stringWithFormat:@"finished on %@", [_dateFormatter stringFromDate:m.expectedDate]];
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
    
    if (m.status.length > 0) {
        _titleLabel.text = [NSString stringWithFormat:@"%d. %@", index+1, m.status];
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"PO %d", index+1];
    }
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
