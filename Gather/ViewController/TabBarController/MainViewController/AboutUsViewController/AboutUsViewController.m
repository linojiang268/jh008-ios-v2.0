//
//  AboutUsViewController.m
//  Gather
//
//  Created by apple on 15/2/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsCollectionViewCell.h"
#import "FeedbackViewControlelr.h"
#import "AboutUsWebController.h"

@interface AboutUsViewController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *imgs;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.imgs = @[@"about_login",@"about_us",@"about_copyright",@"about_function_introduce",@"about_star_recruit",@"about_cooperation",@"about_feedback",@"about_update",@"about_website"];
//    self.titles = @[@"商户登陆",@"关于我们",@"版权声明",@"功能介绍",@"招募达人",@"业务合作",@"问题反馈",@"软件更新",@"官方网站"];

//    self.imgs = @[@"about_us",@"about_copyright",@"about_function_introduce",@"about_star_recruit",@"about_cooperation",@"about_feedback",@"about_update",@"about_website"];
//    self.titles = @[@"关于我们",@"版权声明",@"功能介绍",@"招募达人",@"业务合作",@"问题反馈",@"软件更新",@"官方网站"];
    self.imgs = @[@"about_us",@"about_copyright",@"about_function_introduce",@"about_star_recruit",@"about_cooperation",@"about_feedback",@"about_website"];
    self.titles = @[@"关于我们",@"版权声明",@"功能介绍",@"招募达人",@"业务合作",@"问题反馈",@"官方网站"];
    
    self.topView.backgroundColor = color_clear;
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.borderWidth = 0.5;
    self.topView.layer.borderColor = [color_with_hex(kColor_c9c9c9) CGColor];
    self.collectionView.backgroundColor = color_clear;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat itemWidthAndHeight = (CGRectGetWidth(self.collectionView.bounds) / 3) - 2;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 2;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.footerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), 60);
    layout.itemSize = CGSizeMake(itemWidthAndHeight, itemWidthAndHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AboutUsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell.titleLabel setText:self.titles[indexPath.item]];
    [cell.imageView setImage:image_with_name(self.imgs[indexPath.item])];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *urlSuffix = @"";
    
    int index = indexPath.item + 1;
    switch (index) {
        case 0:
        {
            urlSuffix = @"businessLogin";
        }
            break;
        case 1:
        {
            urlSuffix = @"aboutUs";
        }
            break;
        case 2:
        {
            urlSuffix = @"copyrightStatement";
        }
            break;
        case 3:
        {
            urlSuffix = @"functionIntroduction";
        }
            break;
        case 4:
        {
            urlSuffix = @"vipRecruit";
        }
            break;
        case 5:
        {
            urlSuffix = @"businessCooperation";
        }
            break;
        case 6:
        {
            FeedbackViewControlelr *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Feedback"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 7:
        {
            urlSuffix = @"officialWebsite";
        }
            break;
    }
    
    if (index == 6) {
        return;
    }
    
    AboutUsWebController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsWeb"];
    controller.urlSuffixString = urlSuffix;
    controller.title = self.titles[indexPath.item];
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
