//
//  ShowImageVC.m
//  PrismDemo
//
//  Created by 彭光波 on 15-3-14.
//  Copyright (c) 2015年 pengguangbo. All rights reserved.
//

#import "ShowImageVC.h"
#import "PrismCommImageCell.h"
#import "UIImageView+WebCache.h"
#import "NAApiConstants.h"
#import "LvModelWindow.h"
#import "LvPhotoViewerView.h"

static const NSUInteger PrismSizePerRow = 3;
static const CGFloat PrismCollectionViewSectionHorizonPadding = 22.f;
static const CGFloat PrismCollectionViewSectionPaddingTop = 20.f;
static const CGFloat PrismCollectionViewCellHorizonSpacing = 10.f;

static NSString * const ShowedImageCellReuseIdentifier = @"ShowedImageCell";

@interface ShowImageVC () <LvModelWindowDelegate, LvPhotoViewerViewDelegate>

@property (nonatomic) LvModelWindow *photoViewerModelWindow;
@property (nonatomic) LvPhotoViewerView *photoViewer;

@end

@implementation ShowImageVC

+ (UINavigationController *)initShowImageNavVCFromStoryboard
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Prism" bundle:nil];
    UINavigationController *nav = [board instantiateViewControllerWithIdentifier:@"ShowImageNavVC"];
    return nav;
}

- (instancetype)init
{
    return [self initFromStoryboard];
}

- (instancetype)initFromStoryboard
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Prism" bundle:nil];
    return [board instantiateViewControllerWithIdentifier:@"ShowImageVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[PrismCommImageCell class]
            forCellWithReuseIdentifier:ShowedImageCellReuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvPhotoItemScrollViewTapNote:)
                                                 name:LvPhotoItemScrollViewTappedNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LvPhotoItemScrollViewTappedNotification
                                                  object:nil];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrlList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PrismCommImageCell *commCell = [collectionView dequeueReusableCellWithReuseIdentifier:ShowedImageCellReuseIdentifier forIndexPath:indexPath];
    
    NSString *imageUrl = self.imageUrlList[indexPath.row];
    NSURL *imageURL = nil;
    if (imageUrl) {
        imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                         NAServerBaseUrl,
                                         imageUrl]];
    }
    commCell.backgroundColor = [UIColor blackColor];
    [commCell.pActyIndicatorView startAnimating];
    [commCell.pImageView setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [commCell.pActyIndicatorView stopAnimating];
        });
    }];
    return commCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionViewWidth = CGRectGetWidth(collectionView.frame);
    
    CGFloat cellWidth = ((collectionViewWidth - PrismCollectionViewSectionHorizonPadding*2) - (PrismSizePerRow - 1)*PrismCollectionViewCellHorizonSpacing)/PrismSizePerRow;
    CGFloat cellHeight = cellWidth * 228.f/352.f;
    
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsMake(PrismCollectionViewSectionPaddingTop,
                                           PrismCollectionViewSectionHorizonPadding,
                                           0,
                                           PrismCollectionViewSectionHorizonPadding);
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return PrismCollectionViewCellHorizonSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return PrismCollectionViewCellHorizonSpacing;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.photoViewerModelWindow showWithAnimated:YES];
    [self.photoViewer scrollToPage:indexPath.row animated:NO];
}

- (void)recvPhotoItemScrollViewTapNote:(NSNotification *)note
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)note.object;
    
    if (gesture.numberOfTapsRequired == 1) {
        [_photoViewerModelWindow dismissWithAnimated:YES];
    }
}

- (LvModelWindow *)photoViewerModelWindow
{
    if (!_photoViewerModelWindow) {
        LvModelWindow *win = [[LvModelWindow alloc]initWithPreferStatusBarHidden:YES
                                                    supportedOrientationPortrait:YES
                                          supportedOrientationPortraitUpsideDown:NO
                                               supportedOrientationLandscapeLeft:NO
                                              supportedOrientationLandscapeRight:NO];
        win.modelWindowDelegate = self;
        _photoViewerModelWindow = win;
        
        if (!_photoViewer) {
            LvPhotoViewerView *photoViewer = [[LvPhotoViewerView alloc]initWithFrame:win.windowRootView.bounds];
            photoViewer.delegate = self;
            photoViewer.backgroundColor = [UIColor blackColor];
            photoViewer.frame = win.windowRootView.bounds;
            photoViewer.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [win.windowRootView addSubview:photoViewer];
            _photoViewer = photoViewer;
        }
    }
    return _photoViewerModelWindow;
}

#pragma mark - LvModelWindowDelegate

- (void)modelWindowDidShow:(LvModelWindow *)modelWindow
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)modelWindowDidDismiss:(LvModelWindow *)modelWindow
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - LvPhotoViewerViewDelegate

- (NSUInteger)numbersOfPhotoItem:(LvPhotoViewerView *)viewer
{
    return self.imageUrlList.count;
}

- (void)        photoViewer:(LvPhotoViewerView *)viewer
   willShowPhotoOnImageView:(UIImageView *)imageView
                    atIndex:(NSUInteger)index
{
    if (index < self.imageUrlList.count) {
        NSString *imageUrl = self.imageUrlList[index];
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                NAServerBaseUrl,
                                                imageUrl]];
        [imageView setImageWithURL:imageURL];
    }
}

@end
