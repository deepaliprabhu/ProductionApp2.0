//
//  ProductCollectionViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol ProductViewDelegate;
@interface ProductCollectionViewCell : UICollectionViewCell {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIImageView *_imageView;
    
    int index;
}
__pd(ProductViewDelegate);
- (void)setCellData:(NSMutableDictionary*)cellData atIndex:(int)index;
@end

@protocol ProductViewDelegate <NSObject>
- (void)viewProductAtIndex:(int)index;
@end
