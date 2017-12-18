//
//  RunDetailsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 18/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunDetailsScreen.h"
#import "Defines.h"
#import "ProdAPI.h"
#import "RunPartsScreen.h"

@interface RunDetailsScreen ()

@end

@implementation RunDetailsScreen {
    
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UILabel *_runNameLabel;
    __weak IBOutlet UILabel *_productNameLabel;

    __weak IBOutlet UIView *_yearsHolderView;
    __weak IBOutlet UILabel *_currentYearTitleLabel;
    __weak IBOutlet UILabel *_currentYearValueLabel;
    __weak IBOutlet UILabel *_lastYearTitleLabel;
    __weak IBOutlet UILabel *_lastYearValueLabel;
    __weak IBOutlet UILabel *_2YearsAgoTitleLabel;
    __weak IBOutlet UILabel *_2YearsAgoValueLabel;
    
    __weak IBOutlet UILabel *_priorityLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_flowLabel;
    __weak IBOutlet UILabel *_requestDateLabel;
    __weak IBOutlet UILabel *_updatedDateLabel;
    __weak IBOutlet UILabel *_shippingDateLabel;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) shortsButtonTapped {
    
    RunPartsScreen *screen = [[RunPartsScreen alloc] initWithNibName:@"RunPartsScreen" bundle:nil];
    screen.run = _run;
    [self.navigationController pushViewController:screen animated:true];
}

#pragma mark - Layout

- (void) initLayout {
    
    _titleLabel.text = cstrf(@"RUN %d", [_run getRunId]);
    
    [self fillContent];
    
    _yearsHolderView.layer.borderColor = ccolor(190, 190, 190).CGColor;
    _yearsHolderView.layer.borderWidth = 1;
}

#pragma mark - Utils

- (void) fillContent {
    
    _runNameLabel.text = [NSString stringWithFormat:@"%@ - %d Units", [_run getProductName], [_run getQuantity]];
    _productNameLabel.text = [_run getProductNumber];
    
    [self fillYears];
    [self getSales];
    
    _priorityLabel.text = [_run getPriority] == 0 ? @"LOW" : @"HIGH";
    _statusLabel.text = [_run getStatus];
    _flowLabel.text = [_run getRunData][@"Version"];
    _requestDateLabel.text = [_run getRequestDate];
    _updatedDateLabel.text = [_run getRunData][@"Updated"];
    _shippingDateLabel.text = [_run getRunData][@"Shipping"];
}

- (void) fillYears {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    int y = (int)[c component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    _currentYearTitleLabel.text = cstrf(@"%d", y);
    _lastYearTitleLabel.text = cstrf(@"%d", y-1);
    _2YearsAgoTitleLabel.text = cstrf(@"%d", y-2);
}

- (void) getSales {
    
    [[ProdAPI sharedInstance] getSalesPerYearFor:[_run getProductNumber] completion:^(BOOL success, id response) {
       
        if (success) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                
                NSDictionary *d = [response firstObject];
                if ([d[@"Current Yr Sold"] length] == 0)
                    _currentYearValueLabel.text = @"-";
                else
                    _currentYearValueLabel.text = d[@"Current Yr Sold"];
                
                if ([d[@"Previous Yr Sold"] length] == 0)
                    _lastYearValueLabel.text = @"-";
                else
                    _lastYearValueLabel.text = d[@"Previous Yr Sold"];
                
                if ([d[@"Current Yr Sold"] length] == 0)
                    _2YearsAgoValueLabel.text = @"-";
                else
                    _2YearsAgoValueLabel.text = d[@"Previous To Previous Yr Sold"];
            }
            
        } else {
            
        }
    }];
}

@end
