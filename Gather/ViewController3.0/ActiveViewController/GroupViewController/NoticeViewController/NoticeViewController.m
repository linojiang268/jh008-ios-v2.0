//
//  NoticeViewController.m
//  Gather
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTitleTableViewCell.h"
#import "NoticeContentTableViewCell.h"
#import "Network+NewestNotice.h"
#import "NoticeHeaderView.h"
#import "ActiveNewestNoticeCacheEntity.h"

@interface NoticeViewController ()

@property (nonatomic, strong) NewestNoticeListEntity *noticeInfo;
@property (nonatomic, strong) NSMutableArray *expandSection;

@property (nonatomic, strong) NoticeHeaderView *searchView;

@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, assign) BOOL isSearch;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.expandSection = [[NSMutableArray alloc] init];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.searchView = [[NoticeHeaderView alloc] init];
    self.tableView.tableHeaderView = self.searchView;
    
    __weak typeof(self) wself = self;
    [self.searchView.searchButton addEvent:UIControlEventTouchUpInside handler:^(id sender) {
        [wself search];
    }];
}

- (void)search {
    [self.searchView.textFieldView resignFirstResponder];
    
    NSString *searchKey = self.searchView.textFieldView.text;
    
    if (string_is_empty(searchKey)) {
        self.isSearch = NO;
        [self.expandSection removeAllObjects];
        [self.tableView reloadDataIfEmptyShowCueWordsView];
    }else {
        NSArray *searchArray = [ActiveNewestNoticeCacheEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"subject CONTAINS %@ or descri CONTAINS %@",searchKey,searchKey]];
        self.searchResult = searchArray;
        self.isSearch = YES;
        [self.tableView reloadDataIfEmptyShowCueWordsView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestMenuInfo];
    [self.tableView reloadData];
}

- (void)requestMenuInfo {
    SHOW_LOAD_HUD;
    __weak typeof(self) wself = self;
    [Network getNewestNoticeListWithActiveId:self.activeId page:1 size:kActiveGroupSize success:^(NewestNoticeListEntity *entity) {
        DISMISS_HUD;
        wself.noticeInfo = entity;
        [wself compareLocal];
    } failure:^(NSString *errorMsg, StatusCode code) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)compareLocal {
    
    NSArray *localNoticeArray = [ActiveNewestNoticeCacheEntity MR_findAll];
    if (localNoticeArray.count > 0) {
        for (NewestNoticeEntity *entity in self.noticeInfo.act_notices) {
            entity.read = [[ActiveNewestNoticeCacheEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"id==%d",entity.id]] count] > 0 ? YES:NO;
        }
    }else {
        for (NewestNoticeEntity *entity in self.noticeInfo.act_notices) {
            ActiveNewestNoticeCacheEntity *cacheEntity = [ActiveNewestNoticeCacheEntity MR_createEntity];
            cacheEntity.id = entity.id;
            cacheEntity.subject = entity.subject;
            cacheEntity.descri = entity.descri;
            cacheEntity.create_time = entity.create_time;
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    }
    
    [self.tableView reloadDataIfEmptyShowCueWordsView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return self.searchResult.count;
    }
    return self.noticeInfo.act_notices.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.expandSection containsObject:@(section)]) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        NoticeTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([self.expandSection containsObject:@(indexPath.section)]) {
            cell.isExpand = YES;
        }else {
            cell.isExpand = NO;
        }
        
        if (self.isSearch) {
            ActiveNewestNoticeCacheEntity *entity = [self.searchResult objectAtIndex:indexPath.section];
            cell.titleLabel.text = entity.subject;
        }else {
            NewestNoticeEntity *entity = [self.noticeInfo.act_notices objectAtIndex:indexPath.section];
            cell.titleLabel.text = entity.subject;
            
            [cell setReadStatus:entity.read];
        }
        
        return cell;
    }else {
        
        NoticeContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        if (self.isSearch) {
            ActiveNewestNoticeCacheEntity *entity = [self.searchResult objectAtIndex:indexPath.section];
            
            NSRange range = [entity.descri rangeOfString:self.searchView.textFieldView.text];
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:entity.descri];
            [attribute setAttributes:@{NSForegroundColorAttributeName: color_with_hex(kColor_ff9933)} range:range];
            
            cell.contentLabel.attributedText = attribute;
            cell.timeLabel.text = [entity.create_time dateString];
        }else {
            NewestNoticeEntity *entity = [self.noticeInfo.act_notices objectAtIndex:indexPath.section];
            
            cell.contentLabel.text = entity.descri;
            cell.timeLabel.text = [entity.create_time dateString];
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [self.expandSection removeAllObjects];
    if ([tableView numberOfRowsInSection:indexPath.section] == 2) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }else {
        [self.expandSection addObject:@(indexPath.section)];
        
        NSRange reloadRange;
        if (self.isSearch) {
            reloadRange = NSMakeRange(0, self.searchResult.count);
        }else {
            reloadRange = NSMakeRange(0, self.noticeInfo.act_notices.count);
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:reloadRange] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
