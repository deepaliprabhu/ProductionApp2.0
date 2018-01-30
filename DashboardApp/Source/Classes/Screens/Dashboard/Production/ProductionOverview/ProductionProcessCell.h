//
//  ProductionProcessCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductionProcessCellProtocol;

@interface ProductionProcessCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ProductionProcessCellProtocol> delegate;

- (void) layoutWithData:(NSDictionary*)dict;

@end

@protocol ProductionProcessCellProtocol <NSObject>

- (void) showDetailsForRunId:(int)runId;

@end
