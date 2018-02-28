//
//  ProductionTargetView.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "ProcessEditableCell.h"

@protocol ProductionTargetViewProtocol;

@interface ProductionTargetView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, ProcessEditableCellProtocol, UIAlertViewDelegate>

@property (nonatomic, unsafe_unretained) id <ProductionTargetViewProtocol> delegate;
@property (nonatomic, strong) NSArray *operators;
@property (nonatomic, unsafe_unretained) UIViewController *parent;

__CREATEVIEWH(ProductionTargetView)

- (void) reloadData;

@end

@protocol ProductionTargetViewProtocol <NSObject>

- (void) newTargeWasSet;
- (void) newProcessTimeWasSet;
- (NSDate*) selectedDate;

@end
