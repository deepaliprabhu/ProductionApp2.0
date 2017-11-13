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
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"

@interface ProductGroupView() <GMGridViewDataSource, GMGridViewActionDelegate, GMGridViewSortingDelegate>
@end

@implementation ProductGroupView
{
    GMGridView *_gridView;
    UIPopoverController *_adminPopover;
}

__CREATEVIEW(ProductGroupView, @"ProductGroupView", 0);

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self addGridView];
}

- (void)initViewWithTitle:(NSString*)title
{
    _titleLabel.text = title;
}

- (void)setProductsArray:(NSMutableArray*)productsArray_
{
    productsArray = productsArray_;
    [_gridView reloadData];
}

- (void) reloadData {
    [_gridView reloadData];
}

- (void) setScreenIsForAdmin:(BOOL)screenIsForAdmin {
    
    _screenIsForAdmin = screenIsForAdmin;
    [self layoutCountLabel];
}

#pragma mark - ProductAdminPopoverDelegate

- (void) statusChangedForProducts {
    
    [_gridView reloadData];
    [self layoutCountLabel];
}

- (void) presentPhotoPicker:(UIImagePickerController *)p {
    [_adminPopover dismissPopoverAnimated:true];
    [_delegate presentPhotoPicker:p];
}

- (void) dismissPhotoPicker {
    [_delegate dismissPhotoPicker];
}

#pragma mark - GridViewDelegate

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
    return productsArray.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return CGSizeMake(136, 117);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (cell == nil)
        cell = [GMGridViewCell new];
    
    if (cell.contentView != nil)
        [cell.contentView removeFromSuperview];
    
    ProductCollectionViewCell *prCell = [[NSBundle mainBundle] loadNibNamed:@"ProductCollectionViewCell" owner:nil options:nil][0];
    [prCell setCellData:productsArray[index] atIndex:(int)index forAdmin:_screenIsForAdmin];
    cell.contentView = prCell;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index {
    return false;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
    
    ProductModel *product = productsArray[position];
    if (_screenIsForAdmin == true)
    {
        GMGridViewCell *cell = [_gridView cellForItemAtIndex:position];
        CGRect rect = [_gridView convertRect:cell.frame toView:self.superview.superview.superview];
        
        ProductAdminPopover *screen = [[ProductAdminPopover alloc] initWithNibName:@"ProductAdminPopover" bundle:nil];
        screen.product = product;
        screen.delegate = self;
        screen.sourceRect = rect;
        _adminPopover = [[UIPopoverController alloc] initWithContentViewController:screen];
        [_adminPopover presentPopoverFromRect:rect inView:self.superview.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    }
    else
        [_delegate viewProductSteps:product];
}

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell {
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell {
    [_delegate updateProductOrders];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)view atIndex:(NSInteger)index {
    return _screenIsForAdmin;
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldMoveItemAt:(NSInteger)item {
    return _screenIsForAdmin;
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2 {
    [productsArray exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    [_delegate exchangeProduct:productsArray[index1] withProduct:productsArray[index2]];
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex {
    
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
    
    if (_screenIsForAdmin == true)
        _countLabel.text = cstrf(@"%d/%lu", c, (unsigned long)productsArray.count);
    else
        _countLabel.text = @"";
}

- (void) addGridView {
    
    if (_gridView == nil) {
        [_gridView removeFromSuperview];
        _gridView = nil;
    }
    
    _gridView = [[GMGridView alloc] initWithFrame:CGRectMake(122, 0, 766, 117)];
    _gridView.layer.masksToBounds = true;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _gridView.itemSpacing = 0;
    _gridView.layoutStrategy = [GMGridViewLayoutHorizontalStrategy new];
    _gridView.centerGrid  = false;
    _gridView.actionDelegate = self;
    _gridView.sortingDelegate = self;
    _gridView.dataSource = self;
    _gridView.style = GMGridViewStyleSwap;
    [self addSubview:_gridView];
}

@end
