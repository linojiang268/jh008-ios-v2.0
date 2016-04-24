//
//  UserInfoEntity.m
//  Gather
//
//  Created by apple on 14/12/30.
//  Copyright (c) 2014年 zero2all. All rights reserved.
//

#import "FullUserInfoEntity.h"

@implementation SimpleUserInfoEntity

- (int)is_shield {
    if (_is_shield == 1 || _status == 1) {
        return 1;
    }
    return 0;;
}

@end

@implementation FullUserInfoEntity

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    
    if (dict.count == 3) {
        
        NSDictionary *body = [dict objectForKey:@"body"][@"user"];
        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict];
        [temp removeObjectForKey:@"body"];
        [temp addEntriesFromDictionary:body];
        self = [super initWithDictionary:temp error:err];
        if (self) {
            [Common saveSelfUserInfo:[self toDictionary]];
        }
    }else {
        self = [super initWithDictionary:dict error:err];
    }
    return self;
}

@end
