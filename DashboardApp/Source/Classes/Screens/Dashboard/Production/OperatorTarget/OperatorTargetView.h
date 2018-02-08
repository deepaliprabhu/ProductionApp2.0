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

@interface OperatorTargetView : UIView <UITableViewDelegate, UITableViewDataSource, OperatorTargetCellProtocol, DailyLogInputProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, unsafe_unretained) id <OperatorTargetViewProtocol> delegate;
@property (nonatomic, unsafe_unretained) UIViewController *parent;

__CREATEVIEWH(OperatorTargetView)

- (void) reloadData;
- (void) setUserModel:(UserModel*)user;
- (UserModel*) getUserModel;

@end

@protocol OperatorTargetViewProtocol <NSObject>

- (void) newInputLogSet;
- (NSDate*) selectedDate;

@end
