//
//  SignatureTableViewCell.m
//  Gather
//
//  Created by apple on 14/12/29.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "SignatureOrHobbyTableViewCell.h"

@interface SignatureOrHobbyTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsTitleWidth;

@end

@implementation SignatureOrHobbyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellType:(CellType)cellType {
    switch (cellType) {
        case CellTypeHobby:
            self.titleLabel.text = @"爱好";
            self.subTitleLabel.text = @"";
            self.constraintsTitleWidth.constant = 34;
            self.tag = 2;
            break;
        case CellTypeSignature:
            self.titleLabel.text = @"个性签名";
            self.constraintsTitleWidth.constant = 64;
            self.tag = 3;
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
