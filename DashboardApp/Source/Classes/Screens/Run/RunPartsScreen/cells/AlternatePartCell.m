//
//  AlternatePartCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "AlternatePartCell.h"
#import "Defines.h"

@implementation AlternatePartCell
{
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_priceLabel;
    __weak IBOutlet UILabel *_stockLabel;
    __weak IBOutlet UILabel *_vendorLabel;
    __weak IBOutlet UILabel *_quantityLabel;
    __weak IBOutlet UIView *_separatorView;
    __weak IBOutlet NSLayoutConstraint *_bottomConstraintSeparatorView;
    __weak IBOutlet UIActivityIndicatorView *_priceSpinner;
    __weak IBOutlet UIActivityIndicatorView *_poSpinner;
}

- (void) layoutWithPart:(PartModel*)part isLast:(BOOL)last
{
    _nameLabel.text = [NSString stringWithFormat:@"%@", part.part];
    _vendorLabel.text = @"-";
    _quantityLabel.text = @"-";
    [self layoutStockForPart:part];
    [self layoutPriceForPart:part];
    
    _bottomConstraintSeparatorView.constant = last?8:0;
    [self layoutIfNeeded];
}

- (void) layoutWithShort:(PartModel*)part isLast:(BOOL)last
{
    _nameLabel.text = [NSString stringWithFormat:@"%@", part.part];
    _quantityLabel.text = @"-";
    [self layoutStockForPart:part];
    [self layoutPriceForPart:part];
    [self layoutPOForPart:part];
    
    _bottomConstraintSeparatorView.constant = last?8:0;
    [self layoutIfNeeded];
}

- (void) layoutPriceForPart:(PartModel*)m
{
    if (m.priceHistory == nil)
    {
        _priceLabel.text = @"";
        [_priceSpinner startAnimating];
    }
    else
    {
        if (m.priceHistory.count == 0)
            _priceLabel.text = @"-$";
        else
            _priceLabel.text = [NSString stringWithFormat:@"%@$", m.priceHistory[0][@"PRICE"]];
        
        [_priceSpinner stopAnimating];
    }
}

- (void) layoutPOForPart:(PartModel*)m
{
    UIColor *c = ccolor(34, 120, 207);
    if (m.purchases == nil)
    {
        _vendorLabel.text = @"";
        [_poSpinner startAnimating];
    }
    else
    {
        [_poSpinner stopAnimating];
        if (m.purchases.count == 0) {
            _vendorLabel.text = @"NO PO";
            c = ccolor(233, 46, 40);
        } else {
            int q = [m openPOQty];
            if (q > 0) {
                _vendorLabel.text = [NSString stringWithFormat:@"%d", q];
                c = ccolor(119, 119, 119);
            }
            else
                _vendorLabel.text = @"-";
        }
    }
    _vendorLabel.textColor = c;
}

- (void) layoutStockForPart:(PartModel*)m {
    
    if (m.audit != nil)
        _stockLabel.text = [NSString stringWithFormat: @"%d", [m totalStock]];
    else
        _stockLabel.text = @"-";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIColor *color = _separatorView.backgroundColor;
    [super setSelected:selected animated:animated];
    if (selected) {
        _separatorView.backgroundColor = color;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    UIColor *color = _separatorView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    if (highlighted){
        _separatorView.backgroundColor = color;
    }
}

@end
