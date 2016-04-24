//
//  StarCollectionViewCell.m
//  Gather
//
//  Created by apple on 15/1/28.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "StarCollectionViewCell.h"

@interface StarCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *blackView;

@end

@implementation StarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.blackView.alpha = 0.5;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}


@end
