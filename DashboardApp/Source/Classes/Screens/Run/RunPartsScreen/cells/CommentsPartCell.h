//
//  CommentsPartCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentsPartCell : UITableViewCell

+ (CGFloat) heightFor:(NSString*)text;
- (void) layoutWith:(CommentModel*)comment atIndex:(int)index;

@end
