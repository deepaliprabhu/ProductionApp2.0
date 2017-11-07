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

@protocol ProductGroupViewDelegate;
@interface ProductGroupView : UIView <ProductViewDelegate> {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet UILabel *_countLabel;
    
    NSArray *productsArray;
}
__pd(ProductGroupViewDelegate);
__CREATEVIEWH(ProductGroupView);

@property (nonatomic, unsafe_unretained) BOOL screenIsForAdmin;

- (void)initViewWithTitle:(NSString*)title;
- (void)setProductsArray:(NSArray*)productsArray_;

@end

@protocol ProductGroupViewDelegate <NSObject>

- (void) viewProductSteps:(ProductModel*)product;

@end