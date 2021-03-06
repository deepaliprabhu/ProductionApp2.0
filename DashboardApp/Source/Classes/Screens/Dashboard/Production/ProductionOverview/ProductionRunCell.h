//
//  ProductionRunCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@protocol ProductionRunCellProtocol;

@interface ProductionRunCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ProductionRunCellProtocol> delegate;

- (void) layoutWithData:(NSDictionary*)dict;

@end

@protocol ProductionRunCellProtocol <NSObject>

- (void) showDetailsForRunId:(int)runId;

@end
