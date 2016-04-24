//
//  PublishDynamicViewController.m
//  Gather
//
//  Created by apple on 15/1/15.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PublishDynamicViewController.h"
#import "PublishPhotoCollectionViewCell.h"
#import <CTAssetsPickerController.h>
#import <CTAssetsPageViewController.h>
#import "SelectImageViewController.h"
#import "DynamicCacheEntity.h"
#import "IDMPhotoBrowser.h"

@interface PublishDynamicViewController ()<UITextViewDelegate,UICollectionViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *characterNumberLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *photoNames;
@property (nonatomic, strong) UIImagePickerController *cameraController;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) BOOL isScale;

@end

@implementation PublishDynamicViewController

- (UIImagePickerController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[UIImagePickerController alloc] init];
        _cameraController.delegate = self;
    }
    return _cameraController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.photos = [[NSMutableArray alloc] init];
    self.photoNames = [[NSMutableArray alloc] init];
    
    self.backgroundView.layer.borderWidth = 0.5;
    self.backgroundView.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
    self.characterNumberLabel.textColor = color_with_hex(kColor_8e949b);
    self.textView.delegate = self;
    
    CGFloat itemWidthAndHeight = (CGRectGetWidth(self.view.bounds) - 25) / 4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake(itemWidthAndHeight, itemWidthAndHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"确认" clickHandler:^(BlockBarButtonItem *item) {
        [TalkingData trackEvent:@"发布动态"];
        [wself publish];
    }]];
}

- (void)publish {
    if (self.textView.text.length <= 0) {
        alert(nil, @"请输入动态内容");
        return;
    }
    
    if (self.textView.text.length > 240) {
        alert(nil, @"内容长度超出最大限制");
        return;
    }
    
    __weak typeof(self) wself = self;
    if (self.isScale) {
        SHOW_LOAD_HUD;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself publish];
        });
    }else {
        DISMISS_HUD;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *date = [dateFormatter stringFromDate:[NSDate date]];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:wself.textView.text forKey:@"content"];
        [dict setObject:wself.photoNames forKey:@"imgNames"];
        [dict setObject:date forKey:@"create_time"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPUBLISH_NOTIFICATION_NAME object:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.characterNumberLabel.text = [NSString stringWithFormat:@"%d/240",textView.text.length];
}

#pragma mark - CTAssetsPickerControllerDelegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset {
    return picker.selectedAssets.count <= (8 - self.photos.count);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (assets) {
        
        __weak typeof(self) wself = self;
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *asset = obj;
            [wself.photos addObject:[UIImage imageWithCGImage:asset.thumbnail]];
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            wself.isScale = YES;
            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ALAsset *asset = obj;
                [wself writeToFileWithAsset:asset image:nil];
            }];
        });
        [self.collectionView reloadData];
    }
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleToSize:(UIImage *)img{
    
    if (img.size.width < 1024 && img.size.height < 1024) {
        return img;
    }

    CGSize size = img.size;
    
    if (size.width > 1024) {
        size.width = 1024;
    }
    if (size.height > 1024) {
        size.height = 1024;
    }
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
// 将原始图片的URL转化为NSData数据,写入沙盒

- (void)writeToFileWithAsset:(ALAsset *)asset image:(UIImage *)image
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:PUBLISH_IMAGE_DIRECTORY_PATH]) {
        [fileManager createDirectoryAtPath:PUBLISH_IMAGE_DIRECTORY_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    __weak typeof(self) wself = self;
    @autoreleasepool {
        NSString * imagePath = @"";
        NSData *data = nil;
        CGFloat size = 100.f;// kb
        if (asset) {
            imagePath = PUBLISH_IMAGE_PATH_WITH_NAME(asset.defaultRepresentation.filename);
            
            UIImage *image = [self scaleToSize:[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage]];
            data = UIImageJPEGRepresentation(image, 1);
            
            CGFloat total = data.length / 1024;
            
            if (total > size) {
                CGFloat scale = size / total;
                data = UIImageJPEGRepresentation(image, scale);
            }
            [wself.photoNames addObject:asset.defaultRepresentation.filename];
        }else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *imageName = [dateFormatter stringFromDate:[NSDate date]];
            imagePath = PUBLISH_IMAGE_PATH_WITH_NAME(imageName);
            
            UIImage *img = [self scaleToSize:image];
            data = UIImageJPEGRepresentation(img, 1);
            
            CGFloat total = data.length / 1024;
            
            if (total > size) {
                CGFloat scale = size / total;
                data = UIImageJPEGRepresentation(img, scale);
            }
            [wself.photoNames addObject:imageName];
        }
        [data writeToFile:imagePath atomically:YES];
        
        if (wself.photoNames.count == wself.photos.count) {
            wself.isScale = NO;
        }
    }
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.photos.count >= 9) {
        return 9;
    }
    return self.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublishPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];

    if (indexPath.item == self.photos.count && self.photos.count < 9) {
        [cell setImage:image_with_name(@"btn_apple_star_add_picture")];
    } else {
        [cell setImage:self.photos[indexPath.item]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.item;
    if (indexPath.item == self.photos.count) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"相册选取",nil];
        [actionSheet showInView:self.view];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看图片",@"删除图片",nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.selectedIndex == self.photos.count) {
        if (buttonIndex == 0) {
            [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
        }
        if (buttonIndex == 1) {
            
            CTAssetsPickerController *photoPicker = [[CTAssetsPickerController alloc] init];
            photoPicker.assetsFilter = [ALAssetsFilter allPhotos];
            photoPicker.alwaysEnableDoneButton = YES;
            photoPicker.delegate = self;
            [self presentViewController:photoPicker animated:YES completion:nil];
        }
    }else {
        if (buttonIndex == 0) {
            if (self.isScale) {
                SHOW_LOAD_HUD;
                __weak typeof(self) wself = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wself actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
                });
            }else {
                DISMISS_HUD;
                NSArray *imgNames = self.photoNames;
                NSMutableArray *imgs = [NSMutableArray array];
                [imgNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [imgs addObject:PUBLISH_IMAGE_WITH_NAME(obj)];
                }];
                IDMPhotoBrowser *browser = [IDMPhotoBrowser controllerWithPhotos:[IDMPhoto photosWithImages:imgs]];
                [browser setInitialPageIndex:self.selectedIndex];
                [self presentViewController:browser animated:YES completion:nil];
            }
        }
        if (buttonIndex == 1) {
            [self.photos removeObjectAtIndex:self.selectedIndex];
            [self.collectionView reloadData];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photos addObject:image];
    [self.collectionView reloadData];
    [self writeToFileWithAsset:nil image:image];
    [self.cameraController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.cameraController dismissViewControllerAnimated:YES completion:nil];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediatypes count] > 0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        self.cameraController.mediaTypes = mediatypes;
        self.cameraController.sourceType = sourceType;
        [self presentViewController:self.cameraController animated:YES completion:nil];
    }else {
        alert(nil, @"当前设备不支持拍摄功能");
    }
}

@end
