//
//  ShortsCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ShortsCell.h"
#import "Defines.h"

@implementation ShortsCell {
    
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_priceLabel;
    __weak IBOutlet UILabel *_vendorLabel;
    __weak IBOutlet UILabel *_quantityLabel;
    __weak IBOutlet UILabel *_recoLabel;
    __weak IBOutlet UIView *_separatorView;
    __weak IBOutlet UIImageView *_redFlagImageView;
    __weak IBOutlet UIActivityIndicatorView *_priceSpinner;
    __weak IBOutlet UIActivityIndicatorView *_poSpinner;
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

- (void) layoutWithShort:(PartModel*)m {
    
    _redFlagImageView.alpha = m.isHardToGet;
    
    UIColor *c = ccolor(100, 100, 100);
    _nameLabel.text = m.part;
    _separatorView.alpha = (m.alternateParts.count > 0);
    
    [self layoutReconciliationFor:m];
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
            if (q > 0)
                _vendorLabel.text = [NSString stringWithFormat:@"%d", q];
            else
                _vendorLabel.text = @"-";
            c = ccolor(119, 119, 119);
        }
    }
    
    if (m.shortQty > [m totalStock])
        _quantityLabel.textColor = ccolor(233, 46, 40);
    else
        _quantityLabel.textColor = ccolor(67, 194, 81);
    
    int q = m.shortQty-[m totalStock];
    _quantityLabel.text = [NSString stringWithFormat:@"%d", q];
    
    if (m.pricePerUnit != nil)
        _priceLabel.text = [NSString stringWithFormat:@"%.2f$", [m.pricePerUnit floatValue]*q];
    else
        _priceLabel.text = @"-$";
    
    _vendorLabel.textColor = c;
    
    NSNumber *b = [m reconciledInLast7Days];
    if (b == nil)
        _bgView.alpha = 0;
    else
        _bgView.alpha = !b;
}

#pragma mark - Layout

- (void) layoutReconciliationFor:(PartModel*)p {
    
    int days = [p daysSinceLastReconciliation];
    if (days < 0) {
        _recoLabel.text = @"-";
        _recoLabel.textColor = ccolor(233, 46, 40);
    }
    else {
        _recoLabel.text = [NSString stringWithFormat:@"%dd", days];
        if (days < 7) {
            _recoLabel.textColor = ccolor(119, 119, 119);
        } else {
            _recoLabel.textColor = ccolor(233, 46, 40);
        }
    }
}

@end
