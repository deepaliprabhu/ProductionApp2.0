//
//  ProcessEditableCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessModel.h"

@protocol ProcessEditableCellProtocol;

@interface ProcessEditableCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ProcessEditableCellProtocol> delegate;

- (void) layoutWithData:(NSDictionary*)dict atRow:(int)row;

@end

@protocol ProcessEditableCellProtocol <NSObject>

- (void) showOperatorsForRow:(int)row rect:(CGRect)rect;
- (void) showTargetInputForRow:(int)row rect:(CGRect)rect;
- (void) showProcessTimeInputForRow:(int)row;

@end
