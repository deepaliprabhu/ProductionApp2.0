//
//  HourScheduleCell.h
//  ProductionMobile
//
//  Created by Andrei Ghidoarca on 19/02/2018.
//  Copyright © 2018 Andrei Ghidoarca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourScheduleCell : UICollectionViewCell

- (void) layoutWithHour:(int)h selected:(BOOL)s;

@end
