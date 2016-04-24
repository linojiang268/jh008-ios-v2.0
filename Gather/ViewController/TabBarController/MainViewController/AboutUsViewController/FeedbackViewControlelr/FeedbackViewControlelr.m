//
//  FeedbackViewControlelr.m
//  Gather
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "FeedbackViewControlelr.h"
#import "PublishPhotoCollectionViewCell.h"
#import "SelectImageViewController.h"
#import "IDMPhotoBrowser.h"
#import "Network+UploadFile.h"
#import "Network+AboutUs.h"

@interface FeedbackViewControlelr ()<UITextViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *characterNumberLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *imageIds;
@property (nonatomic, strong) SelectImageViewController *selectImageViewController;

@end

@implementation FeedbackViewControlelr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [[NSMutableArray alloc] init];
    self.imageIds = [[NSMutableArray alloc] init];
    
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
        [wself verify];
    }]];
}

- (void)verify {
    if (self.textView.text.length <= 0) {
        alert(nil, @"请输入您的反馈意见");
        return;
    }
    
    if (self.textView.text.length > 240) {
        alert(nil, @"内容长度超出最大限制");
        return;
    }
    
    SHOW_LOAD_HUD;
    if (self.photos.count > 0) {
        [self uploadPhotoWithIndex:0];
    }else {
        [self commit];
    }
}

- (void)commit {
    
    __weak typeof(self) wself = self;
    
    CLLocationCoordinate2D coor = [Common getCurrentLocationCoordinate2D];
    [Network feedbackWithCityId:[Common getCurrentCityId] content:self.textView.text imgIds:self.imageIds lon:coor.longitude lat:coor.latitude locationAddress:[Common getCurrentFullAddress] success:^(id response) {
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
    UIImage *image = self.photos[index];
    [Network uploadPhotoWithImage:image compressionQuality:1 success:^(id response) {
        NSUInteger imgId = [response[@"body"][@"img_id"] intValue];
        [wself.imageIds addObject:@(imgId)];
        NSUInteger nextIndex = index + 1;
        if (nextIndex >= wself.photos.count) {
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


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.characterNumberLabel.text = [NSString stringWithFormat:@"%d/200",textView.text.length];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.photos.count >= 1) {
        return 1;
    }
    return self.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublishPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item == self.photos.count && self.photos.count < 1) {
        [cell setImage:image_with_name(@"btn_apple_star_add_picture")];
    } else {
        [cell setImage:self.photos[indexPath.item]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.item;
    if (indexPath.item == self.photos.count) {
        __weak typeof(self) wself = self;
        self.selectImageViewController = [[SelectImageViewController alloc] initWithViewController:self getType:GetImageTypeOriginal done:^(UIImage *image) {
            if (image) {
                [wself.photos addObject:[wself scaleToSize:image]];
                [wself.collectionView reloadData];
            }
        }];
        [self.selectImageViewController open];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看图片",@"删除图片",nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
            IDMPhotoBrowser *browser = [IDMPhotoBrowser controllerWithPhotos:[IDMPhoto photosWithImages:self.photos]];
            [browser setInitialPageIndex:self.selectedIndex];
            [self presentViewController:browser animated:YES completion:nil];
    }
    if (buttonIndex == 1) {
        [self.photos removeObjectAtIndex:self.selectedIndex];
        [self.collectionView reloadData];
    }
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
