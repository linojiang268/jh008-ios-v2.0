//
//  TagItemCell.m
//  Gather
//
//  Created by apple on 15/1/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "TagItemCell.h"

@interface TagItemCell ()

@property (weak, nonatomic) IBOutlet UIButton *itemButton;

@property (nonatomic, copy) BOOL(^selectedHandler)(NSUInteger cityId);
@property (nonatomic, copy) BOOL(^deselectedHandler)(NSUInteger cityId);

@end

@implementation TagItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.itemButton.layer.masksToBounds = YES;
    self.itemButton.layer.cornerRadius = 3.0;
    self.itemButton.layer.borderWidth = 1;
    self.itemButton.layer.borderColor = [color_with_hex(kColor_ff9933) CGColor];
    self.itemButton.backgroundColor = color_clear;
    [self.itemButton setTitleColor:color_with_hex(kColor_ff9933) forState:UIControlStateNormal];
    //[self.itemButton setTitleColor:color_white forState:UIControlStateSelected];
    //self.itemButton.backgroundColor = color_with_hex(kColor_dbdbdb);
}

- (void)setItemSelected:(BOOL)selected {
    if (selected) {
        [self.itemButton setBackgroundColor:color_with_hex(kColor_ff9933)];
    }else {
        [self.itemButton setBackgroundColor:color_clear];//color_with_hex(kColor_dbdbdb)
    }
    [self.itemButton setSelected:selected];
}

- (IBAction)itemClick:(id)sender {
    
    BOOL select = self.itemButton.selected;
    
    if (!select && self.selectedHandler) {
       self.itemButton.selected = self.selectedHandler(self.tag);
    }
    if (select && self.deselectedHandler) {
       self.itemButton.selected = self.deselectedHandler(self.tag);
    }
    [self setItemSelected:self.itemButton.selected];
}

- (void)setTitle:(NSString *)title {
    [self.itemButton setTitle:title forState:UIControlStateNormal];
}

- (void)setSelectedHander:(BOOL(^)(NSUInteger tag))selectedHandler deselectedHandler:(BOOL(^)(NSUInteger tag))deselectedHandler {
    self.selectedHandler = selectedHandler;
    self.deselectedHandler = deselectedHandler;
}

@end
