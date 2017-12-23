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

- (void)setCellData:(NSMutableDictionary *)cellData index:(int)index_ isAdded:(BOOL)added_{
    index = index_;
    added = added_;
    _titleLabel.text = [NSString stringWithFormat:@"%@-%@",cellData[@"processno"],[cellData[@"processname"] uppercaseString]];
    if (added) {
        UIImage *iconTick = [UIImage imageWithIcon:@"fa-check-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor greenColor] fontSize:20];
        [_addButton setImage:iconTick forState:UIControlStateNormal];
        [_addButton setTintColor:[UIColor colorWithRed:74.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    }
    else {
        UIImage *iconCircle = [UIImage imageWithIcon:@"fa-circle-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
        [_addButton setImage:iconCircle forState:UIControlStateNormal];
        [_addButton setTintColor:[UIColor darkGrayColor]];
    }
}

- (IBAction)addButtonPressed:(id)sender {
    if (added) {
        added = false;
        UIImage *iconCircle = [UIImage imageWithIcon:@"fa-circle-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
        [_addButton setImage:iconCircle forState:UIControlStateNormal];
        [_addButton setTintColor:[UIColor darkGrayColor]];
    }
    else {
        added = true;
        UIImage *iconTick = [UIImage imageWithIcon:@"fa-check-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor greenColor] fontSize:20];
        [_addButton setImage:iconTick forState:UIControlStateNormal];
        [_addButton setTintColor:[UIColor colorWithRed:74.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    }
    [_delegate addButtonPressedAtIndex:index withValue:added];
}

@end
