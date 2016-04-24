//
//  ActiveApplyTableViewCell30.m
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "ActiveApplyTableViewCell30.h"

@interface ActiveApplyTableViewCell30 ()

@property (readwrite, nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation ActiveApplyTableViewCell30

@synthesize reuseIdentifier = _reuseIdentifier;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = color_with_hex(kColor_6e7378);
    self.textFieldView.textColor = color_with_hex(kColor_8e949b);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
