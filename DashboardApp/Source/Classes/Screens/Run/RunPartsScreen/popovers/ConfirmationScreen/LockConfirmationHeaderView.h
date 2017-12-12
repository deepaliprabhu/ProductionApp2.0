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

+ (LockConfirmationHeaderView*) createView;
- (void) layoutWithPart:(PartModel*)part atIndex:(int)index;

@end
