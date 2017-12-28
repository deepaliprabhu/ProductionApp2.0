//
//  ProductListViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/12/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductListViewCell.h"
#import "UIImageView+WebCache.h"


@implementation ProductListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(ProductModel*)p atIndex:(int)index_ forAdmin:(BOOL)isAdmin
{
    index = index_;
    _productNameLabel.text = p.name;
    
    if ([p photoURL] == nil)
        [_productImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    else
    {
        //[_spinner startAnimating];
        [_productImageView sd_setImageWithURL:[p photoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //[_spinner stopAnimating];
        }];
    }
    
    if (isAdmin == true)
    {
        if ([p.productStatus isEqualToString:@"InActive"]) {
            isActive = false;
            [_stateButton setImage:ccimg(@"productDeactivatedIcon") forState:UIControlStateNormal];
        }
        else {
            isActive = true;
            [_stateButton setImage:ccimg(@"productActivatedIcon") forState:UIControlStateNormal];
        }
    } else
    {
        _stateImageView.image = nil;
        NSString *status = [p.status lowercaseString];
        if (([status isEqualToString:@"archive"])||([status isEqualToString:@"open"])) {
            self.backgroundColor = ccolora(255, 255, 255, 0.2);
        } else if ([status containsString:@"waiting"]) {
            self.backgroundColor = ccolora(131, 188, 72, 0.4);
        }
    }
}

- (IBAction)stateButtonPressed:(id)sender {
    if (isActive) {
        isActive = false;
    }
    else {
        isActive = true;
    }
    [_delegate stateButtonPressedAtIndex:index];
}

@end
