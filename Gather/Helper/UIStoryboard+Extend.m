//
//  UIStoryboard+Extend.m
//  Gather
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "UIStoryboard+Extend.h"

@implementation UIStoryboard (Extend)

+ (instancetype)mainStoryboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (instancetype)dynamicStoryboard {
    return [UIStoryboard storyboardWithName:@"Dynamic" bundle:nil];
}

+ (instancetype)messageStoryboard {
    return [UIStoryboard storyboardWithName:@"Message" bundle:nil];
}

+ (instancetype)personalCenterStoryboard {
    return [UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil];
}

+ (instancetype)photoCellControllerStoryboard {
    return [UIStoryboard storyboardWithName:@"PhotoCellController" bundle:nil];
}

+ (instancetype)activeGroupStoryboard {
    return [UIStoryboard storyboardWithName:@"Group" bundle:nil];
}

+ (instancetype)clubStoryboard {
    return [UIStoryboard storyboardWithName:@"Club" bundle:nil];
}

@end
