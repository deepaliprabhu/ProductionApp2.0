//
//  PurchaseCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 10/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PurchaseCell.h"

@implementation PurchaseCell
{
    __unsafe_unretained IBOutlet UIView *_backgroundView;
    __unsafe_unretained IBOutlet UILabel *_titleLabel;
    __unsafe_unretained IBOutlet UILabel *_vendorLabel;
    __unsafe_unretained IBOutlet UILabel *_qtyLabel;
    __unsafe_unretained IBOutlet UILabel *_priceLabel;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _backgroundView.layer.shadowOffset = CGSizeMake(0, 1);
    _backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backgroundView.layer.shadowRadius = 2;
    _backgroundView.layer.shadowOpacity = 0.2;
}

- (void) layoutWith:(PurchaseModel*)m atIndex:(int)index {
    
    _titleLabel.text = [NSString stringWithFormat:@"PO %d", index+1];
    _vendorLabel.text = m.vendor;
    _qtyLabel.text = m.qty;
    _priceLabel.text = [NSString stringWithFormat:@"%@$", m.price];
}

@end
