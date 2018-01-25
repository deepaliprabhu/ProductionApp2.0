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

- (void) layoutWithProcess:(ProcessModel*)process;

@end

@protocol ProcessEditableCellProtocol <NSObject>

@end
