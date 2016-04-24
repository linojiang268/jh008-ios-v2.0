//
//  SelectImageViewController.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "SelectImageViewController.h"

@interface SelectImageViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,weak) UIViewController *viewController;
@property (nonatomic, copy) void(^done)(UIImage *image);

@property (nonatomic, assign) GetImageType getType;

@end

@implementation SelectImageViewController

- (instancetype)initWithViewController:(id)viewController getType:(GetImageType)type done:(void (^)(UIImage *))done {
    self = [super init];
    if (self) {
        self.done = done;
        self.getType = type;
        self.viewController = viewController;
    }
    return self;
}

- (void)open {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"相册选取", nil];
    [actionSheet showInView:self.viewController.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0) {
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];  /// 拍照
    }else if(buttonIndex == 1) {
        [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];  //从相册中选择
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image =[info objectForKey:self.getType == GetImageTypeEdited ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    if (self.done) {
        self.done(image);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes = mediatypes;
        picker.delegate = self;
        picker.allowsEditing = (self.getType == GetImageTypeEdited);
        picker.sourceType=sourceType;
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }else {
        alert(nil, @"当前设备不支持拍摄功能");
    }
}

@end
