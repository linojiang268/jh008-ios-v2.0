//
//  HobbyCollectionViewCell.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "HobbyCollectionViewCell.h"

@interface HobbyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *itemButton;

@end

@implementation HobbyCollectionViewCell

- (void)setTitle:(NSString *)title {
    [self.itemButton setTitle:title forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    [self.itemButton setSelected:YES];
}

- (IBAction)itemClick:(id)sender {
    [self setSelected:YES];
}

@end
