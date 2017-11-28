//
//  CommentsPartCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "CommentsPartCell.h"
#import "Defines.h"
#import "LayoutUtils.h"

static NSDateFormatter *_formatter = nil;

@implementation CommentsPartCell
{
    __weak IBOutlet UILabel *_authorLabel;
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UILabel *_messageLabel;
    __weak IBOutlet UIView *_bgView;
}

+ (CGFloat) heightFor:(NSString*)text
{
    CGFloat h = [LayoutUtils heightForText:text withFont:ccFont(@"Roboto-Regular", 15) andMaxWidth:304 centerAligned:false] + 12;
    if (h < 34)
        h = 34;
    return h;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) layoutWith:(CommentModel*)comment atIndex:(int)index
{
    if (index%2 == 0) {
        _bgView.backgroundColor = [UIColor whiteColor];
    } else {
        _bgView.backgroundColor = [UIColor clearColor];
    }
    
    _authorLabel.text = comment.author;
    _messageLabel.text = comment.message;
    _dateLabel.text = [comment dateString];
}

@end
