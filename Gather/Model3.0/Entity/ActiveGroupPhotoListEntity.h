//
//  ActiveGroupPhotoListEntity.h
//  Gather
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "BaseEntity.h"
#import "FullUserInfoEntity.h"

@protocol MemberPhotoEntity <NSObject>

@end

@interface SponsorPhotoVideoEntity : OptionalJSONModel

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *sum;
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *create_time;

@end

@interface MemberPhotoEntity : SponsorPhotoVideoEntity

@property (nonatomic, strong) SimpleUserInfoEntity *user;

@end

@interface ActiveGroupPhotoListEntity : BaseEntity

@property (nonatomic, strong) SponsorPhotoVideoEntity *busi_photo;
@property (nonatomic, strong) SponsorPhotoVideoEntity *busi_video;

@property (nonatomic, strong) NSArray<MemberPhotoEntity> *albums;
@property (nonatomic, assign) int my_album_id;
@property (nonatomic, assign) int total_num;

@end
