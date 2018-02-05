//
//  PartDescriptionScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartDescriptionScreen.h"
#import "LayoutUtils.h"
#import "Defines.h"
#import "LoadingView.h"
#import "ProdAPI.h"

@interface PartDescriptionScreen ()

@end

@implementation PartDescriptionScreen
{
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UILabel *_packageLabel;
    __weak IBOutlet UIButton *_changePackageButton;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_part.partDescription.length == 0) {
        
        _textView.text = @"-";
        self.preferredContentSize = CGSizeMake(300, 100);
    }
    else {
        
        _textView.text = _part.partDescription;
        
        CGFloat h = [LayoutUtils heightForText:_part.partDescription withFont:ccFont(@"Roboto-Regular", 15) andMaxWidth:300 centerAligned:false] + 130;
        if (h < 33)
            h = 33;
        else if (h > 650)
            h = 650;
        self.preferredContentSize = CGSizeMake(300, h);
    }
    
    _packageLabel.text = _part.package;
    [self layoutPackageButton];
}

#pragma mark - Actions

- (IBAction) packageButtonTapped {
 
    NSString *newValue = [_part.package isEqualToString:@"yes"] ? @"no" : @"yes";
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] setNewPackageValue:newValue forPart:_part.part completion:^(BOOL success, id response) {
       
        if (success) {
            
            [LoadingView removeLoading];
            _packageLabel.text = newValue;
            _part.package = newValue;
            [self layoutPackageButton];
            [_delegate packageStatusChangeForPart:_part];
        } else {
            [LoadingView showShortMessage:@"Error, please try again later."];
        }
    }];
}

#pragma mark - Layout

- (void) layoutPackageButton {
    
    if ([_part.package isEqualToString:@"yes"])
        [_changePackageButton setTitle:@"To include this part, change to 'no'" forState:UIControlStateNormal];
    else
        [_changePackageButton setTitle:@"To ignore this part, change to 'yes'" forState:UIControlStateNormal];
}

@end
