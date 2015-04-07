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
#import "VideoPlayVC.h"
#import "SVProgressHUD.h"
#import "LvModelWindow.h"

static const NSUInteger RequestCommentsPageSize = 30;

static NSString *const NewsFilmDetailCellIdentifier = @"NewsFilmDetailCell";
static NSString *const NewsCommentCellIdentifier = @"NewsCommentCell";
static NSString *const NewsCommentToolBarCellIdentifier = @"NewsCommentToolBarCell";

@interface NewsFilmDetailVC () <NABaseApiResultHandlerDelegate, LvModelWindowDelegate>
{
    BOOL originalStatusBarHidden;
}
@property (nonatomic) NAApiGetCommentList *getNewestCommentsReq;
@property (nonatomic) NAApiGetCommentList *loadMoreCommentsReq;
@property (nonatomic) NSMutableArray *comments;

// 当没有播放的视频的时候设置为-1
@property (nonatomic) NSInteger playingVideoIndex;

// 镶嵌在页面里的播放VC，以child view controller 添加到界面中
@property (nonatomic) VideoPlayVC *videoPlayerVC;

// 是否在全屏
@property (nonatomic) BOOL isOnFullScreen;

@end

@implementation NewsFilmDetailVC

- (instancetype)initWithNews:(NANewsResp *)news
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _news = news;
        
        DLOG(@"News, video count: %d", (int)news.videoList.count);
        
        _comments = [NSMutableArray array];
        _videoPlayerVC = [[VideoPlayVC alloc]init];
        _videoPlayerVC.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvFullScreenSwitchedNote:)
                                                 name:VPVCFullScreenSwitchButtonClickNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvPlayerItemDidPlayToEndTimeNote:)
                                                 name:VPVCPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvPlayerPlayPreviousItemNote:)
                                                 name:VPVCPlayPreviousVideoItemNotifiction
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvPlayerPlayNextItemNote:)
                                                 name:VPVCPlayNextVideoItemNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvVideoReadyToPlayNote:)
                                                 name:VPVCPlayerItemReadyToPlayNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvPlayerDismissNote:)
                                                 name:VPVCDismissNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvVideoTouchItemClickNote:)
                                                 name:NewsFilmDetailCellVideoItemSelectNotification
                                               object:nil];
    
    if (self.news.videoList.count > 0) {
        self.playingVideoIndex = 0;
    } else {
        self.playingVideoIndex = -1;
    }
    
    [self setupNewsFilmDetailVC];
    
    [self requestNewsestComments];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    originalStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    if (!originalStatusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:animated?UIStatusBarAnimationFade:UIStatusBarAnimationNone];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!originalStatusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:animated?UIStatusBarAnimationFade:UIStatusBarAnimationNone];
    }
}

#ifdef __IPHONE_7_0
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#endif

#ifdef __IPHONE_6_0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#endif

#ifndef __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
#endif

#pragma mark - Notifications

- (void)recvFullScreenSwitchedNote:(NSNotification *)note
{
    // 全屏/非全屏切换
    [self toggleFullScreen];
}

- (void)recvPlayerItemDidPlayToEndTimeNote:(NSNotification *)note
{
    // 播放下一个视频
    [self playNextVideo];
}

- (void)recvPlayerPlayPreviousItemNote:(NSNotification *)note
{
    [self playPreviousVideo];
}

- (void)recvPlayerPlayNextItemNote:(NSNotification *)note
{
    // 播放下一个视频
    [self playNextVideo];
}

- (void)recvPlayerDismissNote:(NSNotification *)note
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)recvVideoReadyToPlayNote:(NSNotification *)note
{
//    VideoPlayVC *vpVC = note.object;
}

- (void)recvVideoTouchItemClickNote:(NSNotification *)note
{
    NewsFilmDetailCell *cell = note.object;
    if ([cell isKindOfClass:[NewsFilmDetailCell class]]) {
        NSNumber *clickItemIndex = note.userInfo[NewsFilmDetailCellSelectedVideoItemIndexKey];
        if (clickItemIndex) {
            if ([self playVideoAtIndex:clickItemIndex.integerValue]) {
                cell.playingVideoIndex = clickItemIndex.integerValue;
            }
        }
    }
}

/**
 *  播放下一个视频
 */
- (void)playNextVideo
{
    
    NSArray *videourlList = self.news.videoList;
    if (videourlList.count == 0) {
        return;
    }
    NSInteger currentPlayIndex = self.playingVideoIndex;
    NSUInteger nextIndex = 0;
    if (currentPlayIndex >= 0) {
        nextIndex = (currentPlayIndex + 1)%videourlList.count;
    }
    
    [self playVideoAtIndex:nextIndex];
}

/**
 *  播放上一个视频
 */
- (void)playPreviousVideo
{
    // 播放前一个视频
    NSArray *videourlList = self.news.videoList;
    if (videourlList.count == 0) {
        return;
    }
    NSInteger currentPlayIndex = self.playingVideoIndex;
    NSUInteger preIndex = 0;
    if (currentPlayIndex != NSNotFound) {
        preIndex = (currentPlayIndex - 1 + videourlList.count)%videourlList.count;
    }
    
    [self playVideoAtIndex:preIndex];
}

/**
 *  播放某集视频
 */
- (BOOL)playVideoAtIndex:(NSUInteger)index
{
    NSArray *videourlList = self.news.videoList;
    if (videourlList.count > index) {
        self.playingVideoIndex = index;
        
        NSString *videoUrl = [NSString stringWithFormat:@"%@%@", BASEVIDEOURL, [(NAVideo *)videourlList[index] videoUrl]];
        [self.videoPlayerVC preparePlayURL:[NSURL URLWithString:videoUrl] immediatelyPlay:YES];
        return YES;
    }
    return NO;
}

- (void)toggleFullScreen
{
    _isOnFullScreen = !_isOnFullScreen;
    
    if (_isOnFullScreen) {
        [self presentViewController:_videoPlayerVC animated:YES completion:nil];
    } else {
        [_videoPlayerVC dismissViewControllerAnimated:YES completion:nil];
    }
    
//    [self.tableView setScrollEnabled:!_isOnFullScreen];
//
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
//                          withRowAnimation:UITableViewRowAnimationFade];
}

- (NewsFilmDetailCell *)newsFilmDetailCell
{
    NSInteger cellNum = [self.tableView numberOfRowsInSection:0];
    if (cellNum > 0) {
        NewsFilmDetailCell *newsFilmDetailCell = (NewsFilmDetailCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                          inSection:0]];
        if ([newsFilmDetailCell isKindOfClass:[NewsFilmDetailCell class]]) {
            return newsFilmDetailCell;
        }
    }
    return nil;
}

- (void)addVPVC:(VideoPlayVC *)vpvc intoNewsFilmDetailCell:(NewsFilmDetailCell *)newsFilmDetailCell
{
    if (![vpvc.view.superview isEqual:newsFilmDetailCell.playerContaintView]) {
        vpvc.view.frame = newsFilmDetailCell.playerContaintView.bounds;
        vpvc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        // 添加到新的view controller
        [self addChildViewController:vpvc];
        [newsFilmDetailCell.playerContaintView addSubview:vpvc.view];
        [vpvc didMoveToParentViewController:self];
    }
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
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(requestMoreComments)];
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在拼命加载中,请稍候...";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 1: 视频详情 1: 评论toolBar commentCount: 评论数目
    return 1 + 1 + self.comments.count;
}

- (CGFloat)calculateVideoPlayerHeightWithCellWidth:(CGFloat)cellWidth
{
    return cellWidth * 190.f/320.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CGFloat newsDetailCellHeight = 0;
        CGFloat cellWidth = CGRectGetWidth(tableView.frame);
//        CGFloat playerContaintHeight = _isOnFullScreen?CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame):[self calculateVideoPlayerHeightWithCellWidth:cellWidth];
        CGFloat playerContaintHeight = [self calculateVideoPlayerHeightWithCellWidth:cellWidth];
        newsDetailCellHeight = [NewsFilmDetailCell cellHeightWithVideoContaintViewHeight:playerContaintHeight
                                                                                    News:self.news
                                                                          expandAllVideo:YES cellWidth:cellWidth];
        return newsDetailCellHeight;
    }
    if (indexPath.row == 1) {
        return 30.f;
    }
    
    NACommentResp *comment = self.comments[indexPath.row - 2];
    // 计算评论cell高度
    CGFloat height = [NewsCommentCell cellHeightWithComment:comment.text
                                                  cellWidth:CGRectGetWidth(tableView.frame)];
    return height;
}

#define DegreesToRadians(degrees) (degrees * M_PI / 180)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NewsFilmDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:NewsFilmDetailCellIdentifier
                                                                         forIndexPath:indexPath];
        
        detailCell.backgroundColor = [UIColor clearColor];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat cellWidth = CGRectGetWidth(tableView.frame);
//        CGFloat playerContaintHeight = _isOnFullScreen?CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame):[self calculateVideoPlayerHeightWithCellWidth:cellWidth];
        CGFloat playerContaintHeight = [self calculateVideoPlayerHeightWithCellWidth:cellWidth];
        detailCell.playerContaintViewHeight = playerContaintHeight;
        
        detailCell.playerContaintView.backgroundColor = [UIColor redColor];
        
        detailCell.playingVideoIndex = self.playingVideoIndex;
        detailCell.news = self.news;
        detailCell.expandAllVideo = YES;
        
        [self addVPVC:self.videoPlayerVC intoNewsFilmDetailCell:detailCell];
    
        if (!self.videoPlayerVC.isPlaying) {
            if (!self.videoPlayerVC.videoURL) {
                [self playVideoAtIndex:self.playingVideoIndex];
            }
        }
        
        return detailCell;
    }
    
    if (indexPath.row == 1) {
        NewsCommentToolBarCell *commentToolBarCell = [tableView dequeueReusableCellWithIdentifier:NewsCommentToolBarCellIdentifier forIndexPath:indexPath];
        
        commentToolBarCell.backgroundColor = [UIColor clearColor];
        commentToolBarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        commentToolBarCell.commentNumLabel.text = [NSString stringWithFormat:@"评论  共%d条", (int)self.comments.count];
        
        return commentToolBarCell;
    }
    
    // 评论cell
    
    NewsCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:NewsCommentCellIdentifier
                                                                   forIndexPath:indexPath];
    
    commentCell.backgroundColor = [UIColor clearColor];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NACommentResp *comment = self.comments[indexPath.row - 2];
    commentCell.userName = comment.userName;
    commentCell.userType = comment.type;
    commentCell.dateText = comment.createdDate;
    
    return commentCell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        NewsFilmDetailCell *detailCell = (NewsFilmDetailCell *)cell;
//        CGRect playerContaintViewFrame = detailCell.playerContaintView.frame;
//        DLOG(@"before rotate ,frame: (%d, %d, %d, %d)", (int)CGRectGetMinX(playerContaintViewFrame),(int) CGRectGetMinY(playerContaintViewFrame),(int) CGRectGetWidth(playerContaintViewFrame), (int)CGRectGetHeight(playerContaintViewFrame));
//        if (_isOnFullScreen) {
//            
//            detailCell.playerContaintView.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
//            
//            //            CGSize playerContaintViewSize = detailCell.playerContaintView.frame.size;
//            //            playerContaintViewSize = CGSizeMake(playerContaintViewSize.height, playerContaintViewSize.width);
//            //            CGRect playerContaintViewFrame = detailCell.playerContaintView.frame;
//            //            playerContaintViewFrame.size = playerContaintViewSize;
//            //            playerContaintViewFrame.origin = CGPointMake(0, 0);
//            //            detailCell.playerContaintView.frame = playerContaintViewFrame;
//        } else {
//            detailCell.playerContaintView.transform = CGAffineTransformIdentity;
//        }
//        
//        playerContaintViewFrame = detailCell.playerContaintView.frame;
//        DLOG(@"after rotate ,frame: (%d, %d, %d, %d)", (int)CGRectGetMinX(playerContaintViewFrame),(int) CGRectGetMinY(playerContaintViewFrame),(int) CGRectGetWidth(playerContaintViewFrame), (int)CGRectGetHeight(playerContaintViewFrame));
//    }
//}

#pragma mark - Requests

- (BOOL)isOnRequestComments
{
    return _getNewestCommentsReq.isOnRequest || _loadMoreCommentsReq.isOnRequest;
}

- (void)requestNewsestComments
{
    if ([self isOnRequestComments]) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"加载..." maskType:SVProgressHUDMaskTypeClear];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _getNewestCommentsReq = [[NAApiGetCommentList alloc]initWithPage:1 rows:RequestCommentsPageSize newsID:self.news.itemId];
        _getNewestCommentsReq.APIRequestResultHandlerDelegate = self;
        [_getNewestCommentsReq asyncRequest];
    });
}

- (void)requestMoreComments
{
    if ([self isOnRequestComments]) {
        [self.tableView footerEndRefreshing];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger nextPage = ceilf((CGFloat)self.comments.count/RequestCommentsPageSize) + 1;
        _loadMoreCommentsReq = [[NAApiGetCommentList alloc]initWithPage:nextPage rows:RequestCommentsPageSize newsID:self.news.itemId];
        _loadMoreCommentsReq.APIRequestResultHandlerDelegate = self;
        [_loadMoreCommentsReq asyncRequest];
    });
}

#pragma mark - api delegate

- (void)failCauseBissnessError:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([apiRequest isEqual:_getNewestCommentsReq]) {
            [SVProgressHUD showErrorWithStatus:@"业务错误"];
            return;
        }
        if ([apiRequest isEqual:_loadMoreCommentsReq]) {
            [self.tableView footerEndRefreshing];
            return;
        }
    });
}

- (void)failCauseNetworkUnavaliable:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([apiRequest isEqual:_getNewestCommentsReq]) {
            [SVProgressHUD showErrorWithStatus:@"网络无链接"];
            return;
        }
        if ([apiRequest isEqual:_loadMoreCommentsReq]) {
            [self.tableView footerEndRefreshing];
            return;
        }
    });
}

- (void)failCauseParamError:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([apiRequest isEqual:_getNewestCommentsReq]) {
            [SVProgressHUD showErrorWithStatus:@"参数错误"];
            return;
        }
        if ([apiRequest isEqual:_loadMoreCommentsReq]) {
            [self.tableView footerEndRefreshing];
            return;
        }
    });
}

- (void)failCauseRequestTimeout:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([apiRequest isEqual:_getNewestCommentsReq]) {
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
            return;
        }
        if ([apiRequest isEqual:_loadMoreCommentsReq]) {
            [self.tableView footerEndRefreshing];
            return;
        }
    });
}

- (void)failCauseServerError:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([apiRequest isEqual:_getNewestCommentsReq]) {
            [SVProgressHUD showErrorWithStatus:@"服务端出错"];
            return;
        }
        if ([apiRequest isEqual:_loadMoreCommentsReq]) {
            [self.tableView footerEndRefreshing];
            return;
        }
    });
}

- (void)failCauseSystemError:(id)apiRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([apiRequest isEqual:_getNewestCommentsReq]) {
            [SVProgressHUD showErrorWithStatus:@"系统出错"];
            return;
        }
        if ([apiRequest isEqual:_loadMoreCommentsReq]) {
            [self.tableView footerEndRefreshing];
            return;
        }
    });
}

- (void)request:(id)apiRequest successRequestWithResult:(id)requestResult
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([apiRequest isEqual:_getNewestCommentsReq]) {
            [SVProgressHUD dismiss];
            
            NSArray *results = (NSArray *)requestResult;
            [_comments removeAllObjects];
            if (results.count > 0) {
                [_comments addObjectsFromArray:results];
            }
            
            [self.tableView reloadData];
            return;
        }
        if ([apiRequest isEqual:_loadMoreCommentsReq]) {
            [self.tableView footerEndRefreshing];
            
            NSArray *results = (NSArray *)requestResult;
            if (results.count > 0) {
                [_comments addObjectsFromArray:results];
                [self.tableView reloadData];
            }
            return;
        }
    });
}

@end
