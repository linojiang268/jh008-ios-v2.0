//
//  PersonalDynamicTableViewCell.m
//  Gather
//
//  Created by apple on 15/1/16.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "PersonalDynamicTableViewCell.h"
#import "DynamicPhotoCollectionViewCell.h"

@interface PersonalDynamicTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (nonatomic, copy) void(^commentHandler)(void);
@property (nonatomic, copy) void(^deleteHandler)(void);
@property (nonatomic, copy) void(^didTapImageViewHandler)(id sender, UIImage *scaleImage, NSUInteger index);

@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, strong) DynamicEntity *dynamicInfo;

@property (nonatomic, strong) NSArray *imgs;

@end

@implementation PersonalDynamicTableViewCell

- (void)awakeFromNib {
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    CGFloat itemWidthAndHeight = (CGRectGetWidth(self.photoView.frame) - 10) / 3;
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
    
    self.contentLabel.textColor = color_with_hex(kColor_808080);
}

- (void)setTimeStringOrHideWithCurrentTime:(NSString *)curerntTime previousTime:(NSString *)previousTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:curerntTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSDateComponents *todayComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDate *today = [calendar dateFromComponents:todayComponents];
    NSDate *currentDate = [calendar dateFromComponents:dateComponents];
    
    if([today isEqualToDate:currentDate]) {
        self.timeLabel.hidden = YES;
        return;
    }
    if (previousTime) {
        NSDate *previousDate = [dateFormatter dateFromString:previousTime];
        NSDateComponents *previousComponents = [calendar components:unitFlags fromDate:previousDate];
        previousDate = [calendar dateFromComponents:previousComponents];
        if([currentDate isEqualToDate:previousDate]) {
            self.timeLabel.hidden = YES;
            return;
        }
    }
    
    if (todayComponents.day - dateComponents.day == 1 && todayComponents.year == dateComponents.year && todayComponents.month == dateComponents.month) {
        self.timeLabel.attributedText = [[NSAttributedString alloc] initWithString:@"昨天" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:22]}];
    } else if (todayComponents.day - dateComponents.day == 2  && todayComponents.year == dateComponents.year && todayComponents.month == dateComponents.month) {
        self.timeLabel.attributedText = [[NSAttributedString alloc] initWithString:@"前天" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:22]}];
    } else {
        
        NSString *month = @"";
        switch (dateComponents.month) {
            case 1:
                month = @"一月";
                break;
            case 2:
                month = @"二月";
                break;
            case 3:
                month = @"三月";
                break;
            case 4:
                month = @"四月";
                break;
            case 5:
                month = @"五月";
                break;
            case 6:
                month = @"六月";
                break;
            case 7:
                month = @"七月";
                break;
            case 8:
                month = @"八月";
                break;
            case 9:
                month = @"九月";
                break;
            case 10:
                month = @"十月";
                break;
            case 11:
                month = @"十一月";
                break;
            case 12:
                month = @"十二月";
                break;
        }
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",dateComponents.day] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}]];
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:month attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}]];
        self.timeLabel.attributedText = attString;
    }
    self.timeLabel.hidden = NO;
}

- (void)setLocalCurrentValue:(DynamicCacheEntity *)value previousTime:(NSString *)previousTime {
    
    self.dynamicInfo = nil;
    
    DynamicCacheEntity *entity = value;
    
    [self.contentLabel setText:entity.content];
    [self setTimeStringOrHideWithCurrentTime:value.create_time previousTime:previousTime];
    
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

- (void)setCurrentValue:(DynamicEntity *)value previousTime:(NSString *)previousTime {
    
    DynamicEntity *entity = value;
    
    [self showDeleteButtonWithUserId:entity.author_id];
    [self.contentLabel setText:entity.content];
    [self setTimeStringOrHideWithCurrentTime:value.create_time previousTime:previousTime];
    if (entity.comment_num > 0) {
        [self.commentButton setTitle:[NSString stringWithFormat:@"评论%d",entity.comment_num] forState:UIControlStateNormal];
    }else {
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
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
        [self.photoViewHeight setConstant:0];
        [self.photoView setHidden:YES];
    }
    [self.collectionView reloadData];
    [self updateConstraintsIfNeeded];
}

- (void)showDeleteButtonWithUserId:(NSUInteger)userId {
    
    if ([Common isLogin] && [Common getCurrentUserId] > 0 && [Common getCurrentUserId] == userId) {
        self.deleteButton.hidden = NO;
    }
    self.deleteButton.hidden = YES;
}

- (void)setCommentButtonTitle:(NSString *)title {
    [self.commentButton setTitle:title forState:UIControlStateNormal];
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
        
        [cell setImageURL:thumbnail_url(img.img_url, CGRectGetWidth(cell.imageView.bounds), CGRectGetHeight(cell.imageView.bounds))];
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
