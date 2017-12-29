//
//  FailHeaderCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailHeaderCell : UITableViewCell

+ (CGFloat) heightFor:(NSString*)text;
- (void) layoutWithReason:(NSString*)reason;

@end
