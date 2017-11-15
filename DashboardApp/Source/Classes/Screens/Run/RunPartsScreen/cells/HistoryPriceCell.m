//
//  HistoryPriceCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "HistoryPriceCell.h"
#import "Defines.h"

static NSDateFormatter *_dateFormatter1 = nil;
static NSDateFormatter *_dateFormatter2 = nil;

@implementation HistoryPriceCell
{
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UILabel *_priceLabel;
    __weak IBOutlet UILabel *_qtyLabel;
    __weak IBOutlet UILabel *_poIDLabel;
}

- (void) layoutWith:(NSDictionary*)data currentPrice:(float)currentPrice atIndex:(int)index {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _dateFormatter1 = [NSDateFormatter new];
        _dateFormatter1.dateFormat = @"yyyy-MM-dd";
        _dateFormatter2 = [NSDateFormatter new];
        _dateFormatter2.dateFormat = @"dd MMM yyyy";
    });
    
    if (index%2 == 0) {
        _bgView.backgroundColor = [UIColor whiteColor];
    } else {
        _bgView.backgroundColor = ccolor(239, 239, 239);
    }
    
    _qtyLabel.text = data[@"QTY"];
    _priceLabel.text = [NSString stringWithFormat:@"%@$", data[@"PRICE"]];
    _poIDLabel.text = data[@"POID"];
    NSDate *date = [_dateFormatter1 dateFromString:data[@"PODATE"]];
    _dateLabel.text = [_dateFormatter2 stringFromDate:date];
    
    float price = [data[@"PRICE"] floatValue];
    UIColor *c = nil;
    if (price > currentPrice)
        c = ccolor(233, 46, 40);
    else if (price < currentPrice)
        c = ccolor(67, 194, 81);
    else
        c = ccolor(100, 100, 100);
    _priceLabel.textColor = c;
}

@end
