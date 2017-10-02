//
//  ProductCollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellData:(NSMutableDictionary*)cellData atIndex:(int)index_{
    index = index_;
    _titleLabel.text = cellData[@"Name"];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",cellData[@"Product Number"]]];
    if (image) {
        [_imageView setImage:image];
    }
    else {
        [_imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    if (([[cellData[@"Status"] lowercaseString] isEqualToString:@"archive"])||([[cellData[@"Status"] lowercaseString] isEqualToString:@"open"])) {
        self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:2.0f/255.0f alpha:0.2f];
    }
    if ([[cellData[@"Status"] lowercaseString] containsString:@"waiting"]) {
        self.backgroundColor = [UIColor colorWithRed:131.0f/255.0f green:188.0f/255.0f blue:72.0f/255.0f alpha:0.4f];
    }
}

- (IBAction)productPressed:(id)sender {
    [_delegate viewProductAtIndex:index];
}
@end
