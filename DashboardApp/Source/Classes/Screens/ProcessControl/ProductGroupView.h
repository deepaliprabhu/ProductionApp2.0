//
//  ProductGroupView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "ProductCollectionViewCell.h"
#import "ProductModel.h"
#import "ProductAdminPopover.h"

@protocol ProductGroupViewDelegate;
@interface ProductGroupView : UIView <ProductAdminPopoverDelegate> {
    IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_countLabel;
    
    NSMutableArray *productsArray;
}
__pd(ProductGroupViewDelegate);
__CREATEVIEWH(ProductGroupView);

@property (nonatomic, unsafe_unretained) BOOL screenIsForAdmin;

- (void)initViewWithTitle:(NSString*)title;
- (void)setProductsArray:(NSMutableArray*)productsArray_;
- (void) reloadData;

@end

@protocol ProductGroupViewDelegate <NSObject>

- (void) updateProductOrders;
- (void) exchangeProduct:(ProductModel*)p1 withProduct:(ProductModel*)p2;
- (void) viewProductSteps:(ProductModel*)product;
- (void) presentPhotoPicker:(UIImagePickerController *)p;
- (void) dismissPhotoPicker;

@end
