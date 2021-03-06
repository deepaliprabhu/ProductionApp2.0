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
#import "LoadingView.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController
{
    __weak IBOutlet UIView   *_productGroupView;
    __weak IBOutlet UIImageView *_backgroundImageView;
    
    BOOL _screenIsForAdmin;
    
    NSMutableArray *_productsToBeReordered;
    int _numberOfOrderRequests;
}

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self initLayout];
    
    _productsToBeReordered = [NSMutableArray array];
    productGroupsArray = [NSMutableArray arrayWithObjects:@"Sentinel", @"Inspector", @"GrillVille", @"Misc.",nil];
    [__ServerManager getProductList];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProductList) name:kNotificationProductsReceived object:nil];
}

#pragma mark - Actions

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) adminSwitchTapped {
    
    [_productsToBeReordered removeAllObjects];
    _screenIsForAdmin = !_screenIsForAdmin;
    for (int i=0; i < productGroupViewsArray.count; ++i)
    {
        ProductGroupView *productGroupView = productGroupViewsArray[i];
        productGroupView.screenIsForAdmin = _screenIsForAdmin;
        [productGroupView setProductsArray:[self filteredProductsArrayForIndex:i]];
    }
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

- (void) presentPhotoPicker:(UIImagePickerController *)p {
    [self presentViewController:p animated:true completion:nil];
}

- (void) dismissPhotoPicker {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) exchangeProduct:(ProductModel *)p1 withProduct:(ProductModel *)p2 {

    int i1 = -1, i2 = -1;
    NSUInteger c = productsArray.count;
    for (int i=0; i<c; i++) {
        
        ProductModel *p = productsArray[i];
        if ([p.productID isEqualToString:p1.productID])
            i1 = i;
        else if ([p.productID isEqualToString:p2.productID])
            i2 = i;
    }
    
    if (i1 > -1 && i2 > -1) {
        p1.order = i2;
        p2.order = i1;
        [_productsToBeReordered addObject:p1];
        [_productsToBeReordered addObject:p2];
        [productsArray exchangeObjectAtIndex:i1 withObjectAtIndex:i2];
    }
}

- (void) updateProductOrders {
    
    _numberOfOrderRequests = 0;
    [LoadingView showLoading:@"Saving order..."];
    for (ProductModel *p in _productsToBeReordered) {
        
        [[ProdAPI sharedInstance] setOrder:p.order forProduct:p.productID withCompletion:^(BOOL success, id response) {
            
            _numberOfOrderRequests++;
            if (_numberOfOrderRequests == _productsToBeReordered.count) {
                [_productsToBeReordered removeAllObjects];
                [LoadingView removeLoading];
            }
                
            if (success == true) {
                
            } else {
                
            }
        }];
    }
}

#pragma mark - ProductProcessStepsViewDelegate

- (void)closeProcessStepsView {
    backgroundDimmingView.hidden = true;
    [productProcessStepsView removeFromSuperview];
}

#pragma mark - Layout

- (void) initLayout {
    
    _productGroupView.layer.masksToBounds = true;
    _productGroupView.layer.cornerRadius  = 9;
    
    [self addBlur];
}

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

- (void) addBlur {
    
    _backgroundImageView.image = _image;
    
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *v = [[UIVisualEffectView alloc] initWithEffect:eff];
    v.frame = _backgroundImageView.bounds;
    v.alpha = 0.9;
    _backgroundImageView.alpha = 0.9;
    
    [_backgroundImageView addSubview:v];
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
        productGroupView.frame = CGRectMake(37, 117+i*117, 888, 117);
        [productGroupView initViewWithTitle:productGroupsArray[i]];
        [productGroupView setProductsArray:[self filteredProductsArrayForIndex:i]];
        productGroupView.delegate = self;
        [_productGroupView addSubview:productGroupView];
        [productGroupViewsArray addObject:productGroupView];
    }
    
    backgroundDimmingView = [self buildBackgroundDimmingView];
    [self.view addSubview:backgroundDimmingView];
    [self.view bringSubviewToFront:productProcessStepsView];
    backgroundDimmingView.hidden = true;
}

- (NSMutableArray*) filteredProductsArrayForIndex:(int)index
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
