//
//  ProductListViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProcessStepsView.h"

@interface ProductListViewController : UIViewController<ProductProcessStepsViewDelegate> {
    IBOutlet UIView *_productGroupView;
    UIView *backgroundDimmingView;

    ProductProcessStepsView *productProcessStepsView;
    
    NSMutableArray *productsArray;
    NSMutableArray *productGroupsArray;
    NSMutableArray *productGroupViewsArray;
}

@end
