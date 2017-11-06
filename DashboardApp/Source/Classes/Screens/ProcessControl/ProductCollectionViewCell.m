//
//  ProductCollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell
{
    __weak IBOutlet UIImageView *_stateImageView;
}

- (void)setCellData:(ProductModel*)p atIndex:(int)index_ forAdmin:(BOOL)isAdmin
{
    index = index_;
    _titleLabel.text = p.name;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", p.productNumber]];
    if (image)
        [_imageView setImage:image];
    else
        [_imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    
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

- (IBAction)productPressed:(id)sender {
    [_delegate viewProductAtIndex:index];
}

@end
