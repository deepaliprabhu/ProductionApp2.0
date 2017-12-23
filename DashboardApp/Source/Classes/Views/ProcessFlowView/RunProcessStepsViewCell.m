//
//  RunProcessStepsViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunProcessStepsViewCell.h"
#import "UIImage+FontAwesome.h"
#import "DataManager.h"

@implementation RunProcessStepsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _stationLabel.layer.cornerRadius = 10.0f;
    _stationLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _stationLabel.layer.borderWidth = 1.0f;
    UIImage *iconCross = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_crossButton setImage:iconCross forState:UIControlStateNormal];
    [_crossButton setTintColor:[UIColor colorWithRed:41.f/255.f green:169.f/255.f blue:244.f/255.f alpha:1.0]];
    UIImage *iconTick = [UIImage imageWithIcon:@"fa-check" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_tickButton setImage:iconTick forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellData:(NSMutableDictionary *)cellData index:(int)index_{
    index = index_;
    NSMutableDictionary *processData = [__DataManager getProcessForNo:cellData[@"processno"]];
    _titleLabel.text = [NSString stringWithFormat:@"%@-%@",processData[@"processno"],[processData[@"processname"] uppercaseString]];
    _stationLabel.text = processData[@"stationid"];
}

- (IBAction)crossButtonPressed:(id)sender {
    [_delegate crossButtonPressedAtIndex:index];
}



@end
