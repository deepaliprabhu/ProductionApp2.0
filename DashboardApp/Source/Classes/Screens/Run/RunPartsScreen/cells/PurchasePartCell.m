//
//  PurchasePartCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PurchasePartCell.h"
#import "Defines.h"
#import "LayoutUtils.h"

static NSDateFormatter *_dateFormatter = nil;

@implementation PurchasePartCell
{
    __unsafe_unretained IBOutlet UIView *_bgView;
    __unsafe_unretained IBOutlet UILabel *_statusLabel;
    __unsafe_unretained IBOutlet UILabel *_vendorLabel;
    __unsafe_unretained IBOutlet UILabel *_qtyLabel;
    __unsafe_unretained IBOutlet UILabel *_priceLabel;
    __unsafe_unretained IBOutlet UIButton *_expectedDateButton;
    __unsafe_unretained IBOutlet UILabel *_createdDateLabel;
    __unsafe_unretained IBOutlet UILabel *_idLabel;
    __unsafe_unretained IBOutlet UIView *_lineView;
    __unsafe_unretained IBOutlet NSLayoutConstraint *_lineViewWidthConstraint;
    
    int _index;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"dd MMM yyyy";
    });
}

- (IBAction) expectedDateTapped {
    
    CGRect r = [_expectedDateButton convertRect:_expectedDateButton.bounds toView:self.superview.superview.superview.superview];
    [_delegate expectedDateButtonTappedAtIndex:_index position:r];
}

- (void) layoutWith:(PurchaseModel*)m atIndex:(int)index {
    
    _index = index;
    if (index%2 == 0) {
        _bgView.backgroundColor = [UIColor whiteColor];
    } else {
        _bgView.backgroundColor = [UIColor clearColor];
    }
    
    _createdDateLabel.text = [_dateFormatter stringFromDate:m.createdDate];
    
    if ([m.status isEqualToString:@"Closed"])
    {
        _lineViewWidthConstraint.constant = 0;
        _expectedDateButton.enabled = false;
        [_expectedDateButton setTitle:[_dateFormatter stringFromDate:m.expectedDate] forState:UIControlStateNormal];
        [_expectedDateButton setTitleColor:ccolor(65, 65, 65) forState:UIControlStateNormal];
    }
    else {
        
        _expectedDateButton.enabled = true;
        NSString *text = @"-";
        UIColor *c = ccolor(233, 46, 40);
        if (m.expectedDate != nil) {
            int days = (int)[self daysBetweenDate:[NSDate date] andDate:m.expectedDate];
            if (days > 0)
            {
                text = [NSString stringWithFormat:@"%dd to arrival", days];
                c = ccolor(67, 194, 81);
            }
            else
            {
                if (days == 0)
                    text = @"today";
                else
                    text = [NSString stringWithFormat:@"%dd pass arrival", (-1)*days];
            }
        }
    
        _lineView.backgroundColor = c;
        [_expectedDateButton setTitle:text forState:UIControlStateNormal];
        [_expectedDateButton setTitleColor:c forState:UIControlStateNormal];
        CGFloat w = [LayoutUtils widthForText:text withFont:ccFont(@"Roboto-Regular", 15)];
        _lineViewWidthConstraint.constant = w;
    }
    [self layoutIfNeeded];
    
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
