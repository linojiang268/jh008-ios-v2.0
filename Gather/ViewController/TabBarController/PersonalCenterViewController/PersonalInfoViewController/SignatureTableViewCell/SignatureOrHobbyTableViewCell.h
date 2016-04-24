//
//  SignatureTableViewCell.h
//  Gather
//
//  Created by apple on 14/12/29.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CellType) {
    CellTypeHobby = 1,
    CellTypeSignature = 2,
};

@interface SignatureOrHobbyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

- (void)setCellType:(CellType)cellType;

@end
