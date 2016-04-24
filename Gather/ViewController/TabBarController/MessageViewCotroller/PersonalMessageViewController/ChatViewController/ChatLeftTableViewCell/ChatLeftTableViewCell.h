//
//  ChatLeftTableViewCell.h
//  Gather
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatLeftTableViewCell : UITableViewCell

- (void)setHeadImageURL:(NSString *)imageURL;
- (void)setContent:(NSString *)text;
- (void)setTime:(NSString *)stringTime;

- (void)hideTimeView;

- (void)menuCopyAction:(void(^)(void))copyHandler deleteAction:(void(^)(void))deleteHandler;

@end
