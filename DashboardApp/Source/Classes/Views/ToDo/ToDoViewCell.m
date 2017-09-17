//
//  ToDoViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ToDoViewCell.h"

@implementation ToDoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _imageView.layer.cornerRadius = 15.0f;
    _imageView.layer.borderWidth = 1.5;
    _imageView.layer.borderColor = [UIColor colorWithRed:255.0f/255 green:182.0f/255 blue:19.0f/255 alpha:1].CGColor;
    _runTitleLabel.text = [NSString stringWithFormat:@"%@: %@",cellData[@"RunId"], cellData[@"ProductName"]];
    _quantityLabel.text = cellData[@"Quantity"];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",cellData[@"ProductNumber"]]];
    if (image) {
        _imageView.image = image;
    }
}

@end
