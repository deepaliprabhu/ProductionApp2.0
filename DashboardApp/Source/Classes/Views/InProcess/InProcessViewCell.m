//
//  InProcessViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "InProcessViewCell.h"

@implementation InProcessViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    NSLog(@"percentage=%f",[cellData[@"Completion"] intValue]*10.0f);
    progressBar.value = (float)[cellData[@"Completion"] intValue]*10.0f;
    _imageView.layer.cornerRadius = 15.0f;
    _runTitleLabel.text = [NSString stringWithFormat:@"%@: %@",cellData[@"RunId"], cellData[@"ProductName"]];
    _quantityLabel.text = cellData[@"Quantity"];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",cellData[@"ProductNumber"]]];
    if (image) {
        _imageView.image = image;
    }
}

@end
