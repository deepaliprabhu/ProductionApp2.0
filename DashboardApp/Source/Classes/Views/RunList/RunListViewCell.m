//
//  RunListViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunListViewCell.h"

@implementation RunListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(Run*)run_ {
    run = run_;
    _imageView.layer.cornerRadius = 15.0f;
    
    if ([run getCategory] == 0) {
        _runNameLabel.text = [NSString stringWithFormat:@"[PCB] %d: %@",[run getRunId], [run getProductName]];
    }
    else {
        _runNameLabel.text = [NSString stringWithFormat:@"[ASSM] %d: %@",[run getRunId], [run getProductName]];
    }

    _quantityLabel.text = [NSString stringWithFormat:@"%d",[run getQuantity]];
    _statusLabel.text = [run getStatus];
    _weekLabel.text = [run getRunData][@"Shipping"];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[run getProductNumber]]];
    if (image) {
        _imageView.image = image;
    }
    else {
        _imageView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    _imageView.layer.borderWidth = 1.5;
    NSString *status = [run getStatus];

    if (([status isEqualToString:@"In Progress"])||([status isEqualToString:@"IN PROGRESS"])||([status isEqualToString:@"IN PROCESS"])) {
        //_colorView.backgroundColor = [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1];
        //_colorView.backgroundColor = [run getRunColor];
        _imageView.layer.borderColor = [run getRunColor].CGColor;
        
    }
    else if ([status isEqualToString:@"Ready For Dispatch"]) {
        //_colorView.backgroundColor = [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1];
        _imageView.layer.borderColor =  [UIColor colorWithRed:38.0f/255 green:194.0f/255 blue:129.0f/255 alpha:1].CGColor;
    }
    else if ([status isEqualToString:@"Closed"]) {
        //_colorView.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.7];
        _imageView.layer.borderColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.7].CGColor;
    }
    else if ([[status lowercaseString] containsString:@"low priority"]) {
        //_colorView.backgroundColor = [UIColor grayColor];
        _imageView.layer.borderColor = [UIColor grayColor].CGColor;
    }
    else if ([[status lowercaseString] containsString:@"new"]) {
        //_colorView.backgroundColor = [UIColor grayColor];
        _imageView.layer.borderColor = [UIColor grayColor].CGColor;
    }
    else if ([[status lowercaseString] containsString:@"parts short"]||[[status lowercaseString] containsString:@"on hold"]) {
        //_colorView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f blue:0.0f alpha:0.7];
        _imageView.layer.borderColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f blue:0.0f alpha:0.7].CGColor;
    }
    else {
        //_colorView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:227.0f/255.0f blue:167.0f/255.0f alpha:0.7];
        _imageView.layer.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:227.0f/255.0f blue:167.0f/255.0f alpha:0.7].CGColor;
    }
}

- (Run*)getRun {
    return run;
}

@end
