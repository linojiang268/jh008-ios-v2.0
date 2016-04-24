//
//  DynamicPhotoCollectionViewCell.h
//  Gather
//
//  Created by apple on 15/1/13.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicPhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)setImageURL:(NSString *)url;

@end
