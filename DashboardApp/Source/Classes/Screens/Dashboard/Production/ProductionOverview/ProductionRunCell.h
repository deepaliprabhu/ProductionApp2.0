//
//  ProductionRunCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductionRunCellProtocol;

@interface ProductionRunCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <ProductionRunCellProtocol> delegate;

@end

@protocol ProductionRunCellProtocol <NSObject>

@end
