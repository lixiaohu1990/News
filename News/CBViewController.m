//
//  CBViewController.m
//  SampleOne
//
//  Copyright Baidu All rights reserved.
//

#import "CBViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CyberPlayerController.h"
@interface CBViewController ()
{
    //MPMoviePlayerController *mpPlayerController;
    CyberPlayerController *cbPlayerController;
    NSTimer *timer;
    NSString *vedioPathStr;
}
@end

@implementation CBViewController
@synthesize mpPlayerView;
@synthesize cbPlayerView;
@synthesize sliderProgress;
@synthesize currentProgress;
@synthesize remainsProgress;
@synthesize playButtonText;
@synthesize playContentText;
@synthesize subContentText;
@synthesize networkLabel;
- (IBAction)setSubVisible {
    static int isShow = 1;
    if (isShow){
        isShow = 0;
    } else {
        isShow = 1;
    }
    [cbPlayerController setSubtitleVisibility: isShow];
}
- (IBAction)setSubColor {
    //set display color of subtitle. such as red color: R(238)G(0)B(0)A(0)
    // (R<<24) | (G<<16) | (B<<8) | (A);
    // red: RGBA-> 238 0 0 0  Green: RGBA-> 0 255 0 0 blue: RGBA-> 0 0 255 0 Orange: RGBA-> 255 165 0 0
#define COLOR_COUNT 5
    int iRGBA_array[COLOR_COUNT][4] = {
        {238,0,0,0},  //red
        {0,255,0,0},  //green
        {0,0,255,0},  //blue
        {0,0,255,0},  //orange
        {255,255,255,0}, //whrite
    };

    static int count = 0;
    if (count == COLOR_COUNT){
        count = 0;
    }
    int iColor = (iRGBA_array[count][0]<<24)
    |(iRGBA_array[count][1]<<16)
    |(iRGBA_array[count][2]<<8)
    |(iRGBA_array[count][3]);
    [cbPlayerController setSubtitleColor: iColor];
    count++;
}
- (IBAction)setSubAlign {
    // set display align method of subtitle.
    // VALIGN_SUB 0			//on bottom Hor
    // VALIGN_CENTER 8		//
    // VALIGN_TOP 4
    // HALIGN_LEFT 1
    // HALIGN_CENTER 2
    // HALIGN_RIGHT 3

    int AlignT[9]={2,10,6,1,9,5,3,11,7};
    static int i = 0;
    if (i>=9){
        i = 0;
    }
    [cbPlayerController setSubtitleAlignMethod: AlignT[i++]];
}
static float fFontScale = 1.0;
- (IBAction)setFontScale {
    fFontScale += 0.1;
    [cbPlayerController setSubtitleFontScale: fFontScale];
}

- (IBAction)decFontScale {
    fFontScale -= 0.1;
    [cbPlayerController setSubtitleFontScale: fFontScale];
}

- (IBAction)adaptSubtitleTimeMs {
    static int subTimeMsa = 0;
    subTimeMsa+=100;
    [cbPlayerController manualSyncSubtitle: subTimeMsa];
}
- (IBAction)decSubtitleTimeMs {
    static int subTimeMsd = 0;
    subTimeMsd-=100;
    [cbPlayerController manualSyncSubtitle: subTimeMsd];
}

- (IBAction)openSubtitle {
    static int subnum = 0;
    
    NSString* strDocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* strURLFilePath;
    NSString* str;
    NSFileManager* fm = [NSFileManager defaultManager];
    NSError* error = nil;
    switch (subnum){
        case 0:
            strURLFilePath = [strDocPath stringByAppendingPathComponent:@"The.Interview.2014.1080p.WEB-DL.AAC2.0.H264-RARBG.chs.srt"];
            str = [[NSBundle mainBundle] pathForResource:@"The.Interview.2014.1080p.WEB-DL.AAC2.0.H264-RARBG.chs" ofType:@"srt"];
            break;
        case 1:
            strURLFilePath = [strDocPath stringByAppendingPathComponent:@"The.Interview.2014.1080p.WEB-DL.AAC2.0.H264-RARBG.srt"];
            str = [[NSBundle mainBundle] pathForResource:@"The.Interview.2014.1080p.WEB-DL.AAC2.0.H264-RARBG" ofType:@"srt"];
            break;
        case 2:
            strURLFilePath = [strDocPath stringByAppendingPathComponent:@"Guardians.of.the.Galaxy.2014.720p.BluRay.x264-SPARKS.srt"];
            str = [[NSBundle mainBundle] pathForResource:@"Guardians.of.the.Galaxy.2014.720p.BluRay.x264-SPARKS" ofType:@"srt"];
            break;
        case 3:
            strURLFilePath = [strDocPath stringByAppendingPathComponent:@"生活大爆炸.The.Big.Bang.Theory.S01E02.Chi_Eng.HR-HDTV.AAC.1024X576.x264-YYeTs人人影视_XLSub.txt"];
            str = [[NSBundle mainBundle] pathForResource:@"生活大爆炸.The.Big.Bang.Theory.S01E02.Chi_Eng.HR-HDTV.AAC.1024X576.x264-YYeTs人人影视_XLSub" ofType:@"txt"];
            break;
        default:
            strURLFilePath = [strDocPath stringByAppendingPathComponent:@"Fast.and.Furious.6.2013.EXTENDED.1080p.BluRay.DTS.x264-PuTao.eng.srt"];
            str = [[NSBundle mainBundle] pathForResource:@"Fast.and.Furious.6.2013.EXTENDED.1080p.BluRay.DTS.x264-PuTao.eng" ofType:@"srt"];
            break;
    }

    NSLog(@"openSubtitle=%@\n", strURLFilePath);
    NSLog(@"str=%@\n", str);
    if (![fm copyItemAtPath:str toPath:strURLFilePath error:&error])
    {
        NSLog(@"openSubtitle is null！");
        //return;
    }
    NSLog(@"openSubtitle=%@\n", strURLFilePath);
    [cbPlayerController openExtSubtitleFile:strURLFilePath];
    subnum++;
    if (subnum > 3){
        subnum = 0;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    mpPlayerView.layer.borderWidth = 2.0;
    mpPlayerView.layer.borderColor = [[UIColor redColor]CGColor];
    cbPlayerView.layer.borderWidth = 2.0;
    cbPlayerView.layer.borderColor = [[UIColor blueColor]CGColor];


    vedioPathStr = @"http://115.29.248.18:8080/NewsAgency/file/getVideo/3/1";

    //请添加您百度开发者中心应用对应的APIKey和SecretKey。
    NSString* msAK=@"TwthXSKCmkGbR9DbYUriGmT7";
    NSString* msSK=@"irre7k4rzRjGqPnM";

    //添加开发者信息
    [[CyberPlayerController class ]setBAEAPIKey:msAK SecretKey:msSK ];
    //当前只支持CyberPlayerController的单实例
    cbPlayerController = [[CyberPlayerController alloc] init];
    //设置视频显示的位置
    [cbPlayerController.view setFrame: cbPlayerView.frame];
    //将视频显示view添加到当前view中
    [self.view addSubview:cbPlayerController.view];
    cbPlayerController.dolbyEnabled = YES;
    //注册监听，当播放器完成视频的初始化后会发送CyberPlayerLoadDidPreparedNotification通知，
    //此时naturalSize/videoHeight/videoWidth/duration等属性有效。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onpreparedListener:)
                                                 name: CyberPlayerLoadDidPreparedNotification
                                               object:nil];
    //注册监听，当播放器完成视频播放位置调整后会发送CyberPlayerSeekingDidFinishNotification通知，
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seekComplete:)
                                                 name:CyberPlayerSeekingDidFinishNotification
                                               object:nil];
    //注册网速监听，在播放器播放过程中，没秒发送实时网速(单位：bps）CyberPlayerGotNetworkBitrateKbNotification通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNetworkStatus:)
                                                 name:CyberPlayerGotNetworkBitrateNotification
                                               object:nil];
    
    
    sliderProgress.continuous = true;
//    cbPlayerController.shouldAutoplay = YES;
    [self startPlayback];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self stopPlayback];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onpreparedListener: (NSNotification*)aNotification
{
    //视频文件完成初始化，开始播放视频并启动刷新timer。
    playButtonText.titleLabel.text = @"pause";
    [self startTimer];
}
- (void)seekComplete:(NSNotification*)notification
{
    //开始启动UI刷新
    [self startTimer];
}

- (void)dealloc {
    [cbPlayerController release];    
    //[mpPlayerController release];
    [sliderProgress release];
    [currentProgress release];
    [remainsProgress release];
    [playButtonText release];
    [playContentText release];
    [subContentText release];
    [networkLabel release];
    [super dealloc];
}
- (IBAction)onClickPlay:(id)sender {
    //当按下播放按钮时，调用startPlayback方法
    [self startPlayback];
}

- (IBAction)onClickStop:(id)sender {
    [self stopPlayback];
}
- (void)startPlayback{
    NSURL *url = [NSURL URLWithString:vedioPathStr];
    if (!url)
    {
        url = [NSURL URLWithString:[vedioPathStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
/*
    switch (mpPlayerController.playbackState) {
        case MPMoviePlaybackStateStopped:
            [mpPlayerController setContentURL:url];
            [mpPlayerController prepareToPlay];
            break;
        case MPMoviePlaybackStatePaused:
            [mpPlayerController play];
            break;
        case MPMoviePlaybackStatePlaying:
            [mpPlayerController pause];
            break;
        default:
            break;
    }
 */
    switch (cbPlayerController.playbackState) {
        case CBPMoviePlaybackStateStopped:
        case CBPMoviePlaybackStateInterrupted:
            [cbPlayerController setContentURL:url];
//            [cbPlayerController setExtSubtitleFile:@"http://bcs.duapp.com/subtitle/34677636.srt?sign=MBO:2af85f6e5c42fbc804bd9eee337e652d:9rJd06c8jKHb63SKzdYp3PWQYe4%3D"];
//            [cbPlayerController setExtSubtitleFile:@"http://10.10.10.254:80/data/UsbDisk1/Volume3/The.Big.Bang.Theory.S08E01.720p.HDTV.X264-DIMENSION.srt"];
            //[cbPlayerController setExtSubtitleFile:[self getTestFilePath]];
            //初始化完成后直接播放视频，不需要调用play方法
            cbPlayerController.shouldAutoplay = YES;
            //初始化视频文件
            [cbPlayerController prepareToPlay];
            [playButtonText setTitle:@"pause" forState:UIControlStateNormal];
            break;
        case CBPMoviePlaybackStatePlaying:
            //如果当前正在播放视频时，暂停播放。
            [cbPlayerController pause];
            [playButtonText setTitle:@"play" forState:UIControlStateNormal];
            break;
        case CBPMoviePlaybackStatePaused:
            //如果当前播放视频已经暂停，重新开始播放。
            [cbPlayerController start];
            [playButtonText setTitle:@"pause" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
- (void)stopPlayback{
    //停止视频播放
    [cbPlayerController stop];
    //[mpPlayerController stop];
    [playButtonText setTitle:@"play" forState:UIControlStateNormal];
    [self stopTimer];
}
- (void)willResignActive

{
    NSLog(@"willResignActive\n");
    if (cbPlayerController.playbackState == CBPMoviePlaybackStatePlaying) {
        self.lastPlayDuration = cbPlayerController.currentPlaybackTime;
    }else{
        self.lastPlayDuration = 0;
    }
    NSLog(@"lasttime=%f\n",self.lastPlayDuration);
    //[self stopPlayback];
    [cbPlayerController pause];
}
- (void)didBecomeActive

{
    NSLog(@"didBecomeActive\n");
    NSLog(@"state=%d\n", cbPlayerController.playbackState);
    if (cbPlayerController.playbackState == CBPMoviePlaybackStatePaused){
        NSLog(@"paused\n");
        [cbPlayerController start];
    } else {
        NSLog(@"lasttime=%f\n",self.lastPlayDuration);
        if (self.lastPlayDuration > 0) {
            [self stopTimer];   //暂停更新
            [cbPlayerController seekTo:self.lastPlayDuration];
            [cbPlayerController start];
            
            sliderProgress.value = self.lastPlayDuration;
            
        }
    }

    
    self.lastPlayDuration = 0;
    
}
- (NSString*)getTestFilePath
{
    NSString *itemPath = @"The.srt";
    NSArray *aArray = [itemPath componentsSeparatedByString:@"."];
    NSString *filename = [aArray objectAtIndex:0];
    NSString *sufix = [aArray objectAtIndex:1];
    NSString *srtPath = [[NSBundle mainBundle] pathForResource:filename ofType:sufix];
    NSLog(@"Local srtPath = %@", srtPath);
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    BOOL tmp = [fm fileExistsAtPath:srtPath];
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:srtPath];
    
    if (tmp != TRUE || fileHandle == NULL){
        NSLog(@"playthreadMain : srtPath %@ is not exit!", srtPath);
        [srtPath release];
        return nil;
    } else {
        NSLog(@"tmp=%d,fileHandle=%@", tmp, fileHandle);
    }
    return srtPath;
}

- (void)timerHandler:(NSTimer*)timer
{
    [self refreshProgress:cbPlayerController.currentPlaybackTime totalDuration:cbPlayerController.duration];
}
- (void)refreshProgress:(int) currentTime totalDuration:(int)allSecond{

    NSDictionary* dict = [[self class] convertSecond2HourMinuteSecond:currentTime];
    NSString* strPlayedTime = [self getTimeString:dict prefix:@""];
    currentProgress.text = strPlayedTime;
        
    NSDictionary* dictLeft = [[self class] convertSecond2HourMinuteSecond:allSecond - currentTime];
    NSString* strLeft = [self getTimeString:dictLeft prefix:@"-"];
    remainsProgress.text = strLeft;
    sliderProgress.value = currentTime;
    sliderProgress.maximumValue = allSecond;

}

+ (NSDictionary*)convertSecond2HourMinuteSecond:(int)second
{
    NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    int hour = 0, minute = 0;
    
    hour = second / 3600;
    minute = (second - hour * 3600) / 60;
    second = second - hour * 3600 - minute *  60;
    
    [dict setObject:[NSNumber numberWithInt:hour] forKey:@"hour"];
    [dict setObject:[NSNumber numberWithInt:minute] forKey:@"minute"];
    [dict setObject:[NSNumber numberWithInt:second] forKey:@"second"];
    
    return dict;
}

- (void) showNetworkStatus: (NSNotification*) aNotifycation
{
    int networkBitrateValue = [[aNotifycation object] intValue];
    NSLog(@"show network bitrate is %d\n", networkBitrateValue);
    int Kbit = 1024;
    int Mbit = 1024*1024;
    int networkBitrate = 0;
    if (networkBitrateValue > Mbit){
        networkBitrate = networkBitrateValue/Mbit;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.networkLabel.text = [NSString stringWithFormat:@"%dMps", networkBitrate];
        });
    } else if (networkBitrateValue > Kbit){
        networkBitrate = networkBitrateValue/Kbit;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.networkLabel.text = [NSString stringWithFormat:@"%dKps", networkBitrate];
        });
    } else {
        networkBitrate = networkBitrateValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.networkLabel.text = [NSString stringWithFormat:@"%dbps", networkBitrate];
        });
    }

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //设置横屏播放
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    
    return NO;
}
- (IBAction)onDragSlideValueChanged:(id)sender {
    NSLog(@"slide changing, %f", sliderProgress.value);
    [self refreshProgress:sliderProgress.value totalDuration:cbPlayerController.duration];
}

- (IBAction)onDragSlideDone:(id)sender {
    float currentTIme = sliderProgress.value;
    NSLog(@"seek to %f", currentTIme);
    //实现视频播放位置切换，
    [cbPlayerController seekTo:currentTIme];
    //两种方式都可以实现seek操作
//    [cbPlayerController setCurrentPlaybackTime:currentTIme];
    //[mpPlayerController setCurrentPlaybackTime:currentTIme];
}
- (IBAction)onDragSlideStart:(id)sender {
    [self stopTimer];
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
- (IBAction)setSubVisible:(id)sender {
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
//}
- (IBAction)returnBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
