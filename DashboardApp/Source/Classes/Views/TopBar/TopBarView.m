//
//  TopBarView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 31/07/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "TopBarView.h"
#import "UIImage+FontAwesome.h"

@implementation TopBarView

__CREATEVIEW(TopBarView, @"TopBarView", 0);

- (void)initView {
    _versionLabel.text = cstrf(@"Version %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);

    _profileImageView.layer.cornerRadius = 23.0f;
    _profileImageView.layer.borderWidth = 2.0;
    _profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIImage *iconHelp = [UIImage imageWithIcon:@"fa-life-ring" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    _helpImageView.image = iconHelp;
    
    UIImage *iconSearch = [UIImage imageWithIcon:@"fa-search" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    _searchImageView.image = iconSearch;
    
    UIImage *iconDown = [UIImage imageWithIcon:@"fa-angle-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    _downImageView.image = iconDown;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
