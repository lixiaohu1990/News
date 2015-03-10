//
//  NewsDetailTableViewController.m
//  News
//
//  Created by 李小虎 on 15/3/4.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "NewsDetailTableViewController.h"
#import "DetailDiscussTableViewCell.h"
#import "SendCommentView.h"
#import "CyberPlayerController.h"
#import "NewsFilmDetailTableViewCell.h"
#import "NewFileDispalyViewController.h"
#import "NAApiGetNews.h"
#import "NANewsResp.h"
#import "DetailContentTableViewCell.h"
@interface NewsDetailTableViewController ()<DetailDiscussTableViewCellDelegate, NABaseApiResultHandlerDelegate>
{
    NSString *videoFullPath;
    CyberPlayerController *cbPlayerController;
    NSTimer *timer;
    UIButton *_startBtn;
    UIButton *_stopBtn;
    UIButton *_fullScreenBtn;
    UITableViewCell *_cell;
    BOOL fullScreen;
    int _currentPage;
    
}
@property (retain, nonatomic)UILabel *remainsProgress;
@property (nonatomic) NAApiGetNews *getNewsDetaiReq;
@property(nonatomic, strong)NANewsResp *detailItem;
@property (nonatomic, strong)NSMutableArray *commentArray;
@end

@implementation NewsDetailTableViewController

- (instancetype)initWithVideoPath:(NSString *)videoStr{
    if (self = [super init]) {
        videoFullPath = [NSString stringWithFormat:@"%@%@", @"http://115.29.248.18:8080/NewsAgency/file",videoStr];
    }
    return self;
}
- (void)dealloc{
    cbPlayerController = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentArray = [NSMutableArray array];
    self.title = @"立场新闻社";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self getNewsDetail];
    [self setupRefresh];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupRefresh
{
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.tableView.headerRefreshingText = @"正在拼命加载中,请稍候...";
    
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
//    [self GetNewsList];
    
}

- (void)getNewsDetail
{
    self.getNewsDetaiReq = [[NAApiGetNews alloc]initWithItemId:1 type:1];
    self.getNewsDetaiReq.APIRequestResultHandlerDelegate = self;
    [self.getNewsDetaiReq asyncRequest];
}

- (void)getCommentList{
    NSString *str = @"";
    [self.commentArray addObject:str];
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i=0; i<=self.commentArray.count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+3 inSection:0];
//        [array addObject:indexPath];
//    }
//    
//    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [cbPlayerController stop];
    [self stopTimer];   
}
- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return (fullScreen ? 1 : 3+self.commentArray.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return (fullScreen ? self.view.frame.size.height:250);
    }else if(indexPath.row == 1){
        return 88;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"film";
    static NSString *cellIdentifier2 = @"film";
    if (indexPath.row == 0) {
        NewsFilmDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][0];
            [self configureVideoWithCell:cell];
        }
        if (!fullScreen) {
            _cell = cell;
        }
        
        return cell;
        
    }else if(indexPath.row == 1){
        DetailContentTableViewCell *cell = [DetailContentTableViewCell cellWithTableView:tableView];
        cell.item = self.detailItem;
        return cell;
//    }else if(indexPath.row ==2){
//        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][2];
//        
//        return cell;

    }else if (indexPath.row == 2){
        DetailDiscussTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][3];
        cell.countLabel.text = [NSString stringWithFormat:@"%d", self.detailItem.commentCount];
        cell.dicDelegate = self;
        return cell;

    }else{
        UITableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NewsFilmDetailTableViewCell" owner:nil options:nil][4];
        
        return cell;
    }
    
}

- (void)configureVideoWithCell:(UITableViewCell *)cell{
//    videoFullPath = @"http://115.29.248.18:8080/NewsAgency/file/getVideo/3/1";
    NSURL *url = [NSURL URLWithString: videoFullPath];
    if (!url) {
        url = [NSURL URLWithString:[videoFullPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; }
    [cbPlayerController setContentURL: url];
    
    //请添加您百度开发者中心应用对应的APIKey和SecretKey。
    NSString* msAK=@"TwthXSKCmkGbR9DbYUriGmT7";
    NSString* msSK=@"irre7k4rzRjGqPnM";
    
    //添加开发者信息
    [[CyberPlayerController class ]setBAEAPIKey:msAK SecretKey:msSK ];
    //当前只支持CyberPlayerController的单实例
    cbPlayerController = [[CyberPlayerController alloc] initWithContentURL:url];
    //设置视频显示的位置
    [cbPlayerController.view setFrame: cell.frame];
    cbPlayerController.view.translatesAutoresizingMaskIntoConstraints = NO;
    //将视频显示view添加到当前view中
    [cell.contentView addSubview:cbPlayerController.view];
    CGRect frame = cell.frame;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, cbPlayerController.view.frame.size.height-30, 30, 30)];
    //    [startBtn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
    //    [startBtn setTitle:@"播放" forState:UIControlStateNormal];
    //    [startBtn setTitle:@"暂停" forState:UIControlStateSelected];
    //    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"36"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, cbPlayerController.view.frame.size.height-30, 30, 30)];
    [stopBtn setImage:[UIImage imageNamed:@"37"] forState:UIControlStateNormal];
    //    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    //    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [stopBtn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    
    _remainsProgress = [[UILabel alloc] initWithFrame:CGRectMake(cbPlayerController.view.frame.size.width-150, cbPlayerController.view.frame.size.height-30, 100, 30)];
    _remainsProgress.textColor = [UIColor whiteColor];
    
    UIButton *fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(cbPlayerController.view.frame.size.width-40, cbPlayerController.view.frame.size.height-30, 30, 30)];
    [fullScreenBtn setImage:[UIImage imageNamed:@"back_icon01"] forState:UIControlStateNormal];
    [fullScreenBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
    [fullScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [cbPlayerController.view addSubview:startBtn];
    [cbPlayerController.view addSubview:stopBtn];
    [cbPlayerController.view addSubview:_remainsProgress];
    [cbPlayerController.view addSubview:fullScreenBtn];

    [cell.contentView addSubview:btn];
    
    _startBtn = startBtn;
    _stopBtn = stopBtn;
    
    _fullScreenBtn = fullScreenBtn;
//    cbPlayerController.playbackState = CBPMovieScalingModeFill;
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cbPlayerController.view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:cell.contentView
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];//设置子视图的宽度和父视图的宽度相同
    
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cbPlayerController.view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:cell.contentView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0]];//设置子视图的高度是父视图高度的一半

    
    cbPlayerController.shouldAutoplay = YES;
//    [cbPlayerController pause];
    [cbPlayerController prepareToPlay];
    [self startTimer];

}

- (void)configureVideoViewWithFram:(CGRect)frame{
    _stopBtn.frame =  CGRectMake(50, frame.size.height-30, 30, 30);
    _startBtn.frame = CGRectMake(0, frame.size.height-30, 30, 30);
    _remainsProgress.frame =CGRectMake(frame.size.width-150, frame.size.height-30, 100, 30);
    cbPlayerController.view.frame = frame;
    _fullScreenBtn.frame = CGRectMake(frame.size.width-40, frame.size.height-30, 30, 30);
}
-(void)returnBack:(UIButton *)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)start:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [cbPlayerController pause];
    }else{
        [cbPlayerController play];
    }
}

-(void)stop:(UIButton *)sender{
    
    [cbPlayerController stop];

}

- (void)fullScreen{
    UIInterfaceOrientation orientation = (fullScreen ? UIInterfaceOrientationLandscapeLeft :UIInterfaceOrientationPortrait );
    [self didRotateFromInterfaceOrientation:orientation];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait) {
        NSLog(@"视图旋转完成之后自动调用");
        
        [self configureVideoViewWithFram:self.view.frame];
        fullScreen = YES;
        [self.tableView reloadData];
    }else{
        _cell.frame = CGRectMake(0, 0, _cell.frame.size.width, 250);
        [self configureVideoViewWithFram:_cell.frame];
        NSLog(@"%@", NSStringFromCGRect(_cell.frame));
        fullScreen = NO;
        [self.tableView reloadData];
        
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ------  CELLDELEGATE
- (void)didClickSendbutton:(DetailDiscussTableViewCell *)cell{
//    UIView *viewM = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    viewM.backgroundColor = [UIColor blackColor];
//    viewM.alpha = 0.5;
//    viewM.tag = 1000;
//    [self.view addSubview:viewM];
    SendCommentView *view = [[SendCommentView alloc] initWithFrame:self.view.frame];
//    view.center = CGPointMake(self.view.center.x, 200);
//    view.window.windowLevel = UIWindowLevelAlert;
    [view.commentTexfield becomeFirstResponder];
    [self.view addSubview:view];
}

- (void)timerHandler:(NSTimer*)timer
{
    [self refreshProgress:cbPlayerController.currentPlaybackTime totalDuration:cbPlayerController.duration];
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
    
    self.detailItem = requestResult;
    [self.tableView reloadData];
}

@end
