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

@interface ProductListViewController ()// <FTPProtocol>

@end

@implementation ProductListViewController
{
    __weak IBOutlet UIView   *_productGroupView;
    __weak IBOutlet UIImageView *_backgroundImageView;
    
    BOOL _screenIsForAdmin;
//    int _currentIndex;
//    NSString *_imageName;
//    NSString *_productID;
}

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self initLayout];
    
    productGroupsArray = [NSMutableArray arrayWithObjects:@"Sentinel", @"Inspector", @"GrillVille", @"Misc.",nil];
    [__ServerManager getProductList];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProductList) name:kNotificationProductsReceived object:nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self uploadImages];
//    });
}

#pragma mark - Actions

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) adminSwitchTapped {
    
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
    NSLog(@"PRODUCT %@", product.productNumber);
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

//- (void) uploadImages
//{
//    NSLog(@"%d/%lu", _currentIndex, (unsigned long)productsArray.count);
//    if (_currentIndex >= productsArray.count)
//        return;
//
//    ProductModel *p = productsArray[_currentIndex];
//    UIImage *img = [UIImage imageNamed:p.productNumber];
//    if (img != nil) {
//        NSData *imgData = UIImageJPEGRepresentation(img, 1);
//        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//        _imageName = [NSString stringWithFormat:@"image%@%.0f.jpg", p.productID, time];
//        _productID = p.productID;
//        [[ProdAPI sharedInstance] uploadPhoto:imgData name:_imageName forProductID:p.productID delegate:self];
//    } else {
//        _currentIndex = _currentIndex + 1;
//        [self uploadImages];
//    }
//}
//
//- (void) imageUploaded {
//
//    [[ProdAPI sharedInstance] updateProduct:_productID image:_imageName withCompletion:^(BOOL success, id response) {
//
//        if (success == true) {
//            NSLog(@"SSSUCCESS");
//        } else {
//            NSLog(@"FFFAIL");
//        }
//        _currentIndex = _currentIndex + 1;
//        [self uploadImages];
//    }];
//}
//
//- (void) failImageUpload {
//    _currentIndex = _currentIndex + 1;
//    [self uploadImages];
//}

@end
