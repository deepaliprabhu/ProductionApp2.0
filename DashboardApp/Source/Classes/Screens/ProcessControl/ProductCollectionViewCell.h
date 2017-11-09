//
//  ProductCollectionViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 27/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "ProductModel.h"

@interface ProductCollectionViewCell : UICollectionViewCell {
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIImageView *_imageView;
    
    int index;
}

- (void) setCellData:(ProductModel*)p atIndex:(int)index_ forAdmin:(BOOL)isAdmin;

@end
