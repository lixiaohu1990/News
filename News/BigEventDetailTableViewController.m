//
//  BigEventDetailTableViewController.m
//  News
//
//  Created by 李小虎 on 15/3/13.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "BigEventDetailTableViewController.h"
#import "DetailDiscussTableViewCell.h"
#import "SendCommentView.h"
#import "NewsFilmDetailTableViewCell.h"
#import "DetailContentTableViewCell.h"
#import "NAApiGetCommentList.h"
#import "DetailCommentTableViewCell.h"
#import "LoginViewController.h"
#import "VideoSubtitles.h"

@interface BigEventDetailTableViewController ()<DetailDiscussTableViewCellDelegate, NABaseApiResultHandlerDelegate, SendCommentViewDelegate>
{
//    CyberPlayerController *cbPlayerController;
    NSTimer *timer;
    UIButton *_startBtn;
    UIButton *_stopBtn;
    UIButton *_fullScreenBtn;
    UITableViewCell *_cell;
    BOOL fullScreen;
    int _currentPage;
    ListType _listType;
    BigEventDetailStyle _detailStyle;
    
    VideoSubtitles *rolling;
    NSArray *ary;
    int u;

    
}
@property (retain, nonatomic)UILabel *remainsProgress;
@property(nonatomic, strong)NANewsResp *detailItem;
@property (nonatomic, strong)NSMutableArray *commentArray;
@property (nonatomic, strong)NAApiGetCommentList *commentReq;
@end

@implementation BigEventDetailTableViewController
- (instancetype)initWithEventStyle:(BigEventDetailStyle)eventStyle news:(NANewsResp *)news listType:(ListType)listType{
    if (self = [super init]) {
        _detailStyle = eventStyle;
        _news = news;
        _listType = listType;
    }
    return self;
}
- (void)dealloc{
//    cbPlayerController = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    self.commentArray = [NSMutableArray array];
    self.title = @"大事件详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getCommentList];
    [self setupRefresh];
}

- (BOOL)prefersStatusBarHidden{
    if (_detailStyle == BigeventdetailStyleVideo) {
        return YES;
    }else{
        return NO;
    }
}
- (void)setupRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在拼命加载中,请稍候...";
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getItemListConnection];
    [self.tableView headerEndRefreshing];
}

- (void)footerRereshing
{
    [self pullUpgetItemListConnection];
    [self.tableView footerEndRefreshing];
}
- (void)pullUpgetItemListConnection{
    _currentPage++;
    [self getCommentList];
}

- (void)getItemListConnection{
    _currentPage = PAGENO;
}

- (void)getCommentList{
    self.commentReq = [[NAApiGetCommentList alloc]initWithPage:_currentPage rows:PAGESIZE newsID:self.news.itemId];
    self.commentReq.APIRequestResultHandlerDelegate = self;
    [self.commentReq asyncRequest];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
//    [cbPlayerController stop];
    [self stopTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_detailStyle == BigeventdetailStyleText) {
        return (fullScreen ? 1 : 2+self.commentArray.count);
    }else{
        return (fullScreen ? 1 : 4+self.commentArray.count);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_detailStyle != BigeventdetailStyleText) {
        if (indexPath.row == 0) {
            return (fullScreen ? self.view.frame.size.height:250);
        }else if(indexPath.row == 1){
            return 88;
        }else{
            return 44;
        }
    }else{
        if (indexPath.row == 0) {
            return 88;
        }else{
            return 44;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"film";
    if (_detailStyle != BigeventdetailStyleText) {
        if (indexPath.row == 0) {
            NewsFilmDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][0];
                if (_detailStyle == BigeventdetailStyleVideo) {
                    [self configureVideoWithCell:cell];
                }
            }
            if (!fullScreen) {
                _cell = cell;
            }
            
            return cell;
            
        }else if(indexPath.row == 1){
            DetailContentTableViewCell *cell = [DetailContentTableViewCell cellWithTableView:tableView];
            cell.item = self.detailItem;
            return cell;
        }else if(indexPath.row ==2){
            UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][2];
    
            return cell;
            
        }else if (indexPath.row == 3){
            DetailDiscussTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][3];
            cell.countLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.commentCount];
            cell.dicDelegate = self;
            return cell;
            
        }else{
            DetailCommentTableViewCell *cell = [DetailCommentTableViewCell cellWithTableView:tableView];
            cell.item = self.commentArray[indexPath.row - 4];
            return cell;
        }

    }else{
        if(indexPath.row == 0){
            DetailContentTableViewCell *cell = [DetailContentTableViewCell cellWithTableView:tableView];
            cell.item = self.detailItem;
            return cell;
//                }else if(indexPath.row ==2){
//                    UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][2];
//            
//                    return cell;
            
        }else if (indexPath.row == 1){
            DetailDiscussTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][3];
            cell.countLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.commentCount];
            cell.dicDelegate = self;
            return cell;
            
        }else{
            DetailCommentTableViewCell *cell = [DetailCommentTableViewCell cellWithTableView:tableView];
            cell.item = self.commentArray[indexPath.row - 2];
            return cell;
        }

    }
    

    
}

- (void)configureVideoWithCell:(UITableViewCell *)cell{
//
//    //    videoFullPath = @"http://115.29.248.18:8080/NewsAgency/file/getVideo/3/1";
//    
//    if (self.news.videoList.count == 0)
//        return;
//    
//    NSString *videoPathM = [NSString stringWithFormat:@"%@%@", BASEVIDEOURL, [(NAVideo *)self.news.videoList[0] videoUrl]];
//    NSURL *url = [NSURL URLWithString: videoPathM];
//    
//    [cbPlayerController setContentURL: url];
//    [cbPlayerController setExtSubtitleFile:@"http://bcs.duapp.com/123.srt"];
//    //请添加您百度开发者中心应用对应的APIKey和SecretKey。
//    NSString* msAK=@"TwthXSKCmkGbR9DbYUriGmT7";
//    NSString* msSK=@"irre7k4rzRjGqPnM";
//    
//    //添加开发者信息
//    [[CyberPlayerController class ]setBAEAPIKey:msAK SecretKey:msSK ];
//    //当前只支持CyberPlayerController的单实例
//    cbPlayerController = [[CyberPlayerController alloc] initWithContentURL:url];
//    //设置视频显示的位置
//    [cbPlayerController.view setFrame: cell.frame];
//    cbPlayerController.view.translatesAutoresizingMaskIntoConstraints = NO;
//    //将视频显示view添加到当前view中
//    [cell.contentView addSubview:cbPlayerController.view];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [btn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, cbPlayerController.view.frame.size.height-30, 30, 30)];
//    //    [startBtn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
//    //    [startBtn setTitle:@"播放" forState:UIControlStateNormal];
//    //    [startBtn setTitle:@"暂停" forState:UIControlStateSelected];
//    //    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [startBtn setImage:[UIImage imageNamed:@"36"] forState:UIControlStateNormal];
//    [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, cbPlayerController.view.frame.size.height-30, 30, 30)];
//    [stopBtn setImage:[UIImage imageNamed:@"37"] forState:UIControlStateNormal];
//    //    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
//    //    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //    [stopBtn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
//    [stopBtn addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
//    
//    _remainsProgress = [[UILabel alloc] initWithFrame:CGRectMake(cbPlayerController.view.frame.size.width-150, cbPlayerController.view.frame.size.height-30, 100, 30)];
//    _remainsProgress.textColor = [UIColor whiteColor];
//    
//    UIButton *fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(cbPlayerController.view.frame.size.width-40, cbPlayerController.view.frame.size.height-30, 30, 30)];
//    [fullScreenBtn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
//    [fullScreenBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
//    [fullScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    
//    [cbPlayerController.view addSubview:startBtn];
//    [cbPlayerController.view addSubview:stopBtn];
//    [cbPlayerController.view addSubview:_remainsProgress];
//    [cbPlayerController.view addSubview:fullScreenBtn];
//    
//    [cell.contentView addSubview:btn];
//    
//    _startBtn = startBtn;
//    _stopBtn = stopBtn;
//    
//    _fullScreenBtn = fullScreenBtn;
//    //    cbPlayerController.playbackState = CBPMovieScalingModeFill;
//    
//    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cbPlayerController.view
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:cell.contentView
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                multiplier:1.0
//                                                                  constant:0]];//设置子视图的宽度和父视图的宽度相同
//    
//    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cbPlayerController.view
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:cell.contentView
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                multiplier:1.0
//                                                                  constant:0]];//设置子视图的高度是父视图高度的一半
//    
//    
//    cbPlayerController.shouldAutoplay = YES;
//    //    [cbPlayerController pause];
//    [cbPlayerController prepareToPlay];
//    
////    [cbPlayerController openExtSubtitleFile:@"http://bcs.duapp.com/567.ass"];
//    [self startTimer];
//    
//    
//    //初始化字幕类
//    rolling = [[VideoSubtitles alloc] init];
//    
//    //设置滚动速度
//    rolling.scrollSpeed = 0.05;
//    
//    //设置新文字出现的速度
//    rolling.textSpeed = 0.5;
//    
//    //设置是否循环
//    rolling.isScroll = NO;
//    
//    //设置字幕的行数
//    rolling.scrollHeightCount = 5;
//    
//    //设置内容
//    rolling.aryText = [[NSMutableArray alloc] initWithObjects:
//                       @"111111111！",
//                       @"222222333122",
//                       @"3333333333",
//                       @"44444444",
//                       @"5555555",
//                       @"6666666",
//                       @"7777777",
//                       @"88888888",
//                       @"9999999999",
//                       nil];
//    
//    //设置字体颜色
//    rolling.aryColor = [[NSArray alloc] initWithObjects:
//                        [UIColor brownColor],
//                        [UIColor purpleColor],
//                        [UIColor redColor],
//                        [UIColor blueColor],
//                        [UIColor greenColor],
//                        [UIColor orangeColor],
//                        [UIColor yellowColor],
//                        nil];
//    
//    //设置字体大小
//    rolling.aryFont = [[NSArray alloc] initWithObjects:
//                       @"15",
//                       @"16",
//                       @"17",
//                       @"18",
//                       @"19",
//                       @"15",
//                       @"16",
//                       nil];
//    
//    //设置添加字幕的视图
//    rolling.RootView = cell.contentView;
//    
//    //加添字幕
//    [rolling initAddRollingSubtitles];
//    
}

- (void)configureVideoViewWithFram:(CGRect)frame{
    _stopBtn.frame =  CGRectMake(50, frame.size.height-30, 30, 30);
    _startBtn.frame = CGRectMake(0, frame.size.height-30, 30, 30);
    _remainsProgress.frame =CGRectMake(frame.size.width-150, frame.size.height-30, 100, 30);
//    cbPlayerController.view.frame = frame;
    _fullScreenBtn.frame = CGRectMake(frame.size.width-40, frame.size.height-30, 30, 30);
}
-(void)returnBack:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)start:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
//        [cbPlayerController pause];
    }else{
//        [cbPlayerController play];
    }
}

-(void)stop:(UIButton *)sender{
    
//    [cbPlayerController stop];
    
}

- (void)fullScreen{
//    if (!cbPlayerController.contentURL) {
//        return;
//    }
//    VideoPlayVC *fullVideoPlayVC = [[VideoPlayVC alloc]init];
//    [self presentViewController:fullVideoPlayVC animated:YES completion:^{
//        [fullVideoPlayVC preparePlayURL:cbPlayerController.contentURL immediatelyPlay:YES];
//    }];
}


#pragma mark ------  CELLDELEGATE
- (void)didClickSendbutton:(DetailDiscussTableViewCell *)cell{
    //    UIView *viewM = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    //    viewM.backgroundColor = [UIColor blackColor];
    //    viewM.alpha = 0.5;
    //    viewM.tag = 1000;
    //    [self.view addSubview:viewM];
    SendCommentView *view = [[SendCommentView alloc] init];
    view.sDelegate = self;
    if (_detailStyle == BigeventdetailStyleVideo) {
        view.frame = self.view.frame;
    }else{
        CGRect frame = CGRectMake(0, -64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
        view.frame = frame;
    }
         view.newsId = self.news.itemId;
    [view.commentTexfield becomeFirstResponder];
    [self.view addSubview:view];
}

- (void)timerHandler:(NSTimer*)timer
{
//    [self refreshProgress:cbPlayerController.currentPlaybackTime totalDuration:cbPlayerController.duration];
}
- (void)refreshProgress:(int) currentTime totalDuration:(int)allSecond{
    
    NSDictionary* dict = [[self class] convertSecond2HourMinuteSecond:currentTime];
    NSString* strPlayedTime = [self getTimeString:dict prefix:@""];
    
    NSDictionary* dictLeft = [[self class] convertSecond2HourMinuteSecond:allSecond - currentTime];
    NSString* strLeft = [self getTimeString:dictLeft prefix:@"-"];
    //    NSLog(@"%@", strLeft);
    _remainsProgress.text = strLeft;
    
    
}
+ (NSDictionary*)convertSecond2HourMinuteSecond:(int)second
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    int hour = 0, minute = 0;
    
    hour = second / 3600;
    minute = (second - hour * 3600) / 60;
    second = second - hour * 3600 - minute *  60;
    
    [dict setObject:[NSNumber numberWithInt:hour] forKey:@"hour"];
    [dict setObject:[NSNumber numberWithInt:minute] forKey:@"minute"];
    [dict setObject:[NSNumber numberWithInt:second] forKey:@"second"];
    
    return dict;
}
- (NSString*)getTimeString:(NSDictionary*)dict prefix:(NSString*)prefix
{
    int hour = [[dict objectForKey:@"hour"] intValue];
    int minute = [[dict objectForKey:@"minute"] intValue];
    int second = [[dict objectForKey:@"second"] intValue];
    
    NSString* formatter = hour < 10 ? @"0%d" : @"%d";
    NSString* strHour = [NSString stringWithFormat:formatter, hour];
    
    formatter = minute < 10 ? @"0%d" : @"%d";
    NSString* strMinute = [NSString stringWithFormat:formatter, minute];
    
    formatter = second < 10 ? @"0%d" : @"%d";
    NSString* strSecond = [NSString stringWithFormat:formatter, second];
    
    return [NSString stringWithFormat:@"%@%@:%@:%@", prefix, strHour, strMinute, strSecond];
}
- (void)startTimer{
    //为了保证UI刷新在主线程中完成。
    [self performSelectorOnMainThread:@selector(startTimeroOnMainThread) withObject:nil waitUntilDone:NO];
}
- (void)startTimeroOnMainThread{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
}
- (void)stopTimer{
    if ([timer isValid])
    {
        [timer invalidate];
    }
    timer = nil;
}

#pragma mark - NABaseApiResultHandlerDelegate methods

- (void)failCauseNetworkUnavaliable:(id)request
{
    DLOG(@"failCauseNetworkUnavaliable");
}

- (void)failCauseRequestTimeout:(id)request
{
    DLOG(@"failCauseRequestTimeout");
}

- (void)failCauseServerError:(id)request
{
    DLOG(@"failCauseServerError");
}

- (void)failCauseBissnessError:(id)apiRequest
{
    DLOG(@"failCauseBissnessError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

- (void)failCauseSystemError:(id)apiRequest
{
    DLOG(@"failCauseSystemError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

- (void)failCauseParamError:(id)apiRequest
{
    DLOG(@"failCauseParamError, status:%@", ((NABaseApi *)apiRequest).respStatus);
}

#pragma mark - Correct result handler
- (void)request:(id)request successRequestWithResult:(id)requestResult
{
    if ([request isEqual:_commentReq]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_currentPage == 1) {
                self.commentArray = [NSMutableArray arrayWithArray:requestResult];
            }else{
                [self.commentArray addObjectsFromArray:requestResult];
            }
            
            [self.tableView reloadData];
        });
        return;
    }
}

- (void)sendCommentDidFinishedWithSendCommentView:(SendCommentView *)view{
    _currentPage = 1;
    [self getCommentList];
}

-(void)sendCommentDidLoginWithSendCommentView:(SendCommentView *)view{
    LoginViewController *control = [[LoginViewController alloc] init];
    [self presentViewController:control animated:YES completion:nil];
}
@end

