//
//  ProductListViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/12/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "ProductModel.h"

@protocol ProductListViewCellDelegate;
@interface ProductListViewCell : UITableViewCell {
    IBOutlet UIImageView *_productImageView;
    IBOutlet UIImageView *_stateImageView;
    IBOutlet UILabel *_productNameLabel;
    IBOutlet UIButton *_stateButton;
    
    BOOL isActive;
    int index;
}
__pd(ProductListViewCellDelegate);
- (void) setCellData:(ProductModel*)p atIndex:(int)index_ forAdmin:(BOOL)isAdmin;

@end

@protocol ProductListViewCellDelegate <NSObject>
- (void)stateButtonPressedAtIndex:(int)index;
@end
