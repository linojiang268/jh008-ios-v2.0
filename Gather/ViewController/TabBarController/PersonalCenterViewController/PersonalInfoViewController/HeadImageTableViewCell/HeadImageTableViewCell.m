//
//  HeadImageTableViewCell.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "HeadImageTableViewCell.h"


@interface HeadImageTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@end

@implementation HeadImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    circle_view(self.headImage);
}

- (void)setImage:(UIImage *)image {
    [self.headImage setImage:image];
}

- (void)setImageStringURL:(NSString *)imageStringURL {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageStringURL] placeholderImage:placeholder_image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
