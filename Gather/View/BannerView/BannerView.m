//
//  BannerView.m
//  Gather
//
//  Created by Ray on 14-12-26.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "BannerView.h"

#import "BannerView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#define AUTOPLAYINTERVAL 3

#define OFFSET_X 7.0f
#define SPACE_V 5.0f
#define HEIGHT 50.0f
#define TEXT_COLOR [UIColor whiteColor]

@interface BannerView()<UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    UIImageView* _screen0;  // 第一屏
    UIImageView* _screen1;  // 第二屏
    UIImageView* _screen2;  // 第三屏
    
    NSInteger _currentPage;  // 当前显示第几页,从 0 开始计算
}

@property (nonatomic, copy) void(^handler)(UIImageView *imageView, NSUInteger index);

@end

@implementation BannerView

- (void)awakeFromNib
{
    [self myInit];
}

-(id)init{
    self = [super init];
    if(self){
        [self myInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self myInit];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame handler:(void (^)(UIImageView *imageView ,NSUInteger))handler{
    self = [super initWithFrame:frame];
    if (self) {
        [self setHandler:handler];
        [self myInit];
    }
    return  self;
}
- (id)initWithFrame:(CGRect)frame handler:(void (^)(UIImageView *imageView,NSUInteger index))handler imageItems:(NSArray *)items {
    self = [super initWithFrame:frame];
    if (self) {
        [self setHandler:handler];
        [self setImageItems:items];
        [self myInit];
        [self updateData];
    }
    return self;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode {
    _imageViewContentMode = imageViewContentMode;
    
    _screen0.contentMode = imageViewContentMode;
    _screen1.contentMode = imageViewContentMode;
    _screen2.contentMode = imageViewContentMode;
    
    _screen0.layer.masksToBounds = YES;
    _screen1.layer.masksToBounds = YES;
    _screen2.layer.masksToBounds = YES;
}

- (UIImage *)currentImage {
    return _screen1.image;
}

- (void)enventHandler:(void (^)(UIImageView *, NSUInteger))handler {
    [self setHandler:handler];
}

-(void)myInit{
    self.backgroundColor = [UIColor clearColor];
    self.showPageControl = YES;
    self.imageViewContentMode = UIViewContentModeScaleAspectFill;
    
    _placeholderImage = [UIImage imageNamed:@"banner_back"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;   // 不显示水平滚动条
    _scrollView.showsVerticalScrollIndicator = NO;     // 不显示垂直滚动条
    _scrollView.pagingEnabled = YES;            // 整页翻动
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 30, 0, 0);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*3,_scrollView.frame.size.height);  // 总共三屏数据
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0); // 显示第二屏
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:_scrollView];
    
    _pageControl=[[UIPageControl alloc]init];
    _pageControl.pageIndicatorTintColor = color_white;
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.hidden = !self.showPageControl;
    [self addSubview:_pageControl];
    
    _screen0 = [[UIImageView alloc] init];
    [_screen0 setFrame:CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height)];
    _screen0.tag=0;
    _screen0.userInteractionEnabled=YES;
    _screen0.contentMode = self.imageViewContentMode;
    [_scrollView addSubview:_screen0];
    
    _screen1 = [[UIImageView alloc] init];
    [_screen1 setFrame:CGRectMake(self.bounds.size.width, 0,self.bounds.size.width, self.bounds.size.height)];
    _screen1.tag=1;
    _screen1.userInteractionEnabled=YES;
    _screen1.contentMode = self.imageViewContentMode;
    [_scrollView addSubview:_screen1];
    
    _screen2 = [[UIImageView alloc] init];
    [_screen2 setFrame:CGRectMake(self.bounds.size.width*2, 0,self.bounds.size.width, self.bounds.size.height)];
    _screen2.tag=2;
    _screen2.userInteractionEnabled=YES;
    _screen2.contentMode = self.imageViewContentMode;
    [_scrollView addSubview:_screen2];
    
    UIImageView *_imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_mask.png"]];
    _imgView.backgroundColor = [UIColor redColor];
    _imgView.userInteractionEnabled = NO;
    _imgView.tag = 222;
    [self addSubview:_imgView];
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizerForDatailClick:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    tapGestureRecognize.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGestureRecognize];
}

-(void)setImageItems:(NSArray *)imageItems{
    _imageItems = imageItems;
    [self updateData];
}

// 根据 self.imageItems 更新 _pageControl 的宽度和页数，开启自动循环滚动
- (void)updateData{
    float pageControlWidth = self.imageItems.count*10.0f+40.f;
    float pagecontrolHeight = 20.0f;
    _pageControl.frame = CGRectMake((self.frame.size.width-pageControlWidth)/2,self.frame.size.height - 20, pageControlWidth, pagecontrolHeight);
    _pageControl.numberOfPages = self.imageItems.count;
    _pageControl.currentPage = 0;
    
    _currentPage = 0;
    [self update3Screens];   // 更新三屏数据
    
    // 显示第二屏数据
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    if(self.imageItems.count <= 1){
        _scrollView.userInteractionEnabled = NO;
        _pageControl.hidden = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchToNextPage) object:nil];
        return;
    }
    else{
        _scrollView.userInteractionEnabled = YES;
        _pageControl.hidden = !self.showPageControl;
        [self performSelector:@selector(switchToNextPage) withObject:nil afterDelay:AUTOPLAYINTERVAL];
    }
}

// 根据 _currentPage 来更新三屏的数据
-(void)update3Screens{
    if(self.imageItems.count == 0){
        
        [_screen0 setImage:nil];
        [_screen1 setImage:nil];
        [_screen2 setImage:nil];
        
        return;
    }
    [self updateScreen0];
    [self updateScreen1];
    [self updateScreen2];
}

-(void)updateScreen0{
    id info;
    if(_currentPage == 0){   // 当前页为第一页，所以第一屏数据应该为最后一页数据
        info = [self.imageItems objectAtIndex:self.imageItems.count-1];
    }
    else{
        info = [self.imageItems objectAtIndex:_currentPage-1];
    }
    [self updateScreen:_screen0 urlOrString:info];
}
-(void)updateScreen1{
    id info = [self.imageItems objectAtIndex:_currentPage];
    [self updateScreen:_screen1 urlOrString:info];
}
-(void)updateScreen2{
    id info;
    if(_currentPage == self.imageItems.count-1){    // 当前页为最后一页，所以第三屏数据应该为第一页数据
        info = [self.imageItems objectAtIndex:0];
    }
    else{
        info = [self.imageItems objectAtIndex:_currentPage+1];
    }
    [self updateScreen:_screen2 urlOrString:info];
}
-(void)updateScreen:(UIImageView*)screen urlOrString:(id)urlOrString{
    if([urlOrString isKindOfClass:[NSURL class]]){   // 如果是 NSURL 类，则展示网络图片，网络图片未下载下来时，显示 属性placeholderImage图片
        [screen sd_setImageWithURL:urlOrString placeholderImage:_placeholderImage];
    }
    else if([urlOrString isKindOfClass:[NSString class]]){
        NSString* str = urlOrString;
        if ([str hasPrefix:@"http://"]){     // 若是 NSString 类，并且 NSString 类是以 "http://" 开头的，将该NSString视为一个有效网络图片链接，如上。
            [screen sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:_placeholderImage];
        }
        else{                                // 若是 NSString 类，并且 NSString 类是不是以 "http://" 开头的，则将NSString视为一个有效本地图片名字，进行显示
            if(str.length > 0){
                [screen setImage:[UIImage imageNamed:str]];
            }
            else{
                [screen setImage:_placeholderImage];
            }
        }
    }else {
        [screen setImage:nil];
    }
}

// 跳转到下一页数据
-(void)switchToNextPage{
    // 正在拖动
    if(_scrollView.isDragging == true){
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchToNextPage) object:nil];
    
    // 滚到第三屏，
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*2, 0) animated:YES];
    // 在动画结束后，调用 [self update3Screens]方法，并无动画滚回第二屏
    _currentPage++;
    if(_currentPage >= self.imageItems.count){
        _currentPage = 0;
    }
    
    [self performSelector:@selector(switchToNextPage) withObject:nil afterDelay:AUTOPLAYINTERVAL];
}

- (void)singleTapGestureRecognizerForDatailClick:(UIGestureRecognizer*)gestureRecognizer
{
    if (_currentPage > -1 && _currentPage < self.imageItems.count) {
        if (self.handler) {
            self.handler(_screen1,_currentPage);
        }
    }
}


-(void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    _scrollView.contentSize = CGSizeMake(bounds.size.width*3,bounds.size.height);  // 总共三屏数据
    _screen0.frame = CGRectMake(0,0,bounds.size.width,bounds.size.height);
    _screen1.frame = CGRectMake(bounds.size.width,0,bounds.size.width,bounds.size.height);
    _screen2.frame = CGRectMake(bounds.size.width*2,0,bounds.size.width,bounds.size.height);
    [_scrollView setContentOffset:CGPointMake(bounds.size.width, 0) animated:NO];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _scrollView.contentSize = CGSizeMake(frame.size.width*3,frame.size.height);  // 总共三屏数据
    _screen0.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
    _screen1.frame = CGRectMake(frame.size.width,0,frame.size.width,frame.size.height);
    _screen2.frame = CGRectMake(frame.size.width*2,0,frame.size.width,frame.size.height);
    [_scrollView setContentOffset:CGPointMake(frame.size.width, 0) animated:NO];
}


#pragma mark - UIScrollViewDelegate
// 动画停止
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self update3Screens];
    // 无动画滚回第二屏
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    
    _pageControl.currentPage = _currentPage;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchToNextPage) object:nil];
    [self performSelector:@selector(switchToNextPage) withObject:nil afterDelay:AUTOPLAYINTERVAL];
}

// 手动拖动跳转并跳转动画结束后，会调用此方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(self.imageItems.count == 0){
        return;
    }
    if(scrollView.contentOffset.x < scrollView.bounds.size.width/2){  // 在第一屏
        _currentPage--;
        if(_currentPage < 0){
            _currentPage = self.imageItems.count-1;
        }
    }
    else if(scrollView.contentOffset.x > scrollView.bounds.size.width*1.5){   // 在第三屏
        _currentPage++;
        if(_currentPage >= self.imageItems.count){
            _currentPage = 0;
        }
    }
    
    [self update3Screens];
    // 无动画滚回第二屏
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    _pageControl.currentPage = _currentPage;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 只有在拖动时，才会实时调整 _pageControl.currentPage
    if(_scrollView.isDragging == false){
        return;
    }
    
    // 实时调整 _pageControl.currentPage
    NSInteger page = 1;
    if(scrollView.contentOffset.x < scrollView.bounds.size.width/2){  // 在第一屏
        page = 0;
    }
    else if(scrollView.contentOffset.x > scrollView.bounds.size.width*1.5){   // 在第三屏
        page = 2;
    }
    
    page = _currentPage+page-1;  // _pageControl 应该设置成的当前页数
    if(page < 0){
        page = self.imageItems.count-1;
    }
    else if(page >= self.imageItems.count){
        page = 0;
    }
    _pageControl.currentPage = page;
}//*/

@end