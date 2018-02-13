//
//  ProductGroupPopover.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 12/02/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@protocol ProductGroupPopoverDelegate;
@interface ProductGroupPopover : UIViewController

@property (nonatomic, unsafe_unretained) id <ProductGroupPopoverDelegate> delegate;
@property (nonatomic, unsafe_unretained) ProductModel *product;
@property (nonatomic, unsafe_unretained) CGRect sourceRect;
@end

@protocol ProductGroupPopoverDelegate <NSObject>
- (void) statusChangedForProducts;
- (void) presentPhotoPicker:(UIImagePickerController*)p;
- (void) dismissPhotoPicker;
@end
