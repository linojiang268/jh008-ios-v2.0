//
//  DynamicTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "DynamicTableViewCell.h"
#import "DynamicPhotoCollectionViewCell.h"
#import "FullUserInfoEntity.h"

@interface DynamicTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishButtonWidth;

@property (nonatomic, copy) void(^republishHandler)(void);
@property (nonatomic, copy) void(^commentHandler)(void);
@property (nonatomic, copy) void(^deleteHandler)(void);
@property (nonatomic, copy) void(^didTapImageViewHandler)(id sender, UIImage *scaleImage, NSUInteger index);

@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, strong) DynamicEntity *dynamicInfo;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, copy) void(^headImageTapHandler)(void);

@end

@implementation DynamicTableViewCell

- (void)awakeFromNib {

    circle_view(self.headImage);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    CGFloat itemWidthAndHeight = ((CGRectGetWidth([[UIScreen mainScreen] bounds]) - 100) - 10) / 3;
    self.itemHeight = itemWidthAndHeight;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake(itemWidthAndHeight, itemWidthAndHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    [self.photoViewHeight setConstant:itemWidthAndHeight];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DynamicPhotoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    self.nicknameLabel.textColor = color_with_hex(kColor_6e7378);
    self.contentLabel.textColor = color_with_hex(kColor_8e949b);
    self.timeLabel.textColor = color_with_hex(0xa5aeb5);
    [self.publishButton setTitleColor:color_with_hex(kColor_808080) forState:UIControlStateNormal];
    [self.publishButton setHidden:YES];
    
    self.headImage.userInteractionEnabled = YES;
    [self.headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTap)]];
}

- (void)setValue:(id)value user:(SimpleUserInfoEntity *)user {
    
    DynamicEntity *entity = value;

    if (entity.user) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:entity.user.head_img_url] placeholderImage:placeholder_image];
        [self.nicknameLabel setText:entity.user.nick_name];
    }else if(user) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:user.head_img_url] placeholderImage:placeholder_image];
        [self.nicknameLabel setText:user.nick_name];
    }else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[[Common getSelfUserInfo].head_img_url stringByAppendingFormat:@"@%fw_%fh_1e_0c_50Q_1x.jpg",self.itemHeight,self.itemHeight]] placeholderImage:placeholder_image];
        [self.nicknameLabel setText:[Common getSelfUserInfo].nick_name];
    }
    
    [self.contentLabel setText:entity.content];
    [self.timeLabel setText:[entity.create_time dateString]];
    if (entity.comment_num > 0) {
        [self.commentButton setTitle:[NSString stringWithFormat:@"评论%d",entity.comment_num] forState:UIControlStateNormal];
    }else {
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    }
   
    if (entity.user.id != [Common getCurrentUserId]) {
        self.deleteButton.hidden = YES;
    }else {
        self.deleteButton.hidden = NO;
    }
    
    if (entity.imgs.total_num > 0) {
        self.dynamicInfo = entity;
        
        int row = self.dynamicInfo.imgs.total_num / 3;
        if (self.dynamicInfo.imgs.total_num % 3 > 0) {
            row += 1;
        }
        
        [self.photoView setHidden:NO];
        [self.photoViewHeight setConstant:self.itemHeight * row + ((row - 1) * 5)];
    }else {
        [self.photoViewHeight setConstant:-15];
        [self.photoView setHidden:YES];
    }
    [self.publishButton setHidden:YES];
    [self.publishButtonWidth setConstant:0];
    [self.collectionView reloadData];
    [self updateConstraintsIfNeeded];
}

- (void)setPublishValue:(id)value {
    
    self.dynamicInfo = nil;
    
    DynamicCacheEntity *entity = value;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[Common getSelfUserInfo].head_img_url] placeholderImage:placeholder_image];
    [self.nicknameLabel setText:[Common getSelfUserInfo].nick_name];

    [self.contentLabel setText:entity.content];
    [self.timeLabel setText:[entity.create_time dateString]];
    [self.deleteButton setHidden:NO];
    
    if (entity.status == 1) {
        [self.publishButton setTitle:@"发布中" forState:UIControlStateNormal];
    }else if (entity.status == 2) {
        [self.publishButton setTitle:@"重发" forState:UIControlStateNormal];
    }
    [self.publishButton setHidden:NO];
    [self.publishButtonWidth setConstant:40];
    
    NSArray *imgs = [entity.imgNames componentsSeparatedByString:@"|"];
    
    if (imgs.count > 0) {
        
        self.imgs = imgs;
        
        int row = imgs.count / 3;
        if (imgs.count % 3 > 0) {
            row += 1;
        }
        
        [self.photoView setHidden:NO];
        [self.photoViewHeight setConstant:self.itemHeight * row + ((row - 1) * 5)];
    }else {
        [self.photoViewHeight setConstant:0];
        [self.photoView setHidden:YES];
    }
    [self.collectionView reloadData];
    [self updateConstraintsIfNeeded];
}

- (void)setCommentButtonTitle:(NSString *)title {
    [self.commentButton setTitle:title forState:UIControlStateNormal];
}

- (void)headImageTap {
    if (self.headImageTapHandler) {
        self.headImageTapHandler();
    }
}

- (void)setHeadImageTapHandler:(void (^)(void))headImageTapHandler
{
    _headImageTapHandler = headImageTapHandler;
}

- (void)republish:(void(^)(void))handler {
    self.republishHandler = handler;
}

- (void)deleteHandler:(void(^)(void))handler {
    self.deleteHandler = handler;
}

- (void)commentHandler:(void(^)(void))handler {
    self.commentHandler = handler;
}

- (void)didTapImageViewHandler:(void(^)(id sender, UIImage *scaleImage, NSUInteger index))handler {
    self.didTapImageViewHandler = handler;
}

- (IBAction)republishButtonClick:(id)sender {
    if (self.republishHandler) {
        self.republishHandler();
    }
}

- (IBAction)deleteButtonClick:(id)sender {
    if (self.deleteHandler) {
        self.deleteHandler();
    }
}
- (IBAction)commentButtonClick:(id)sender {
    if (self.commentHandler) {
        self.commentHandler();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.dynamicInfo) {
        return self.dynamicInfo.imgs.total_num;
    }
    return self.imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DynamicPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (self.dynamicInfo) {
        Img *img = self.dynamicInfo.imgs.imgs[indexPath.item];
        
        [cell setImageURL:img.img_url];
    }else {
        
        [cell.imageView setImage:PUBLISH_IMAGE_WITH_NAME(self.imgs[indexPath.item])];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didTapImageViewHandler) {
        DynamicPhotoCollectionViewCell *cell = (DynamicPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        self.didTapImageViewHandler(cell, cell.imageView.image, indexPath.item);
    }
}



@end
