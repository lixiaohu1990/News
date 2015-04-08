//
//  NewsFilmDetailVC.m
//  News
//
//  Created by 彭光波 on 15-4-2.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsFilmDetailVC.h"
#import "NAApiGetCommentList.h"
#import "NAApiSaveComment.h"
#import "NewsFilmDetailCell.h"
#import "NewsCommentCell.h"
#import "NewsCommentToolBarCell.h"
#import "VPVC.h"
#import "VitamioPlayerView.h"
#import "SVProgressHUD.h"

static const NSUInteger RequestCommentsPageSize = 30;

static NSString *const NewsFilmDetailCellIdentifier = @"NewsFilmDetailCell";
static NSString *const NewsCommentCellIdentifier = @"NewsCommentCell";
static NSString *const NewsCommentToolBarCellIdentifier = @"NewsCommentToolBarCell";

@interface NewsFilmDetailVC () <NABaseApiResultHandlerDelegate>
{
    BOOL originalStatusBarHidden;
}
@property (nonatomic) NAApiGetCommentList *getNewestCommentsReq;
@property (nonatomic) NAApiGetCommentList *loadMoreCommentsReq;
@property (nonatomic) NSMutableArray *comments;

// 当没有播放的视频的时候设置为-1
@property (nonatomic) NSInteger playingVideoIndex;

// 镶嵌在页面里的播放VC，以child view controller 添加到界面中
@property (nonatomic) VPVC *innerVPVC;

// 全屏页面播放器，弹出方式播放
@property (nonatomic) VPVC *fullScreenVPVC;

// 是否在全屏
@property (nonatomic) BOOL isOnFullScreen;

@property (nonatomic) VitamioPlayerView *playerView;

// 是否想展开评论框
@property (nonatomic) BOOL willingExpandCommentField;

@property (nonatomic) NAApiSaveComment *publishCommentReq;

@end

@implementation NewsFilmDetailVC

- (instancetype)initWithNews:(NANewsResp *)news
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _news = news;
        
        DLOG(@"News, video count: %d", (int)news.videoList.count);
        
        _comments = [NSMutableArray array];
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
                                                 name:VitamioPlayerCurrentVideoDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvPlayerPlayPreviousItemNote:)
                                                 name:VPVCPreviousButtonClickNotifiction
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvPlayerPlayNextItemNote:)
                                                 name:VPVCNextButtonClickNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvVideoReadyToPlayNote:)
                                                 name:VitamioPlayerSucceedToReadyToPlayNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvVPVCNavigationBarBackButtonClickNote:)
                                                 name:VPVCNavgationBarBackButtonClickNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvVideoTouchItemClickNote:)
                                                 name:NewsFilmDetailCellVideoItemSelectNotification
                                               object:nil];
    [self setupNewsFilmDetailVC];
    
    [self requestNewsestComments];
    
    [self playVideoAtIndex:self.playingVideoIndex];
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
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!originalStatusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:animated?UIStatusBarAnimationFade:UIStatusBarAnimationNone];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

#pragma mark - Respond to the Remote Control Events

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if ([_playerView isPlaying]) {
                [_playerView pause];
            } else {
                [_playerView play];
            }
            break;
        case UIEventSubtypeRemoteControlPlay:
            [_playerView play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [_playerView pause];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self playPreviousVideo];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self playNextVideo];
            break;
        default:
            break;
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

- (VitamioPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[VitamioPlayerView alloc]initWithFrame:self.view.bounds];
        _playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerView;
}

- (void)setupNewsFilmDetailVC
{
    if (self.news.videoList.count > 0) {
        self.playingVideoIndex = 0;
    } else {
        self.playingVideoIndex = -1;
    }
    
#ifdef __IPHONE_7_0
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
#endif
    
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

- (void)recvVPVCNavigationBarBackButtonClickNote:(NSNotification *)note
{
    if ([note.object isEqual:_fullScreenVPVC]) {
        [_fullScreenVPVC dismissViewControllerAnimated:YES completion:nil];
        [_innerVPVC setupVideoPlayerView:self.playerView];
        return;
    }
    
    [_playerView unsetPlayer];
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
    
    if ([self playVideoAtIndex:nextIndex]) {
        [self newsFilmDetailCell].playingVideoIndex = nextIndex;
    }
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
    
    if ([self playVideoAtIndex:preIndex]) {
        [self newsFilmDetailCell].playingVideoIndex = preIndex;
    }
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
        [self.playerView preparePlayURL:[NSURL URLWithString:videoUrl] immediatelyPlay:YES];
        return YES;
    }
    return NO;
}

- (void)toggleFullScreen
{
    _isOnFullScreen = !_isOnFullScreen;
    
    if (_isOnFullScreen) {
        _fullScreenVPVC = [[VPVC alloc]init];
        [_fullScreenVPVC setupVideoPlayerView:self.playerView];
        [self presentViewController:_fullScreenVPVC animated:YES completion:nil];
        [_fullScreenVPVC updateFullScreenButtonImageForFullScreenState:YES];
    } else {
        [_fullScreenVPVC dismissViewControllerAnimated:YES completion:nil];
        [_innerVPVC setupVideoPlayerView:self.playerView];
        [_innerVPVC updateFullScreenButtonImageForFullScreenState:NO];
    }
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

- (void)addVPVC:(VPVC *)vpvc intoNewsFilmDetailCell:(NewsFilmDetailCell *)newsFilmDetailCell
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
        CGFloat playerContaintHeight = [self calculateVideoPlayerHeightWithCellWidth:cellWidth];
        newsDetailCellHeight = [NewsFilmDetailCell cellHeightWithVideoContaintViewHeight:playerContaintHeight
                                                                                    News:self.news
                                                                          expandAllVideo:YES cellWidth:cellWidth];
        return newsDetailCellHeight;
    }
    if (indexPath.row == 1) {
        return [NewsCommentToolBarCell cellHeightWithCommentFieldShrink:!self.willingExpandCommentField];
    }
    
    NACommentResp *comment = self.comments[indexPath.row - 2];
    // 计算评论cell高度
    CGFloat height = [NewsCommentCell cellHeightWithComment:comment.text
                                                  cellWidth:CGRectGetWidth(tableView.frame)];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NewsFilmDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:NewsFilmDetailCellIdentifier
                                                                         forIndexPath:indexPath];
        
        detailCell.backgroundColor = [UIColor clearColor];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat cellWidth = CGRectGetWidth(tableView.frame);
        CGFloat playerContaintHeight = [self calculateVideoPlayerHeightWithCellWidth:cellWidth];
        detailCell.playerContaintViewHeight = playerContaintHeight;
        
        detailCell.playingVideoIndex = self.playingVideoIndex;
        detailCell.news = self.news;
        detailCell.expandAllVideo = YES;
        
        if (!_innerVPVC) {
            _innerVPVC = [[VPVC alloc]init];
        }
        if (!_isOnFullScreen) {
            [_innerVPVC setupVideoPlayerView:self.playerView];
        }
        [self addVPVC:_innerVPVC intoNewsFilmDetailCell:detailCell];
        
        return detailCell;
    }
    
    if (indexPath.row == 1) {
        NewsCommentToolBarCell *commentToolBarCell = [tableView dequeueReusableCellWithIdentifier:NewsCommentToolBarCellIdentifier forIndexPath:indexPath];
        
        commentToolBarCell.backgroundColor = [UIColor clearColor];
        commentToolBarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        commentToolBarCell.commentNumLabel.text = [NSString stringWithFormat:@"共%d条", (int)self.comments.count];
        
        commentToolBarCell.willingCommentFieldShrink = !self.willingExpandCommentField;
        if (self.willingExpandCommentField) {
            [commentToolBarCell.publishCommentButn setTitle:@"收起评论框" forState:UIControlStateNormal];
        } else {
            [commentToolBarCell.publishCommentButn setTitle:@"发表评论" forState:UIControlStateNormal];
        }
        
        [commentToolBarCell.publishCommentButn addTarget:self
                                                  action:@selector(toggleShowCommentField:)
                                        forControlEvents:UIControlEventTouchUpInside];
        [commentToolBarCell.commentField addTarget:self
                                            action:@selector(publishComment:)
                                  forControlEvents:UIControlEventEditingDidEndOnExit];
        commentToolBarCell.commentField.returnKeyType = UIReturnKeySend;
        
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

- (void)toggleShowCommentField:(UIButton *)butn
{
    self.willingExpandCommentField = !self.willingExpandCommentField;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
}


- (void)publishComment:(UITextField *)commentField
{
    [commentField resignFirstResponder];
    
    // 发表评论
    [self requestPublishComment:commentField.text];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.willingExpandCommentField = NO;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1
                                                                    inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (NewsCommentToolBarCell *)newsCommentToolBarCell
{
    NSInteger cellNum = [self.tableView numberOfRowsInSection:0];
    if (cellNum > 1) {
        NewsCommentToolBarCell *newsCommentToolBarCell = (NewsCommentToolBarCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1
                                                                                                                                inSection:0]];
        if ([newsCommentToolBarCell isKindOfClass:[NewsCommentToolBarCell class]]) {
            return newsCommentToolBarCell;
        }
    }
    return nil;
}

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

- (void)requestPublishComment:(NSString *)comment
{
    if (comment.length == 0)
        return;
    if (_publishCommentReq.isOnRequest)
        return;
    [SVProgressHUD showWithStatus:@"发表评论..." maskType:SVProgressHUDMaskTypeClear];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _publishCommentReq = [[NAApiSaveComment alloc]initWithText:comment
                                                              nsId:self.news.itemId];
        _publishCommentReq.APIRequestResultHandlerDelegate = self;
        [_publishCommentReq asyncRequest];
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
        if ([apiRequest isEqual:_publishCommentReq]) {
            [SVProgressHUD showErrorWithStatus:@"业务错误"];
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
        if ([apiRequest isEqual:_publishCommentReq]) {
            [SVProgressHUD showErrorWithStatus:@"网络无链接"];
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
        if ([apiRequest isEqual:_publishCommentReq]) {
            [SVProgressHUD showErrorWithStatus:@"参数错误"];
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
        if ([apiRequest isEqual:_publishCommentReq]) {
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
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
        if ([apiRequest isEqual:_publishCommentReq]) {
            [SVProgressHUD showErrorWithStatus:@"服务端出错"];
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
        if ([apiRequest isEqual:_publishCommentReq]) {
            [SVProgressHUD showErrorWithStatus:@"系统出错"];
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
        
        if ([apiRequest isEqual:_publishCommentReq]) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [self newsCommentToolBarCell].commentField.text = @"";
            
            // 添加到列表头部
            NACommentResp *newComment = [[NACommentResp alloc]init];
            newComment.userName = @"自己";
            static NSDateFormatter *yyyyMMddhhmmssdateFormatter = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                yyyyMMddhhmmssdateFormatter = [[NSDateFormatter alloc]init];
                [yyyyMMddhhmmssdateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            });
            newComment.createdDate = [yyyyMMddhhmmssdateFormatter stringFromDate:[NSDate date]];
            newComment.text = _publishCommentReq.text;
            
            [self.comments insertObject:newComment atIndex:0];
            [self.tableView reloadData];
            
            return;
        }
    });
}

@end
