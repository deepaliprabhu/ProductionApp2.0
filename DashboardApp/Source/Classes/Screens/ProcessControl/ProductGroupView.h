//
//  ProductGroupView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol ProductGroupViewDelegate;
@interface ProductGroupView : UIView {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UICollectionView *_collectionView;
    
    NSMutableArray *productsArray;
}
__pd(ProductGroupViewDelegate);
__CREATEVIEWH(ProductGroupView);
- (void)initViewWithTitle:(NSString*)title;
- (void)setProductsArray:(NSMutableArray*)productsArray_;
@end

@protocol ProductGroupViewDelegate <NSObject>
- (void)viewProductSteps:(NSMutableDictionary*)productData;
@end
