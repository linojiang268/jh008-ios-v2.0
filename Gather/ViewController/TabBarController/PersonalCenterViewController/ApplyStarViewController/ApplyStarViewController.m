//
//  ApplyStarViewController.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ApplyStarViewController.h"
#import "TagItemCell.h"
#import "Network+CityList.h"
#import "Network+Tag.h"
#import "Network+UploadFile.h"
#import "Network+ApplyStar.h"
#import <CTAssetsPickerController.h>
#import "PublishPhotoCollectionViewCell.h"
#import "IDMPhotoBrowser.h"

@interface ApplyStarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cityCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *activeTagCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *individualityCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) CityListEntity *cityListEntity;
@property (nonatomic,strong) NSMutableArray *selectedCity;

@property (nonatomic,strong) NSMutableArray *categoryTagList;
@property (nonatomic,strong) NSMutableArray *selectedActiveTag;

@property (nonatomic,strong) NSMutableArray *individualityTagList;
@property (nonatomic,strong) NSMutableArray *selectedIndividualityTag;

@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *introTextField;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *thumbnailArray;
@property (nonatomic, strong) UIImagePickerController *cameraController;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *imageIds;
@property (nonatomic, assign) BOOL isScale;

@end

@implementation ApplyStarViewController

- (UIImagePickerController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[UIImagePickerController alloc] init];
        _cameraController.delegate = self;
    }
    return _cameraController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedCity = [[NSMutableArray alloc] init];
    self.categoryTagList = [[NSMutableArray alloc] init];
    self.selectedActiveTag = [[NSMutableArray alloc] init];
    self.individualityTagList = [[NSMutableArray alloc] init];
    self.selectedIndividualityTag = [[NSMutableArray alloc] init];
    self.imageIds = [[NSMutableArray alloc] init];
    self.photoArray = [[NSMutableArray alloc] init];
    self.thumbnailArray = [[NSMutableArray alloc] init];
    
    [self getCityListInfo];
}

- (void)getCityListInfo {
    
    if ([[Common getCacheCityList].cities count] > 0) {
        self.cityListEntity = [Common getCacheCityList];
        [self.cityCollectionView reloadData];
        [self.tableView reloadData];
        [self getTag];
    }else {
        [SVProgressHUD showErrorWithStatus:@"正在获取城市信息"];
        __weak typeof(self) wself = self;
        [Network getCityListWithSuccess:^(BaseEntity *entity) {
            wself.cityListEntity = (CityListEntity *)entity;
            [wself.cityCollectionView reloadData];
            [wself.tableView reloadData];
            [wself getTag];
            DISMISS_HUD;
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"获取城市信息失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)getTag {
    [self getCategoryTagListInfo];
    [self getIndividualityTagListInfo];
}

- (void)getCategoryTagListInfo {
    if ([Common getCategoryList].tags.count > 0) {
        [self.categoryTagList addObjectsFromArray:[Common getCategoryList].tags];
        [self.activeTagCollectionView reloadData];
        [self.tableView reloadData];
    }else {
        [SVProgressHUD showInfoWithStatus:@"正在获取标签"];
        __weak typeof(self) wself = self;
        [Network getTagListWithType:TagTypeCategory page:1 size:kSize success:^(TagListEntity *entity) {
            TagListEntity *tagList = entity;
            [wself.categoryTagList addObjectsFromArray:tagList.tags];
            [wself.activeTagCollectionView reloadData];
            [wself.tableView reloadData];
            
            if (wself.individualityTagList.count > 0 && self.cityListEntity.cities.count > 0) {
                DISMISS_HUD;
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"标签获取失败"];
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)getIndividualityTagListInfo {
    if ([Common getIndividualityTagList].tags.count > 0) {
        [self.individualityTagList addObjectsFromArray:[Common getIndividualityTagList].tags];
        [self.individualityCollectionView reloadData];
        [self.tableView reloadData];
    }else {
        [SVProgressHUD showInfoWithStatus:@"正在获取标签"];
        __weak typeof(self) wself = self;
        [Network getTagListWithType:TagTypeIndividuality page:1 size:kSize success:^(TagListEntity *entity) {
            TagListEntity *tagList = entity;
            [wself.individualityTagList addObjectsFromArray:tagList.tags];
            [wself.individualityCollectionView reloadData];
            [wself.tableView reloadData];
            
            if (wself.categoryTagList.count > 0 && self.cityListEntity.cities.count > 0) {
                DISMISS_HUD;
            }
        } failure:^(NSString *errorMsg, StatusCode code) {
            [SVProgressHUD showErrorWithStatus:@"标签获取失败"];
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)OK:(id)sender {
    [self verify];
}

- (void)verify {

    if (string_is_empty(self.realNameTextField.text)) {
        alert(nil, @"请输入姓名");
        return;
    }
    if (![self.realNameTextField.text isChinese]) {
        alert(nil, @"姓名只能输入中文");
        return;
    }
    if ([self.realNameTextField.text length] > 4) {
        alert(nil, @"姓名长度最多为4位");
        return;
    }
    if (string_is_empty(self.contactPhoneTextField.text)) {
        alert(nil, @"请输入联系电话");
        return;
    }
    if (![self.contactPhoneTextField.text validateMobile]) {
        alert(nil, @"请输入正确的电话号码");
        return;
    }
    
    if (string_is_empty(self.emailTextField.text)) {
        alert(nil, @"请输入邮箱");
        return;
    }
    if (![self.emailTextField.text validateEmail]) {
        alert(nil, @"请输入正确邮箱");
        return;
    }
    if (self.selectedCity.count <= 0) {
        alert(nil, @"请至少选择一个城市");
        return;
    }
    if (string_is_empty(self.introTextField.text)) {
        alert(nil, @"请输入个人简介");
        return;
    }
    if ([self.introTextField.text length] > 100) {
        alert(nil, @"个人简介只能输入100字以内");
        return;
    }
    if (self.thumbnailArray.count <= 0) {
        alert(nil, @"请上传照片");
        return;
    }
    SHOW_LOAD_HUD;
    [self uploadPhotoWithIndex:0];
}

- (void)commit {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network applyStarWithRealName:self.realNameTextField.text contactPhone:self.contactPhoneTextField.text email:self.emailTextField.text intro:self.introTextField.text cityIds:self.selectedCity activeTagIds:self.selectedActiveTag individualityTagIds:self.selectedIndividualityTag imgIds:self.imageIds lon:[Common getCurrentLocationCoordinate2D].longitude lat:[Common getCurrentLocationCoordinate2D].latitude address:[Common getCurrentCityName] success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"申请成功，等待审核"];
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMsg, StatusCode code) {
        DISMISS_HUD;
        [[[BlockAlertView alloc] initWithTitle:nil message:@"申请失败" handler:^(UIAlertView *alertView, NSUInteger index) {
            
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
        [[[BlockAlertView alloc] initWithTitle:nil message:@"申请失败" handler:^(UIAlertView *alertView, NSUInteger index) {
            if (index) {
                [wself uploadPhotoWithIndex:index];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"重试"] show];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self verify];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) {
        return YES;
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger count = 0;
    if (indexPath.section == 1) {
        count = self.cityListEntity.cities.count;
    }
    if (indexPath.section == 2) {
        count = self.categoryTagList.count;
    }
    if (indexPath.section == 3) {
        count = self.individualityTagList.count;
    }
    if (count > 0) {
        NSUInteger row = count / 3;
        int remainder = count % 3;
        if (remainder > 0) {
            return (row + 1) * 38;
        }else {
            return row * 38;
        }
    }
    if (indexPath.section == 4) {
        return 150;
    }
    if (indexPath.section == 5) {
        return 110;
    }
    
    return 44;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tag == 2) {
        return self.cityListEntity.cities.count;
    }
    if (collectionView.tag == 4) {
        return self.categoryTagList.count;
    }
    if (collectionView.tag == 8) {
        return self.individualityTagList.count;
    }
    if (collectionView.tag == 16) {
        if (self.thumbnailArray.count >= 3) {
            return 3;
        }
        return self.thumbnailArray.count + 1;
    }
    
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TagItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    __weak typeof(self) wself = self;
    if (collectionView.tag == 2) {
        CityEntity *item = self.cityListEntity.cities[indexPath.item];
        [cell setTitle:item.name];
        [cell setTag:item.id];
        [cell setSelectedHander:^BOOL(NSUInteger tag) {
            if (wself.selectedCity.count >= 3) {
                alert(nil, @"最多只能选择3个城市");
                return NO;
            }else {
                [wself.selectedCity addObject:@(tag)];
                return YES;
            }
        } deselectedHandler:^BOOL(NSUInteger tag) {
            if (wself.selectedCity.count >= 2) {
                [wself.selectedCity removeObject:@(tag)];
                return NO;
            }else {
                alert(nil, @"至少选择1个城市");
                return YES;
            }
        }];
    }
    if (collectionView.tag == 4) {
        TagEntity *item = self.categoryTagList[indexPath.item];
        [cell setTitle:item.name];
        [cell setTag:item.id];
        [cell setSelectedHander:^BOOL(NSUInteger tag) {
            if (wself.selectedActiveTag.count >= 2) {
                alert(nil, @"最多只能选择2个类别标签");
                return NO;
            }else {
                [wself.selectedActiveTag addObject:@(tag)];
                return YES;
            }
        } deselectedHandler:^BOOL(NSUInteger tag) {
            if (wself.selectedActiveTag.count >= 2) {
                [wself.selectedActiveTag removeObject:@(tag)];
                return NO;
            }else {
                alert(nil, @"至少选择1个类别标签");
                return YES;
            }
        }];
    }
    if (collectionView.tag == 8) {
        TagEntity *item = self.individualityTagList[indexPath.item];
        [cell setTitle:item.name];
        [cell setTag:item.id];
        [cell setSelectedHander:^BOOL(NSUInteger cityId) {
            if (wself.selectedIndividualityTag.count >= 3) {
                alert(nil, @"最多只能选择3个个性标签");
                return NO;
            }else {
                [wself.selectedIndividualityTag addObject:@(cityId)];
                return YES;
            }
        } deselectedHandler:^BOOL(NSUInteger cityId) {
            if (wself.selectedIndividualityTag.count > 0) {
                [wself.selectedIndividualityTag removeObject:@(cityId)];
            }
            return NO;
        }];
    }
    
    if (collectionView.tag == 16) {
        PublishPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
        
        if (indexPath.item == self.thumbnailArray.count && self.thumbnailArray.count < 3) {
            [cell setImage:image_with_name(@"btn_apple_star_add_picture")];
        } else {
            [cell setImage:self.thumbnailArray[indexPath.item]];
        }
        
        return cell;
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
