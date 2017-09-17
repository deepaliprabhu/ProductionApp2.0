//
//  CollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 26/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   // self.layer.borderWidth = 1.0f;
    //self.layer.borderColor = [UIColor grayColor].CGColor;
    runsArray = [[NSMutableArray alloc] init];
}

- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)index{
    _runIdLabel.text= cellData[@"RunId"];
    if (index == 0) {
        _rightBorderView.hidden = false;
        _runIdLabel.textColor = [UIColor darkGrayColor];
    }
    else {
        _rightBorderView.hidden = true;
        _runIdLabel.textColor = [UIColor whiteColor];
    }
    if (index == 0) {
        
    }
    else {
        if (index%2 == 0) {
            self.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:235.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        }
        else {
            self.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)addRun:(Run*)run {
    [runsArray addObject:run];
    [self setUpCellSections];
}

- (void)setUpCellSections {
    int noOfSections = runsArray.count;
    //[[self subviews]
    // makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int sectionWidth = self.frame.size.width/noOfSections;
    if (movableView) {
        [movableView removeFromSuperview];
    }
    movableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:movableView];
    for (int i=0; i < noOfSections; ++i) {
        Run *run = runsArray[i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0+(i*sectionWidth), 0, sectionWidth, self.frame.size.height)];
        view.backgroundColor = [run getRunColor];
        [movableView addSubview:view];
        /*UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"123";
        [view addSubview:_titleLabel];*/
        //[self sendSubviewToBack:view];
    }
    [self bringSubviewToFront:_runIdLabel];
    [self setUpCellTitle];

}

- (void)setUpCellTitle {
    int noOfSections = runsArray.count;
    Run *run = runsArray[0];

    NSString *titleText = [NSString stringWithFormat:@"%d",[run getRunId]];
    for (int i=1; i < noOfSections; ++i) {
        Run *run = runsArray[i];
        titleText = [titleText stringByAppendingString:[NSString stringWithFormat:@",%d",[run getRunId]]];
    }
    UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = titleText;
    _titleLabel.font = [UIFont systemFontOfSize:10.0f];
    _titleLabel.adjustsFontSizeToFitWidth = true;
    _titleLabel.tag = 100;
    [movableView addSubview:_titleLabel];
    //[self bringSubviewToFront:_runIdLabel];
}

- (UIView*)getMovableView {
    return movableView;
}

- (void)setMovableView:(UIView*)view {
    NSLog(@"within setMovableView");
    movableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:movableView];
    [view removeFromSuperview];
   // view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    view.backgroundColor = [UIColor yellowColor];
    [movableView addSubview:view1];
    movableView.backgroundColor = [UIColor redColor];
}

- (void)clearMovableView {
    movableView = nil;
    runsArray = [[NSMutableArray alloc] init];
}
@end
