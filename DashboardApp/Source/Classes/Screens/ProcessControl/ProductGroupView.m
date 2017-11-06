//
//  ProductGroupView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductGroupView.h"
#import "ProdAPI.h"
#import "LoadingView.h"
#import "UIAlertView+Blocks.h"

@implementation ProductGroupView

__CREATEVIEW(ProductGroupView, @"ProductGroupView", 0);

- (void)initViewWithTitle:(NSString*)title
{
    _titleLabel.text = title;
}

- (void)setProductsArray:(NSArray*)productsArray_
{
    productsArray = productsArray_;
    [_collectionView reloadData];
    
    if (_screenIsForAdmin == true)
        [self layoutCountLabel];
}

#pragma mark - ProductViewDelegate

- (void)viewProductAtIndex:(int)index
{
    ProductModel *p = productsArray[index];
    if (_screenIsForAdmin == true)
    {
        NSString *newStatus = nil;
        NSString *alertMessage = nil;
        NSString *buttonText = nil;
        if ([p.productStatus isEqualToString:@"InActive"])
        {
            newStatus = @"Active";
            alertMessage = @"Are you sure you want to activate this product?";
            buttonText = @"Activate";
        }
        else
        {
            newStatus = @"InActive";
            alertMessage = @"Are you sure you want to deactivate this product?";
            buttonText = @"Deactivate";
        }
        
        [UIAlertView showWithTitle:nil message:alertMessage cancelButtonTitle:@"Cancel" otherButtonTitles:@[buttonText] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1)
                [self changeStatus:newStatus ofProduct:p atIndex:index];
        }];
    }
    else
        [_delegate viewProductSteps:p];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return productsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"ProductCollectionViewCell";
    
    [collectionView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell setCellData:productsArray[indexPath.row] atIndex:(int)indexPath.row forAdmin:_screenIsForAdmin];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

#pragma mark - Layout

- (void) layoutCountLabel
{
    int c = 0;
    for (ProductModel *p in productsArray)
    {
        if ([p.productStatus isEqualToString:@"InActive"] == false)
            c = c + 1;
    }
    
    _countLabel.text = cstrf(@"%d/%lu", c, (unsigned long)productsArray.count);
}

#pragma mark - Utils

- (void) changeStatus:(NSString*)newStatus ofProduct:(ProductModel*)p atIndex:(int)index
{
    [LoadingView showLoading:@"Updating..."];
    [[ProdAPI sharedInstance] updateProduct:p.productID status:newStatus withCompletion:^(BOOL success, id response) {
        
        if (success == true) {
            if ([newStatus isEqualToString:@"Active"])
                [LoadingView showShortMessage:@"Product activated"];
            else
                [LoadingView showShortMessage:@"Product deactivated"];
            p.productStatus = newStatus;
            [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
            [self layoutCountLabel];
        } else {
            [LoadingView showShortMessage:@"Error, try again later!"];
        }
    }];
}

@end
