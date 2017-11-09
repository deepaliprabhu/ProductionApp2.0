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

@interface ProductAdminPopover () <FTPProtocol>

@end

@implementation ProductAdminPopover {
    __weak IBOutlet UISwitch *_switch;
    __weak IBOutlet UIButton *_photoButton;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 200);
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
    
    if (_product.photo == nil)
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
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:true completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [LoadingView showLoading:@"Uploading..."];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [[ProdAPI sharedInstance] uploadPhoto:data forProductID:_product.productID delegate:self];
}

#pragma mark - FTPProtocol

- (void) imageUploaded {
    
    NSString *imageName = [NSString stringWithFormat:@"image%@.jpg", _product.productID];
    [[ProdAPI sharedInstance] updateProduct:_product.productID image:imageName withCompletion:^(BOOL success, id response) {
       
        if (success == true) {
            [LoadingView showShortMessage:@"Image uploaded"];
            _product.photo = imageName;
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
    [self presentViewController:picker animated:true completion:nil];
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

@end
