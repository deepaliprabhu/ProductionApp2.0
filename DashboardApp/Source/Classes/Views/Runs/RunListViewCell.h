//
//  RunListViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@protocol RunListViewCellProtocol;

@interface RunListViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <RunListViewCellProtocol> delegate;

- (void) setCellData:(Run*)run showType:(BOOL)show showShipping:(BOOL)shipping;
- (Run*) getRun;

@end


@protocol RunListViewCellProtocol <NSObject>

- (void) showCommentsForRun:(Run*)r;

@end
