#import <UIKit/UIKit.h>

// 0.账号相关
#define IWAppKey @"1359433872"
#define IWAppSecret @"37c372aa97a9329fc561947151c1bd38"
#define IWRedirectURI @"http://ios.itcast.cn"
#define IWLoginURL [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", IWAppKey, IWRedirectURI]

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.自定义Log
#ifdef DEBUG
#define IWLog(...) NSLog(__VA_ARGS__)
#else
#define IWLog(...)
#endif

// 4.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

// 5.微博cell上面的属性
/** 昵称的字体 */
#define IWStatusNameFont [UIFont systemFontOfSize:15]
/** 被转发微博作者昵称的字体 */
#define IWRetweetStatusNameFont IWStatusNameFont

/** 时间的字体 */
#define IWStatusTimeFont [UIFont systemFontOfSize:12]
/** 来源的字体 */
#define IWStatusSourceFont IWStatusTimeFont

/** 正文的字体 */
#define IWStatusContentFont [UIFont systemFontOfSize:13]
/** 被转发微博正文的字体 */
#define IWRetweetStatusContentFont IWStatusContentFont

/** 表格的边框宽度 */
#define IWStatusTableBorder 5

/** cell的边框宽度 */
#define IWStatusCellBorder 10

// 6.微博cell内部相册
#define IWPhotoW 70
#define IWPhotoH 70
#define IWPhotoMargin 10

// 7.常用的对象
#define IWNotificationCenter [NSNotificationCenter defaultCenter]


#define kNavigationBarTintColor    kSetting.navigationBarTintColor
#define kNavigationBarColor        kSetting.navigationBarColor
#define kNavigationBarLineColor    kSetting.navigationBarLineColor

#define kBackgroundColorWhite      kSetting.backgroundColorWhite
#define kBackgroundColorWhiteDark  kSetting.backgroundColorWhiteDark

#define kLineColorBlackDark        kSetting.lineColorBlackDark
#define kLineColorBlackLight       kSetting.lineColorBlackLight

#define kFontColorBlackDark        kSetting.fontColorBlackDark
#define kFontColorBlackMid         kSetting.fontColorBlackMid
#define kFontColorBlackLight       kSetting.fontColorBlackLight
#define kFontColorBlackBlue        kSetting.fontColorBlackBlue

#define kColorBlue                 kSetting.colorBlue
#define kCellHighlightedColor      kSetting.cellHighlightedColor
#define kMenuCellHighlightedColor  kSetting.menuCellHighlightedColor

#define kCurrentTheme              kSetting.theme


#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

static NSString * const kShowMenuNotification = @"ShowMenuNotificaion";
static NSString * const kStatusBarTappedNotification = @"StatusBarTappedNotification";

static NSString * const kShowLoginVCNotification = @"ShowLoginVCNotification";
static NSString * const kLoginSuccessNotification = @"LoginSuccessNotification";
static NSString * const kLogoutSuccessNotification = @"LogoutSuccessNotification";

static NSString * const kThemeDidChangeNotification = @"ThemeDidChangeNotification";

static NSString * const kUpdateCheckInBadgeNotification = @"UpdateCheckInBadgeNotification";
static NSString * const kUpdateNotificationBadgeNotification = @"UpdateNotificationBadgeNotification";

static NSString * const kIgnoreTopicSuccessNotification = @"IgnoreTopicSuccessNotification";

typedef enum : NSUInteger {
    BigeventdetailStyleVideo = 1,
    BigeventdetailStyleImage,
    BigeventdetailStyleText,
} BigEventDetailStyle;

typedef enum : NSUInteger {
    NewsFilmType = 1,
    BigEventType,
} ListType;
