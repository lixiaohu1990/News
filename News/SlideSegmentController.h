
#import <UIKit/UIKit.h>

extern NSString *const segmentBarItemID;

@class SlideSegmentController;

@protocol SlideSegmentDataSource <NSObject>
@required

- (NSInteger)slideSegment:(UICollectionView *)segmentBar
   numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)slideSegment:(UICollectionView *)segmentBar
            cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInslideSegment:(UICollectionView *)segmentBar;

@end

@protocol SlideSegmentDelegate <NSObject>
@optional
- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController;

- (BOOL)slideSegment:(UICollectionView *)segmentBar shouldSelectViewController:(UIViewController *)viewController;
@end

@interface SlideSegmentController : UIViewController

/**
 *  Child viewControllers of SlideSegmentController
 */
@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, strong, readonly) UICollectionView *segmentBar;
@property (nonatomic, strong, readonly) UIScrollView *slideView;
@property (nonatomic, strong, readonly) UIView *indicator;

@property (nonatomic, assign) UIEdgeInsets indicatorInsets;

@property (nonatomic, weak, readonly) UIViewController *selectedViewController;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

@property (nonatomic, assign) id <SlideSegmentDelegate> delegate;
@property (nonatomic, assign) id <SlideSegmentDataSource> dataSource;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;

@end
