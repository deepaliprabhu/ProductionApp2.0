//
//  ProductAdminPopover.m
//  DashboardApp
//
//  Created by Viggo IT on 08/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductAdminPopover.h"
#import "LoadingView.h"
#import "ProdAPI.h"
#import "SDImageCache.h"
#import "LayoutUtils.h"
#import "Defines.h"

@interface ProductAdminPopover () <FTPProtocol>

@end

@implementation ProductAdminPopover {
    __weak IBOutlet UISwitch *_switch;
    __weak IBOutlet UIButton *_photoButton;
    
    NSString *_imageName;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(138, 134);
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) photoButtonTapped {
    [self presentPhotoChoices];
}

- (IBAction) switchValueChanged {
 
    NSString *newStatus = nil;
    if ([_product.productStatus isEqualToString:@"InActive"])
        newStatus = @"Active";
    else
        newStatus = @"InActive";
    [self changeStatus:newStatus];
}

- (void) initLayout {
    
    if ([_product photoURL] == nil)
        [_photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    else
        [_photoButton setTitle:@"Change Photo" forState:UIControlStateNormal];
    
    if ([_product.productStatus isEqualToString:@"InActive"])
        [_switch setOn:false];
    else
        [_switch setOn:true];
}

#pragma mark - UIImagePickerProtocol

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_delegate dismissPhotoPicker];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [_delegate dismissPhotoPicker];
    
    [LoadingView showLoading:@"Uploading..."];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    _imageName = [NSString stringWithFormat:@"image%@%.0f.jpg", _product.productID, time];
    NSData *d = [self optimizedImageFor:image];
    [[ProdAPI sharedInstance] uploadPhoto:d name:_imageName forProductID:_product.productID delegate:self];
}

#pragma mark - FTPProtocol

- (void) imageUploaded {

    [[ProdAPI sharedInstance] updateProduct:_product.productID image:_imageName withCompletion:^(BOOL success, id response) {
        
        if (success == true) {
            [LoadingView removeLoading];
            //            [[SDImageCache sharedImageCache] clearMemory];
            //            [[SDImageCache sharedImageCache] clearDisk];
            _product.photo = _imageName;
            [_delegate statusChangedForProducts];
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

- (void) failImageUpload {
    [LoadingView showShortMessage:@"Error, please try again later!"];
}

#pragma mark - Utils

- (void) presentPhotoChoices {
    
    UIAlertController *a = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [a addAction:cancel];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPhotoPicker:UIImagePickerControllerSourceTypeCamera];
    }];
    [a addAction:takePhoto];
    
    UIAlertAction *importPhoto = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPhotoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [a addAction:importPhoto];
    
    [self presentViewController:a animated:true completion:nil];
}

- (void) presentPhotoPicker:(UIImagePickerControllerSourceType)source {
    
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = source;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pp = picker.popoverPresentationController;
    pp.sourceRect = _sourceRect;
    pp.sourceView = self.view.superview.superview.superview.superview;
    [_delegate presentPhotoPicker:picker];
}

- (void) changeStatus:(NSString*)newStatus
{
    [LoadingView showLoading:@"Updating..."];
    [[ProdAPI sharedInstance] updateProduct:_product.productID status:newStatus withCompletion:^(BOOL success, id response) {
        
        if (success == true) {
            [LoadingView removeLoading];
            _product.productStatus = newStatus;
            [_delegate statusChangedForProducts];
        } else {
            [LoadingView showShortMessage:@"Error, try again later!"];
        }
    }];
}

- (NSData*) optimizedImageFor:(UIImage*)i {
    
    NSData *data = UIImageJPEGRepresentation(i, 1);
    if (data.length/1024 > 300) {
        
        UIImage *qImage = [UIImage imageWithData:data];
        CGFloat scaleFactor = 1.0;
        if (qImage.size.width > qImage.size.height)
            scaleFactor = qImage.size.width/1024.0;
        else
            scaleFactor = qImage.size.height/1024.0;
        
        if (scaleFactor > 1)
            scaleFactor = 1.0 / scaleFactor;
        
        UIImage *scaledImage = [LayoutUtils imageWithImage:qImage scaledToSize:CGSizeMake(qImage.size.width*scaleFactor, qImage.size.height*scaleFactor)];
        NSData *scaledData = UIImageJPEGRepresentation(scaledImage, 0.8);
        return scaledData;
    }
    
    return data;
}

@end
