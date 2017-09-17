//
//  TasklistViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "TasklistViewCell.h"
#import "UIImage+FontAwesome.h"


@implementation TasklistViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage *iconOpen = [UIImage imageWithIcon:@"fa-square-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:20];
    [_doneButton setTintColor:[UIColor grayColor]];
    [_doneButton setImage:iconOpen forState:UIControlStateNormal];
    
    UIImage *iconTrash = [UIImage imageWithIcon:@"fa-trash" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:20];
    [_trashButton setTintColor:[UIColor grayColor]];
    [_trashButton setImage:iconTrash forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData index:(int)index_
{
    index = index_;
    _fromLabel.text = cellData[@"AssignedBy"];
    _toLabel.text = cellData[@"AssignedTo"];
    _dueLabel.text = cellData[@"DueDate"];
    _taskTextView.text = cellData[@"Task"];
    if ([cellData[@"Status"] isEqualToString:@"Open"]) {
        done = false;
        [_doneButton setTintColor:[UIColor grayColor]];
        UIImage *iconOpen = [UIImage imageWithIcon:@"fa-square-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:20];
        [_doneButton setImage:iconOpen forState:UIControlStateNormal];
    }
    else {
        done = true;
        [_doneButton setTintColor:[UIColor grayColor]];
        UIImage *iconOpen = [UIImage imageWithIcon:@"fa-check-square-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:20];
        [_doneButton setImage:iconOpen forState:UIControlStateNormal];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    if (done) {
        done = false;
        [_doneButton setTintColor:[UIColor grayColor]];
        UIImage *iconOpen = [UIImage imageWithIcon:@"fa-square-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:20];
        [_doneButton setImage:iconOpen forState:UIControlStateNormal];
        [_delegate updateStatus:false forIndex:index];
    }
    else {
        done = true;
        [_doneButton setTintColor:[UIColor grayColor]];
        UIImage *iconOpen = [UIImage imageWithIcon:@"fa-check-square-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:20];
        [_doneButton setImage:iconOpen forState:UIControlStateNormal];
        [_delegate updateStatus:true forIndex:index];
    }
}

- (IBAction)trashButtonPressed:(id)sender {
    [_delegate deleteTaskAtIndex:index];
}

@end
