//
//  MyPhotoViewControllerCollectionViewController.m
//  Gather
//
//  Created by apple on 15/1/20.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "MyPhotoViewController.h"
#import "MyPhotoCollectionViewCell.h"
#import <LXReorderableCollectionViewFlowLayout.h>
#import "MJRefresh.h"
#import "Network+Photos.h"
#import "IDMPhotoBrowser.h"
#import <CTAssetsPickerController.h>
#import "Network+UploadFile.h"

@interface MyPhotoViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *myPhotos;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) int totalNumber;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIImagePickerController *cameraController;

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSMutableArray *imgIds;

@end

@implementation MyPhotoViewController

- (UIImagePickerController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[UIImagePickerController alloc] init];
        _cameraController.delegate = self;
    }
    return _cameraController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.currentPage = 0;
    self.totalNumber = 0;
    self.index = 0;
    self.selectedIndex = 0;
    self.myPhotos = [[NSMutableArray alloc] init];
    self.imgIds = [[NSMutableArray alloc] init];
    
    CGFloat itemWidth = (CGRectGetWidth(self.view.bounds) - 20) / 3;
    CGFloat itemHeight = (CGRectGetHeight(self.collectionView.bounds) - 20 - 44) / 3;
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyPhotoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    __weak typeof(self) wself = self;
    if (self.showManagerButton) {
        [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"管理" clickHandler:^(BlockBarButtonItem *item) {
            
            MyPhotoViewController *controller = [wself.storyboard instantiateViewControllerWithIdentifier:@"MyPhoto"];
            controller.showManagerButton = NO;
            controller.allowEditing = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        }]];
    }
    
    if (self.allowEditing) {
        [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"完成" clickHandler:^(BlockBarButtonItem *item) {
            [wself uploadPhoto];
        }]];
    }
    
    [self.collectionView addHeaderWithCallback:^{
        wself.currentPage = 0;
        [wself requestInfo];
    }];
    if (!self.showManagerButton) {
        [self.collectionView headerBeginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.collectionView.headerRefreshing && self.showManagerButton) {
        [self.collectionView headerBeginRefreshing];
    }
}

- (void)uploadPhoto {
    
    if (self.index == 0) {
        SHOW_LOAD_HUD;
    }
    
    if (![SVProgressHUD isVisible]) {
        SHOW_LOAD_HUD;
    }
    
    log_value(@"%d",self.index);
    
    id obj = nil;
    if (self.myPhotos && self.myPhotos.count > 0) {
        obj = self.myPhotos[self.index];
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
            if (wself.index < wself.myPhotos.count) {
                [wself uploadPhoto];
            }else {
                [wself updatePhoto];
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showSuccessWithStatus:@"更新失败，请重试"];
        }];
    }else {
        self.index += 1;
        if (self.index < self.myPhotos.count) {
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

- (void)updatePhoto {
    
    log_value(@"updatePhoto");
    
    __weak typeof(self) wself = self;
    [Network updatePhotoWithImgIds:self.imgIds success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showSuccessWithStatus:@"更新失败，请重试"];
    }];
}

- (void)requestInfo {
  
    self.currentPage += 1;
    
    __weak typeof(self) wself = self;
    [Network getPhotoWallWithUserId:[Common getCurrentUserId] success:^(PhotosEntity *entity) {
        wself.totalNumber = entity.total_num;
        [wself.myPhotos setArray:entity.photos];
        [wself.collectionView headerEndRefreshing];
        [wself.collectionView reloadDataIfEmptyShowCueWordsView];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [wself.collectionView headerEndRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

#pragma mark <LXReorderableCollectionViewDataSource>

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    id obj = self.myPhotos[fromIndexPath.item];
    
    [self.myPhotos removeObjectAtIndex:fromIndexPath.item];
    [self.myPhotos insertObject:obj atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.allowEditing && indexPath.item != self.myPhotos.count) {
        return YES;
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if (toIndexPath.item == self.myPhotos.count) {
        return NO;
    }
    return YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.allowEditing) {
        if (self.myPhotos.count >= 9) {
            return 9;
        }
        return self.myPhotos.count + 1;
    }
    return self.myPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];

    if (indexPath.item == self.myPhotos.count && self.allowEditing) {
        [cell.imageView setContentMode:UIViewContentModeScaleToFill];
        [cell.imageView setImage:image_with_name(@"btn_my_photo_add_picture_have_words_d")];
    }else {
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        id obj = self.myPhotos[indexPath.item];
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
    if (indexPath.item == self.myPhotos.count && self.allowEditing) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"相册选取",nil];
        [actionSheet showInView:self.view];
    }else if(self.allowEditing) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看图片",@"删除图片",nil];
        [actionSheet showInView:self.view];
    }else {
        [self browsePhoto];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.selectedIndex == self.myPhotos.count) {
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
            [self.myPhotos removeObjectAtIndex:self.selectedIndex];
            [self.collectionView reloadData];
        }
    }
}

- (void)browsePhoto {
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    [self.myPhotos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
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
    [self.myPhotos addObject:[self scaleToSize:image]];
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
    return picker.selectedAssets.count <= (8 - self.myPhotos.count);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (assets) {
        SHOW_LOAD_HUD;
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ALAsset *asset = obj;
                [wself.myPhotos addObject:[wself scaleToSize:[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage]]];
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
