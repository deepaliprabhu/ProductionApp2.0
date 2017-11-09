//
//  ProductCollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ProductCollectionViewCell
{
    __weak IBOutlet UIImageView *_stateImageView;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
}

- (void)setCellData:(ProductModel*)p atIndex:(int)index_ forAdmin:(BOOL)isAdmin
{
    index = index_;
    _titleLabel.text = p.name;
    
    [_spinner stopAnimating];
    if ([p photoURL] == nil)
        [_imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    else
    {
        if ([p.productID isEqualToString:@"405"]) {
            NSLog(@"da");
        }
        
        [_spinner startAnimating];
        [_imageView sd_setImageWithURL:[p photoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_spinner stopAnimating];
        }];
    }
    
    if (isAdmin == true)
    {
        if ([p.productStatus isEqualToString:@"InActive"])
            _stateImageView.image = ccimg(@"productDeactivatedIcon");
        else
            _stateImageView.image = ccimg(@"productActivatedIcon");
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

@end
