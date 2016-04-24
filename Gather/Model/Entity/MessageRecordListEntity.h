//
//  MessageRecord.h
//  Gather
//
//  Created by apple on 15/1/8.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"

@protocol MessageRecordEntity <NSObject>

@end

@interface MessageRecordEntity : OptionalJSONModel

@property (nonatomic, assign) int u_id;
@property (nonatomic, assign) int contact_id;
@property (nonatomic, assign) int role;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;

@end

@interface MessageRecordListEntity : BaseEntity

@property (nonatomic, assign) int total_num;
@property (nonatomic, strong) NSArray<MessageRecordEntity> *messages;

@end
