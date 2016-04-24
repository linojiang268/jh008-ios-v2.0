//
//  ActiveGroupPhotoAddViewController.m
//  Gather
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveGroupPhotoAddViewController.h"

#import "MyPhotoCollectionViewCell.h"
#import "MJRefresh.h"
#import "Network+Photos.h"
#import "IDMPhotoBrowser.h"
#import <CTAssetsPickerController.h>
#import "Network+UploadFile.h"
#import "Network+ActiveGroupPhoto.h"
#import "ActiveConfigEntity.h"

@interface ActiveGroupPhotoAddViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *uploadPhotoArray;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIImagePickerController *cameraController;

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSMutableArray *imgIds;

@end

@implementation ActiveGroupPhotoAddViewController

- (UIImagePickerController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[UIImagePickerController alloc] init];
        _cameraController.delegate = self;
    }
    return _cameraController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 0;
    self.selectedIndex = 0;
    self.uploadPhotoArray = [[NSMutableArray alloc] init];
    self.imgIds = [[NSMutableArray alloc] init];
    
    CGFloat itemWidth = (CGRectGetWidth(self.view.bounds) - 20) / 3;
    CGFloat itemHeight = itemWidth;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyPhotoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"完成" clickHandler:^(BlockBarButtonItem *item) {
        
        if (wself.uploadPhotoArray.count <= 0) {
            [SVProgressHUD showInfoWithStatus:@"请先添加照片"];
        }else {
            if ([ActiveMoreConfigEntity sharedMoreConfig].album_id == ActiveConfigStatusNone) {
                [wself createPhoto];
            }else if ([ActiveMoreConfigEntity sharedMoreConfig].album_id > 0) {
                [wself uploadPhoto];
            }
        }
    }]];
}

- (void)createPhoto {
    
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    NSString *name = [NSString stringWithFormat:@"%@的相册",[Common getSelfUserInfo].nick_name];
    [Network createPhotoWithActiveId:[ActiveConfigEntity sharedConfig].id name:name success:^(id response) {
        [ActiveMoreConfigEntity sharedMoreConfig].album_id = [[[response objectForKey:@"body"] objectForKey:@"id"] intValue];
        [wself uploadPhoto];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败，请重试"];
    }];
}

- (void)uploadPhoto {
    
    if (![SVProgressHUD isVisible]) {
        SHOW_LOAD_HUD;
    }
    
    log_value(@"%d",self.index);
    
    id obj = nil;
    if (self.uploadPhotoArray && self.uploadPhotoArray.count > 0) {
        obj = self.uploadPhotoArray[self.index];
    }else {
        [self updatePhoto];
    }
    
    if ([obj isKindOfClass:[UIImage class]]) {
        __weak typeof(self) wself = self;
        [Network uploadPhotoWithImage:obj compressionQuality:1.0 success:^(id response) {
            
            NSUInteger imgId = [response[@"body"][@"img_id"] intValue];
            PhotoEntity *entity = [[PhotoEntity alloc] init];
            entity.id = imgId;
            
            [wself.imgIds addObject:@(imgId)];
            
            wself.index += 1;
            if (wself.index < wself.uploadPhotoArray.count) {
                [wself uploadPhoto];
            }else {
                [wself updatePhoto];
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showSuccessWithStatus:@"上传失败，请重试"];
        }];
    }else {
        self.index += 1;
        if (self.index < self.uploadPhotoArray.count) {
            PhotoEntity *entity = obj;
            [self.imgIds addObject:@(entity.id)];
            [self uploadPhoto];
        }else {
            if (obj) {
                PhotoEntity *entity = obj;
                [self.imgIds addObject:@(entity.id)];
            }
            [self updatePhoto];
        }
    }
}

- (void)reset {
    self.index = 0;
    self.selectedIndex = 0;
    self.uploadPhotoArray = [[NSMutableArray alloc] init];
    self.imgIds = [[NSMutableArray alloc] init];
    [self.collectionView reloadData];
}

- (void)updatePhoto {
    
    log_value(@"addPhoto");
    __weak typeof(self) wself = self;
    [Network addPhotoWithPhotoId:[ActiveMoreConfigEntity sharedMoreConfig].album_id photoArray:self.imgIds success:^(id response) {
        DISMISS_HUD;
        [[[BlockAlertView alloc] initWithTitle:nil message:@"上传成功，返回列表？" handler:^(UIAlertView *alertView, NSUInteger index) {
            if (index == 1) {
                [wself reset];
            }else {
                [wself.navigationController popViewControllerAnimated:YES];
            }
        } cancelButtonTitle:@"返回" otherButtonTitles:@"继续上传"] show];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showSuccessWithStatus:@"上传失败，请重试"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.uploadPhotoArray.count >= 9) {
        return 9;
    }
    return self.uploadPhotoArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item == self.uploadPhotoArray.count) {
        [cell.imageView setContentMode:UIViewContentModeScaleToFill];
        [cell.imageView setImage:image_with_name(@"btn_my_photo_add_picture_have_words_d")];
    }else {
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        id obj = self.uploadPhotoArray[indexPath.item];
        if ([obj isKindOfClass:[UIImage class]]) {
            [cell.imageView setImage:obj];
        }else {
            PhotoEntity *entity = obj;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnail_url(entity.img_url, CGRectGetWidth(cell.imageView.bounds), CGRectGetHeight(cell.imageView.bounds))] placeholderImage:placeholder_image];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndex = indexPath.item;
    if (indexPath.item == self.uploadPhotoArray.count) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"相册选取",nil];
        [actionSheet showInView:self.view];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看图片",@"删除图片",nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.selectedIndex == self.uploadPhotoArray.count) {
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
            [self browsePhoto];
        }
        if (buttonIndex == 1) {
            [self.uploadPhotoArray removeObjectAtIndex:self.selectedIndex];
            [self.collectionView reloadData];
        }
    }
}

- (void)browsePhoto {
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    [self.uploadPhotoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UIImage class]]) {
            [urls addObject:[IDMPhoto photoWithImage:obj]];
        }else {
            PhotoEntity *entity = obj;
            [urls addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:entity.img_url]]];
        }
    }];
    
    IDMPhotoBrowser *browser = [IDMPhotoBrowser controllerWithPhotos:urls];
    [browser setInitialPageIndex:self.selectedIndex];
    [self presentViewController:browser animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.uploadPhotoArray addObject:[self scaleToSize:image]];
    [self.collectionView reloadData];
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


#pragma mark - CTAssetsPickerControllerDelegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset {
    return picker.selectedAssets.count <= (8 - self.uploadPhotoArray.count);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (assets) {
        SHOW_LOAD_HUD;
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ALAsset *asset = obj;
                [wself.uploadPhotoArray addObject:[wself scaleToSize:[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage]]];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                DISMISS_HUD;
                [wself.collectionView reloadData];
            });
        });
    }
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleToSize:(UIImage *)img{
    
    UIImage *image = img;
    if (!(img.size.width < 1024 && img.size.height < 1024)) {
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
        
        image = scaledImage;
    }
    
    CGFloat size = 100.0f;
    NSData *data = UIImageJPEGRepresentation(image, 1);
    CGFloat total = data.length / 1024;
    
    if (total > size) {
        CGFloat scale = size / total;
        data = UIImageJPEGRepresentation(image, scale);
    }
    
    return [UIImage imageWithData:data];
}


@end
