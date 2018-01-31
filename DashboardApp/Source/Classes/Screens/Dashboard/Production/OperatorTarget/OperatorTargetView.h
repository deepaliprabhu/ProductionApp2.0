//
//  OperatorTargetView.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "OperatorTargetCell.h"
#import "UserModel.h"
#import "DailyLogInputScreen.h"

@protocol OperatorTargetViewProtocol;

@interface OperatorTargetView : UIView <UITableViewDelegate, UITableViewDataSource, OperatorTargetCellProtocol, DailyLogInputProtocol>

@property (nonatomic, strong) UserModel *user;
@property (nonatomic, unsafe_unretained) id <OperatorTargetViewProtocol> delegate;
@property (nonatomic, unsafe_unretained) UIViewController *parent;

__CREATEVIEWH(OperatorTargetView)

- (void) reloadData;

@end

@protocol OperatorTargetViewProtocol <NSObject>

- (void) goBackFromOperatorView;
- (void) newInputLogSet;

@end
