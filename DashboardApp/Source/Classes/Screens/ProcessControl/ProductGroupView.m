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
    ProductModel *product = productsArray[index];
    if (_screenIsForAdmin == true)
    {
        UICollectionViewLayoutAttributes *attr =  [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        CGRect rect = [_collectionView convertRect:attr.frame toView:self.superview.superview];
        
        ProductAdminPopover *screen = [[ProductAdminPopover alloc] initWithNibName:@"ProductAdminPopover" bundle:nil];
        screen.product = product;
        screen.delegate = self;
        UIPopoverController *p = [[UIPopoverController alloc] initWithContentViewController:screen];
        [p presentPopoverFromRect:rect inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    }
    else
        [_delegate viewProductSteps:product];
}

#pragma mark - ProductAdminPopoverDelegate

- (void) statusChangedForProducts {
    
    [_collectionView reloadData];
    [self layoutCountLabel];
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

@end
