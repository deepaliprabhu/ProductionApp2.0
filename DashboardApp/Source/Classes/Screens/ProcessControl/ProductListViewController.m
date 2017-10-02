//
//  ProductListViewController.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductListViewController.h"
#import "ServerManager.h"
#import "DataManager.h"
#import "Constants.h"
#import "ProductGroupView.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    productGroupsArray = [NSMutableArray arrayWithObjects:@"Argus",@"iCelsius", @"GrillVille",@"Bluetooth",@"Others",nil];
    [__ServerManager getProductList];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProductList) name:kNotificationProductsReceived object:nil];
}

- (UIView *)buildBackgroundDimmingView{
    UIView *bgView;
    //blur effect for iOS8
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat frameHeight = screenRect.size.height;
    CGFloat frameWidth = screenRect.size.width;
    CGFloat sideLength = frameHeight > frameWidth ? frameHeight : frameWidth;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        bgView = [[UIVisualEffectView alloc] initWithEffect:eff];
        bgView.frame = CGRectMake(0, 0, sideLength, sideLength);
    }
    else {
        bgView = [[UIView alloc] initWithFrame:self.view.frame];
        bgView.backgroundColor = [UIColor blackColor];
    }
    bgView.alpha = 0.7;
    return bgView;
}

- (void) initProductList{
    productsArray = [__DataManager getProductsArray];
    [self initProductGroupViews];
}

- (void)initProductGroupViews {
    for (int i=0; i < productGroupsArray.count; ++i) {
        ProductGroupView *productGroupView = [ProductGroupView createView];
        productGroupView.frame = CGRectMake(25, 160+i*(productGroupView.frame.size.height+10), productGroupView.frame.size.width, productGroupView.frame.size.height);
        [productGroupView initViewWithTitle:productGroupsArray[i]];
        [productGroupView setProductsArray:[self filteredProductsArrayForIndex:i]];
        productGroupView.delegate = self;
        [self.view addSubview:productGroupView];
        [productGroupViewsArray addObject:productGroupView];
    }
    backgroundDimmingView = [self buildBackgroundDimmingView];
    [self.view addSubview:backgroundDimmingView];
    [self.view bringSubviewToFront:productProcessStepsView];
    backgroundDimmingView.hidden = true;
}

- (NSMutableArray*)filteredProductsArrayForIndex:(int)index {
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (int i=0; i < productsArray.count; ++i) {
        NSMutableDictionary *productData = productsArray[i];
        if (index == 3) {
            if (([productData[@"Product Status"] isEqualToString:@"Production"]||[productData[@"Product Status"] isEqualToString:@"In dev"])&&(([[productData[@"Name"] lowercaseString] containsString:[@"Receptor" lowercaseString]])||([[productData[@"Name"] lowercaseString] containsString:[@"Inspector" lowercaseString]])||([[productData[@"Name"] lowercaseString] containsString:[@"icblue" lowercaseString]])||([[productData[@"Group"] lowercaseString] isEqualToString:@"icelsius blue"]))) {
                [filteredArray addObject:productData];
            }
        }
        else if (index == 2) {
            if (([productData[@"Product Status"] isEqualToString:@"Production"]||[productData[@"Product Status"] isEqualToString:@"In dev"])&&(([[productData[@"Name"] lowercaseString] containsString:[@"GrillVille" lowercaseString]])||([[productData[@"Name"] lowercaseString] containsString:[@"Elite" lowercaseString]])||([[productData[@"Group"] lowercaseString] isEqualToString:@"grillville"]))) {
                [filteredArray addObject:productData];
            }
        }
        else if (index == 1) {
            if (([productData[@"Product Status"] isEqualToString:@"Production"]||[productData[@"Product Status"] isEqualToString:@"In dev"])&&(([[productData[@"Name"] lowercaseString] containsString:[@"iCelsius Wireless" lowercaseString]])||([[productData[@"Name"] lowercaseString] containsString:[@"iCelsius Wireless" lowercaseString]])||([[productData[@"Group"] lowercaseString] isEqualToString:@"icelsius"]))) {
                [filteredArray addObject:productData];
            }
        }
        else {
            if (([[productData[@"Group"] lowercaseString] isEqualToString:[productGroupsArray[index] lowercaseString]])&&([productData[@"Product Status"] isEqualToString:@"Production"]||[productData[@"Product Status"] isEqualToString:@"In dev"])) {
                [filteredArray addObject:productData];
            }
        }
    }
    return filteredArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}

- (void)viewProductSteps:(NSMutableDictionary*)productData {
    backgroundDimmingView.hidden = false;
    productProcessStepsView = [ProductProcessStepsView createView];
    productProcessStepsView.frame = CGRectMake(self.view.frame.size.width/2-productProcessStepsView.frame.size.width/2, self.view.frame.size.height/2-productProcessStepsView.frame.size.height/2, productProcessStepsView.frame.size.width, productProcessStepsView.frame.size.height);
    [productProcessStepsView setProductData:productData];
    productProcessStepsView.delegate = self;
    [productProcessStepsView initView];
    [self.view addSubview:productProcessStepsView];
}

- (void)closeProcessStepsView {
    backgroundDimmingView.hidden = true;
    [productProcessStepsView removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
