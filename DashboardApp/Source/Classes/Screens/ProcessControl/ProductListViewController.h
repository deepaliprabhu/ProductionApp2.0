//
//  ProductListViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProcessStepsView.h"
#import "ProductGroupView.h"

@interface ProductListViewController : UIViewController<ProductProcessStepsViewDelegate, ProductGroupViewDelegate> {
    
    UIView *backgroundDimmingView;

    ProductProcessStepsView *productProcessStepsView;
    
    NSMutableArray *productsArray;
    NSMutableArray *productGroupsArray;
    NSMutableArray *productGroupViewsArray;
}

@property (nonatomic, unsafe_unretained) BOOL screenIsForAdmin;
@property (nonatomic, strong) UIImage *image;

@end
