//
//  TopBarView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 31/07/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface TopBarView : UIView {
    IBOutlet UILabel *_versionLabel;
    IBOutlet UIImageView *_profileImageView;
    IBOutlet UIImageView *_searchImageView;
    IBOutlet UIImageView *_helpImageView;
    IBOutlet UIImageView *_downImageView;
    IBOutlet UIView *_userView;
    IBOutlet UIView *_loginView;
}
__CREATEVIEWH(TopBarView);
- (void)initView;
@end
