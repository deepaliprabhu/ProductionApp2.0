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
#import "OperatorsPickerScreen.h"

@protocol ProductionTargetViewProtocol;

@interface ProductionTargetView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, ProcessEditableCellProtocol, OperatorsPickerScreenProtocol, UIAlertViewDelegate>

@property (nonatomic, unsafe_unretained) id <ProductionTargetViewProtocol> delegate;
@property (nonatomic, unsafe_unretained) NSArray *operators;

__CREATEVIEWH(ProductionTargetView)

- (void) reloadData;

@end

@protocol ProductionTargetViewProtocol <NSObject>

- (void) goBackFromTargetView;
- (void) newTargeWasSet;
- (void) newProcessTimeWasSet;

@end
