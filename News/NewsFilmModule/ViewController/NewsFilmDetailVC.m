//
//  NewsFilmDetailVC.m
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmDetailVC.h"
#import "NAApiGetCommentList.h"
#import "NewsFilmDetailCell.h"
#import "NewsCommentCell.h"
#import "NewsCommentToolBarCell.h"

static NSString *const NewsFilmDetailCellIdentifier = @"NewsFilmDetailCell";
static NSString *const NewsCommentCellIdentifier = @"NewsCommentCell";
static NSString *const NewsCommentToolBarCellIdentifier = @"NewsCommentToolBarCell";

@interface NewsFilmDetailVC ()

@property (nonatomic) NAApiGetCommentList *getCommentListReq;
@property (nonatomic) NSMutableArray *comments;

@end

@implementation NewsFilmDetailVC

- (instancetype)initWithNews:(NANewsResp *)news
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _news = news;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNewsFilmDetailVC];
}

- (void)setupNewsFilmDetailVC
{
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsFilmDetailCell"
                                               bundle:nil]
         forCellReuseIdentifier:NewsFilmDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCommentCell"
                                               bundle:nil]
         forCellReuseIdentifier:NewsCommentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCommentToolBarCell"
                                               bundle:nil]
         forCellReuseIdentifier:NewsCommentToolBarCellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 1: 视频详情 1: 评论toolBar commentCount: 评论数目
    return 1 + 1 + self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NewsFilmDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:NewsFilmDetailCellIdentifier forIndexPath:indexPath];
        return detailCell;
    }
    
    if (indexPath.row == 1) {
        NewsCommentToolBarCell *commentToolBarCell = [tableView dequeueReusableCellWithIdentifier:NewsCommentToolBarCellIdentifier forIndexPath:indexPath];
        return commentToolBarCell;
    }
    
    NewsCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:NewsCommentCellIdentifier forIndexPath:indexPath];
    return commentCell;
}

@end
