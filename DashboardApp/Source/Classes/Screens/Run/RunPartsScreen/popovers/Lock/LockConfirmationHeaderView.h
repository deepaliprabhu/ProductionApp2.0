//
//  LockConfirmationHeaderView.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartModel.h"

@interface LockConfirmationHeaderView : UIView

+ (CGFloat) height;
+ (LockConfirmationHeaderView*) createView;
- (void) layoutWithPart:(PartModel*)part atIndex:(int)index allocated:(int)all price:(float)pr;

@end
