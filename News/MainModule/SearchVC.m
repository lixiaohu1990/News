//
//  SearchVC.m
//  News
//
//  Created by 彭光波 on 15-3-19.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "SearchVC.h"
#import "NSString+lv.h"
#import "NAAPIGetTagList.h"
#import "NAAPIGetTag.h"
#import "SVProgressHUD.h"
#import "SearchResaultTableViewController.h"
@interface TagCell : UICollectionViewCell
@property (nonatomic, readonly) UILabel *tagLabel;

+ (UIFont *)tagLabelFont;

@end

@implementation TagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTagCell];
    }
    return self;
}

- (void)setupTagCell
{
    UILabel *tagLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    tagLabel.backgroundColor = [UIColor clearColor];
    tagLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tagLabel.textColor = [UIColor colorWithRed:1.f/255.f
                                         green:19.f/255.f
                                          blue:43.f/255.f
                                         alpha:1];
    tagLabel.font = [TagCell tagLabelFont];
    [self.contentView addSubview:tagLabel];
    
    _tagLabel = tagLabel;
}

+ (UIFont *)tagLabelFont
{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:14.f];
    });
    return font;
}

@end

static NSString *const TagCellIdentifier = @"TagCell";

@interface SearchVC () <UICollectionViewDataSource, UICollectionViewDelegate, NABaseApiResultHandlerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *searchField;
@property (nonatomic, weak) IBOutlet UICollectionView *tagCollectionView;

@property (nonatomic) NAAPIGetTag *getTagReq;
@property (nonatomic) NSArray *tagArray;

@end

@implementation SearchVC

- (instancetype)initFromStoryboard
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainModule" bundle:nil];
    self = [board instantiateViewControllerWithIdentifier:@"SearchVC"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchVC];
    
    [self loadTags];
}

- (void)setupSearchVC
{
    _tagCollectionView.delegate = self;
    _tagCollectionView.dataSource = self;
    [_tagCollectionView registerClass:[TagCell class]
           forCellWithReuseIdentifier:TagCellIdentifier];
    _tagCollectionView.backgroundColor = [UIColor clearColor];
    
    [((UIControl *)self.view) addTarget:self
                                 action:@selector(touchDownBackground)
                       forControlEvents:UIControlEventTouchDown];
    
    self.searchField.returnKeyType = UIReturnKeySearch;
    [self.searchField addTarget:self
                         action:@selector(searchFieldEditingDidEndOnExit)
               forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)touchDownBackground
{
    [self.searchField resignFirstResponder];
}

- (void)searchFieldEditingDidEndOnExit
{
    [self.searchField resignFirstResponder];
    
    NSString *searchTag = [self.searchField text];
    DLOG(@"searchTag: %@", searchTag);
    
    // TODO: goto search view controller
    SearchResaultTableViewController *control = [[SearchResaultTableViewController alloc] initWithSearchStr:searchTag];
    [self.navigationController pushViewController:control animated:YES];
    
}


#pragma mark - Requests

- (void)loadTags
{
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeClear];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _getTagReq = [[NAAPIGetTag alloc] initWithSelf];
        _getTagReq.APIRequestResultHandlerDelegate = self;
        [_getTagReq asyncRequest];
    });
}

#pragma mark - NABaseApiResultHandlerDelegate methods

- (void)failCauseNetworkUnavaliable:(id)request
{
    DLOG(@"failCauseNetworkUnavaliable");
    [SVProgressHUD dismiss];
}

- (void)failCauseRequestTimeout:(id)request
{
    DLOG(@"failCauseRequestTimeout");
    [SVProgressHUD dismiss];
}

- (void)failCauseServerError:(id)request
{
    DLOG(@"failCauseServerError.");
    [SVProgressHUD dismiss];
}

- (void)failCauseBissnessError:(id)apiRequest
{
    DLOG(@"failCauseBissnessError, status:%@", ((NABaseApi *)apiRequest).respStatus);
    [SVProgressHUD dismiss];
}

- (void)failCauseSystemError:(id)apiRequest
{
    DLOG(@"failCauseSystemError, status:%@", ((NABaseApi *)apiRequest).respStatus);
    [SVProgressHUD dismiss];
}

- (void)failCauseParamError:(id)apiRequest
{
    DLOG(@"failCauseParamError, status:%@", ((NABaseApi *)apiRequest).respStatus);
    [SVProgressHUD dismiss];
}

#pragma mark - Correct result handler
- (void)request:(id)request successRequestWithResult:(id)requestResult
{
    [SVProgressHUD dismiss];
    
    // TODO：这个api不应该这样写
    NSArray *tagArray = requestResult[@"tags"];
    self.tagArray = tagArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tagCollectionView reloadData];
    });
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCell *tagCell = (TagCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TagCellIdentifier
                                                                            forIndexPath:indexPath];
    tagCell.backgroundColor = [UIColor clearColor];
    
    NSString *tag = _tagArray[indexPath.row];
    tagCell.tagLabel.text = tag;
    
    return tagCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 计算大小，也可以使用缓存
    NSString *tag = _tagArray[indexPath.row];
    CGSize tagTxtSize = [tag sizeWithConstraintWidth:MAXFLOAT font:[TagCell tagLabelFont]];
    
    return tagTxtSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Go to tag view controller
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *tag = _tagArray[indexPath.row];
    DLOG(@"select tag: %@", tag);
    
    SearchResaultTableViewController *control = [[SearchResaultTableViewController alloc] initWithSearchStr:tag];
    [self.navigationController pushViewController:control animated:YES];
}

@end
