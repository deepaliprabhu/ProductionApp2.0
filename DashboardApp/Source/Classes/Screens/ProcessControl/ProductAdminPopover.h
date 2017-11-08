//
//  ProductAdminPopover.h
//  DashboardApp
//
//  Created by Viggo IT on 08/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@protocol ProductAdminPopoverDelegate;

@interface ProductAdminPopover : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, unsafe_unretained) id <ProductAdminPopoverDelegate> delegate;
@property (nonatomic, unsafe_unretained) ProductModel *product;

@end

@protocol ProductAdminPopoverDelegate <NSObject>
- (void) statusChangedForProducts;
@end
