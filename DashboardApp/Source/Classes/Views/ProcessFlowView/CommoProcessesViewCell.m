//
//  CommonProcessesViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "CommonProcessesViewCell.h"
#import "UIImage+FontAwesome.h"


@implementation CommonProcessesViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage *iconAdd = [UIImage imageWithIcon:@"fa-plus-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_addButton setImage:iconAdd forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary *)cellData index:(int)index_{
    index = index_;
    _titleLabel.text = [NSString stringWithFormat:@"%@-%@",cellData[@"processno"],cellData[@"processname"]];
}

- (IBAction)addButtonPressed:(id)sender {
    [_delegate addButtonPressedAtIndex:index];
}

@end
