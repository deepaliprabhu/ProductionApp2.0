//
//  OperatorTargetEditableCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OperatorTargetEditableCellProtocol;

@interface OperatorTargetEditableCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id <OperatorTargetEditableCellProtocol> delegate;

- (void) layoutWithOperator:(NSString*)op andTarget:(NSNumber*)target atIndex:(int)index;

@end

@protocol OperatorTargetEditableCellProtocol <NSObject>

- (void) setTarget:(int)target atIndex:(int)index;

@end
