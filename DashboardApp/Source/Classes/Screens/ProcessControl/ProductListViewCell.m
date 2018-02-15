//
//  ProductListViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/12/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductListViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FontAwesome.h"



@implementation ProductListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(ProductModel*)p atIndex:(int)index_ forAdmin:(BOOL)isAdmin
{
    index = index_;
    _productNameLabel.text = p.name;
    
    /*if ([p photoURL] == nil)
        [_productImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    else
    {
        //[_spinner startAnimating];
        [_productImageView sd_setImageWithURL:[p photoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //[_spinner stopAnimating];
        }];
    }*/
    if([[p.name lowercaseString] containsString:@"receptor"] || [[p.name lowercaseString] containsString:@"inspector"]) {
        [_groupButton setImage:[UIImage imageNamed:@"inspectorIcon.png"] forState:UIControlStateNormal];
    }
    else if([[p.name lowercaseString] containsString:@"grillville"] || [[p.group lowercaseString] containsString:@"grillville"]){
        [_groupButton setImage:[UIImage imageNamed:@"grillvilleIcon.png"] forState:UIControlStateNormal];
    }
    else if ([[p.name lowercaseString] containsString:@"sentinel"] || [[p.group lowercaseString] containsString:@"sentinel"]) {
        [_groupButton setImage:[UIImage imageNamed:@"sentinelIcon.png"] forState:UIControlStateNormal];
    }
    else {
        [_groupButton setImage:[UIImage imageNamed:@"miscIcon.png"] forState:UIControlStateNormal];
    }
    
    if (isAdmin == true)
    {
        _productNameLabel.frame = CGRectMake(_stateButton.frame.origin.x+_stateButton.frame.size.width, _productNameLabel.frame.origin.y, _productNameLabel.frame.size.width, _productNameLabel.frame.size.height);
        if ([p.productStatus isEqualToString:@"InActive"]) {
            isActive = false;
            [_stateButton setImage:ccimg(@"productDeactivatedIcon") forState:UIControlStateNormal];
        }
        else {
            isActive = true;
            [_stateButton setImage:ccimg(@"productActivatedIcon") forState:UIControlStateNormal];
        }
    } else
    {
        _productNameLabel.frame = CGRectMake(_stateButton.frame.origin.x+10, _productNameLabel.frame.origin.y, _productNameLabel.frame.size.width, _productNameLabel.frame.size.height);
        _stateImageView.image = nil;
        [_stateButton setImage:nil forState:UIControlStateNormal];
        NSString *status = [p.status lowercaseString];
        if (([status isEqualToString:@"archive"])||([status isEqualToString:@"open"])) {
            self.backgroundColor = ccolora(255, 255, 255, 0.2);
        } else if ([status containsString:@"waiting"]) {
            self.backgroundColor = ccolora(131, 188, 72, 0.4);
        }
    }
    
    if ([p.status isEqualToString:@""]) {
        UIImage *iconAdd = [UIImage imageWithIcon:@"fa-plus-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor grayColor] fontSize:10];
        [_statusImageView setImage:iconAdd];
    }
    else if ([p.status isEqualToString:@"OPEN"]||[p.status isEqualToString:@"Draft"]||[p.status isEqualToString:@"Open"]||[p.status isEqualToString:@"Pune Approved"]||[p.status isEqualToString:@"Mason Approved"]||[p.status isEqualToString:@"Mason Rejected"]||[p.status isEqualToString:@"Lausanne Rejected"]) {
        UIImage *iconAdd = [UIImage imageWithIcon:@"fa-exclamation-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor redColor] fontSize:10];
        [_statusImageView setImage:iconAdd];
    }
    else if ([p.status isEqualToString:@"Lausanne Approved"]) {
        UIImage *iconAdd = [UIImage imageWithIcon:@"fa-check-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:73.f/255.f green:173.f/255.f blue:73.f/255.f alpha:1.f] fontSize:10];
        [_statusImageView setImage:iconAdd];
    }
}

- (IBAction)stateButtonPressed:(id)sender {
    /*if (isActive) {
        isActive = false;
    }
    else {
        isActive = true;
    }*/
    [_delegate stateButtonPressedAtIndex:index];
}

- (IBAction)groupButtonPressed:(id)sender {
    [_delegate updateGroupPressedAtIndex:index];
}

@end
