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
#import "ProductModel.h"
#import "ProdAPI.h"

@implementation ProductListViewController
{
    __weak IBOutlet UIButton *_adminButton;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_screenIsForAdmin == true) {
        _adminButton.alpha = 0;
    }
    
    productGroupsArray = [NSMutableArray arrayWithObjects:@"Sentinel", @"Inspector", @"GrillVille", @"Misc.",nil];
    [__ServerManager getProductList];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProductList) name:kNotificationProductsReceived object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_screenIsForAdmin == false)
        [self reloadData];
}

#pragma mark - Actions

- (IBAction)closePressed:(id)sender {
    
    if (_screenIsForAdmin == true) {
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:false];
    }
}

- (IBAction) adminButtonTapped {
    
    ProductListViewController *productListVC = [ProductListViewController new];
    productListVC.screenIsForAdmin = true;
    [self.navigationController presentViewController:productListVC animated:true completion:nil];
}

#pragma mark - ProductViewGroupDelegate

- (void) viewProductSteps:(ProductModel *)product
{
    if (_screenIsForAdmin == false) {

        backgroundDimmingView.hidden = false;
        productProcessStepsView = [ProductProcessStepsView createView];
        productProcessStepsView.frame = CGRectMake(self.view.frame.size.width/2-productProcessStepsView.frame.size.width/2, self.view.frame.size.height/2-productProcessStepsView.frame.size.height/2, productProcessStepsView.frame.size.width, productProcessStepsView.frame.size.height);
        [productProcessStepsView setProductData:product];
        productProcessStepsView.delegate = self;
        [productProcessStepsView initView];
        [self.view addSubview:productProcessStepsView];
    }
}

#pragma mark - ProductProcessStepsViewDelegate

- (void)closeProcessStepsView {
    backgroundDimmingView.hidden = true;
    [productProcessStepsView removeFromSuperview];
}

#pragma mark - Layout

- (UIView *)buildBackgroundDimmingView {
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

#pragma mark - Utils

- (void) reloadData
{
    for (int i=0; i < productGroupViewsArray.count; ++i)
    {
        ProductGroupView *productGroupView = productGroupViewsArray[i];
        [productGroupView setProductsArray:[self filteredProductsArrayForIndex:i]];
    }
}

- (void) initProductList
{
    productsArray = [__DataManager getProductsArray];
    [self initProductGroupViews];
}

- (void)initProductGroupViews
{
    productGroupViewsArray = [NSMutableArray array];
    for (int i=0; i < productGroupsArray.count; ++i)
    {
        ProductGroupView *productGroupView = [ProductGroupView createView];
        productGroupView.screenIsForAdmin = _screenIsForAdmin;
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

- (NSArray*) filteredProductsArrayForIndex:(int)index
{
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (int i=0; i < productsArray.count; ++i) {
        
        ProductModel *p = productsArray[i];
        
        if (_screenIsForAdmin == false && p.isVisible == false)
            continue;
        
        if ([[p.name lowercaseString] containsString:@"sentinel"])
        {
            if (index == 0)
                [filteredArray addObject:p];
        }
        else if ([[p.name lowercaseString] containsString:@"receptor"] || [[p.name lowercaseString] containsString:@"inspector"])
        {
            if (index == 1)
                [filteredArray addObject:p];
        }
        else if ([[p.name lowercaseString] containsString:@"grillville"])
        {
            if (index == 2)
                [filteredArray addObject:p];
        }
        else if (index == 3)
            [filteredArray addObject:p];
    }
    
    return filteredArray;
}

@end
