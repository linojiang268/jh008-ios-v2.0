//
//  BaseEntity.h
//  Gather
//
//  Created by Ray on 14-12-23.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import <JSONModel.h>

@interface StatusEntity : JSONModel

@property (nonatomic) int code;
@property (nonatomic,strong) NSString *msg;

@end

@interface BaseEntity : StatusEntity

@property (nonatomic, assign) int id;

@end

@interface OptionalJSONModel : JSONModel

@property (nonatomic, assign) int id;

@end

