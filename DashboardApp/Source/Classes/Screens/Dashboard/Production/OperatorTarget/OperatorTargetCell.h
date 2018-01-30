//
//  OperatorTargetCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 30/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OperatorTargetCellProtocol;

@interface OperatorTargetCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <OperatorTargetCellProtocol> delegate;

- (void) layoutWithData:(NSDictionary*)dict atRow:(int)row;

@end

@protocol OperatorTargetCellProtocol <NSObject>

- (void) inputLogAt:(int)index;

@end
