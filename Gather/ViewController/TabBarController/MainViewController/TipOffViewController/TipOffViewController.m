//
//  TipOffViewController.m
//  Gather
//
//  Created by apple on 15/2/3.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "TipOffViewController.h"
#import "PublishPhotoCollectionViewCell.h"
#import "Network+UploadFile.h"
#import <CTAssetsPickerController.h>
#import "IDMPhotoBrowser.h"
#import "Network+Active.h"

@interface TipOffViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, CTAssetsPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *thumbnailArray;
@property (nonatomic, strong) UIImagePickerController *cameraController;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *imageIds;
@property (nonatomic, assign) BOOL isScale;

@end

@implementation TipOffViewController


- (UIImagePickerController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[UIImagePickerController alloc] init];
        _cameraController.delegate = self;
    }
    return _cameraController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageIds = [[NSMutableArray alloc] init];
    self.photoArray = [[NSMutableArray alloc] init];
    self.thumbnailArray = [[NSMutableArray alloc] init];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(5, CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2 - 50, 5, 5);
    layout.itemSize = CGSizeMake(100, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    
    self.collectionView.backgroundColor = color_clear;
    self.textView.backgroundColor = color_clear;
    
    __weak typeof(self) wself = self;
    [self.navigationItem addRightItem:[[BlockBarButtonItem alloc] initWithTitle:@"提交" clickHandler:^(BlockBarButtonItem *item) {
        [wself verify];
    }]];
}

- (void)verify {
    
    if (self.photoArray.count == 0) {
        alert(nil, @"请至少上传一张活动图片");
        return;
    }
    if (string_is_empty(self.phoneTextField.text)) {
        alert(nil, @"请输入联系电话");
        return;
    }
    if (![self.phoneTextField.text validateMobile]) {
        alert(nil, @"请输入正确的电话号码");
        return;
    }
    if (string_is_empty(self.addressTextField.text)) {
        alert(nil, @"请输入详细地址");
        return;
    }
    
    SHOW_LOAD_HUD;
    [self uploadPhotoWithIndex:0];
}

- (void)commit {
    
    __weak typeof(self) wself = self;
    
    CLLocationCoordinate2D coor = [Common getCurrentLocationCoordinate2D];
    [Network tipOffWithCityId:[Common getCurrentCityId] phone:self.phoneTextField.text address:self.addressTextField.text intro:self.textView.text imgIds:self.imageIds lon:coor.longitude lat:coor.latitude locationAddress:[Common getCurrentFullAddress] success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMsg, StatusCode code) {
        DISMISS_HUD;
        [[[BlockAlertView alloc] initWithTitle:nil message:@"提交失败" handler:^(UIAlertView *alertView, NSUInteger index) {
            
            if (index) {
                [wself commit];
            }
            
        } cancelButtonTitle:@"取消" otherButtonTitles:@"重试"] show];
    }];
}
    
- (void)uploadPhotoWithIndex:(NSUInteger)index {
        
    __weak typeof(self) wself = self;
    if (self.photoArray.count != self.thumbnailArray.count && self.isScale) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself uploadPhotoWithIndex:index];
        });
        return;
    }
    UIImage *image = self.photoArray[index];
    [Network uploadPhotoWithImage:image compressionQuality:1 success:^(id response) {
        NSUInteger imgId = [response[@"body"][@"img_id"] intValue];
        [wself.imageIds addObject:@(imgId)];
        NSUInteger nextIndex = index + 1;
        if (nextIndex >= wself.photoArray.count) {
            [wself commit];
        }else {
            [wself uploadPhotoWithIndex:nextIndex];
        }
    } failure:^(NSString *errorMsg, StatusCode code) {
        DISMISS_HUD;
        [[[BlockAlertView alloc] initWithTitle:nil message:@"提交失败" handler:^(UIAlertView *alertView, NSUInteger index) {
            if (index) {
                [wself uploadPhotoWithIndex:index];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"重试"] show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.thumbnailArray.count >= 3) {
        return 3;
    }
    return self.thumbnailArray.count + 1;
    
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    PublishPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item == self.thumbnailArray.count && self.thumbnailArray.count < 3) {
        [cell setImage:image_with_name(@"btn_tip_off_add_picture_have_words_d")];
    } else {
        [cell setImage:self.thumbnailArray[indexPath.item]];
    }
    
    return cell;
}
#pragma mark - CTAssetsPickerControllerDelegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset {
    return picker.selectedAssets.count <= (2 - self.thumbnailArray.count);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (assets) {
        __weak typeof(self) wself = self;
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *asset = obj;
            [wself.thumbnailArray addObject:[UIImage imageWithCGImage:asset.thumbnail]];
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            wself.isScale = YES;
            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ALAsset *asset = obj;
                [wself.photoArray addObject:[self scaleToSize:[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage]]];
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
    
    NSData *data = nil;
    CGFloat kbsize = 100.f;// kb
    data = UIImageJPEGRepresentation(scaledImage, 1);
    
    CGFloat total = data.length / 1024;
    
    if (total > kbsize) {
        CGFloat scale = kbsize / total;
        data = UIImageJPEGRepresentation(scaledImage, scale);
    }
    
    if ((self.photoArray.count + 1) == self.thumbnailArray.count) {
        self.isScale = NO;
    }
    
    return [UIImage imageWithData:data];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 16) {
        self.selectedIndex = indexPath.item;
        if (indexPath.item == self.thumbnailArray.count) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"相册选取",nil];
            [actionSheet showInView:self.view];
        }else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看图片",@"删除图片",nil];
            [actionSheet showInView:self.view];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.selectedIndex == self.thumbnailArray.count) {
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
            IDMPhotoBrowser *browser = [IDMPhotoBrowser controllerWithPhotos:[IDMPhoto photosWithImages:self.photoArray]];
            [browser setInitialPageIndex:self.selectedIndex];
            [self presentViewController:browser animated:YES completion:nil];
        }
        if (buttonIndex == 1) {
            [self.photoArray removeObjectAtIndex:self.selectedIndex];
            [self.thumbnailArray removeObjectAtIndex:self.selectedIndex];
            [self.collectionView reloadData];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    image = [self scaleToSize:image];
    [self.thumbnailArray addObject:image];
    [self.photoArray addObject:[self scaleToSize:image]];
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


@end
