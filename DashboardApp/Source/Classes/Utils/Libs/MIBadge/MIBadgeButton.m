//
//  MIBadgeButton.m
//  Elmenus
//
//  Created by Mustafa Ibrahim on 2/1/14.
//  Copyright (c) 2014 Mustafa Ibrahim. All rights reserved.
//

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#import "MIBadgeButton.h"
#import "MIBadgeLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface MIBadgeButton() {
    UITextView *calculationTextView;
    UILabel *badgeLabel;
}

@end

@implementation MIBadgeButton

+(id)buttonWithType:(UIButtonType)t {
    return [[MIBadgeButton alloc] init];
}

#pragma mark - Setters

- (void) setBadgeString:(NSString *)badgeString
{
    _badgeString = badgeString;
    [self setupBadgeViewWithString:badgeString];
}
- (void)setBadgeEdgeInsets:(UIEdgeInsets)badgeEdgeInsets
{
    _badgeEdgeInsets = badgeEdgeInsets;
    [self setupBadgeViewWithString:_badgeString];
}

#pragma mark - Initializers

- (id) init
{
    if(self == [super init]) {
        [self setupBadgeViewWithString:nil];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if(self == [super initWithCoder:aDecoder]) {
        [self setupBadgeViewWithString:nil];
    }
    return self;
}

- (id) initWithFrame:(CGRect) frame withBadgeString:(NSString *)string
{
    if (self == [super initWithFrame:frame]) {
        [self setupBadgeViewWithString:string];
    }
    return self;
}

- (id) initWithFrame:(CGRect) frame withBadgeString:(NSString *)string badgeInsets:(UIEdgeInsets)badgeInsets
{
    if (self == [super initWithFrame:frame]) {
        self.badgeEdgeInsets = badgeInsets;
        [self setupBadgeViewWithString:string];
    }
    return self;
}

- (void) setupBadgeViewWithString:(NSString *)string
{
    if(!badgeLabel) {
        if(IS_OS_7_OR_LATER)
            badgeLabel = [[UILabel alloc] init];
        else
            badgeLabel = [[MIBadgeLabel alloc] init];
    }
    [badgeLabel setClipsToBounds:YES];
    [badgeLabel setText:string];
    CGSize badgeSize = [badgeLabel sizeThatFits:CGSizeMake(320, FLT_MAX)];
    badgeSize.width = badgeSize.width < 12 ? 15 : badgeSize.width + 5;

    int vertical = self.badgeEdgeInsets.top - self.badgeEdgeInsets.bottom;
    int horizontal = self.badgeEdgeInsets.left - self.badgeEdgeInsets.right;
    
    [badgeLabel setFrame:CGRectMake(self.bounds.size.width - 5 + horizontal, -(badgeSize.height / 2) - 5 + vertical, badgeSize.width, badgeSize.height)];
    [self setupBadgeStyle];
    [self addSubview:badgeLabel];
    
    badgeLabel.hidden = string ? NO : YES;
}

- (void) setupBadgeStyle
{
    [badgeLabel setTextAlignment:NSTextAlignmentCenter];
    [badgeLabel setBackgroundColor:[UIColor redColor]];
    [badgeLabel setTextColor:[UIColor whiteColor]];
    [badgeLabel setFont:[UIFont systemFontOfSize:12.0f]];
    badgeLabel.layer.cornerRadius = 7.6f;
}

@end
