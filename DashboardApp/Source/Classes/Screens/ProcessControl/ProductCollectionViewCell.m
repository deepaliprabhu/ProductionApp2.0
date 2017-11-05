//
//  ProductCollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell

- (void)setCellData:(ProductModel*)p atIndex:(int)index_
{
    index = index_;
    _titleLabel.text = p.name;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", p.productNumber]];
    if (image)
        [_imageView setImage:image];
    else
        [_imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    if ([p.productStatus isEqualToString:@"InActive"])
    {
        _titleLabel.alpha = 0.3;
        _imageView.alpha  = 0.3;
    }
    else
    {
        _titleLabel.alpha = 1;
        _imageView.alpha  = 1;
    }
    
    NSString *status = [p.status lowercaseString];
    if (([status isEqualToString:@"archive"])||([status isEqualToString:@"open"])) {
        self.backgroundColor = ccolora(255, 255, 255, 0.2);
    } else if ([status containsString:@"waiting"]) {
        self.backgroundColor = ccolora(131, 188, 72, 0.4);
    }
}

- (IBAction)productPressed:(id)sender {
    [_delegate viewProductAtIndex:index];
}

@end
