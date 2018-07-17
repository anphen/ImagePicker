//
//  SNSLCommentPhotoPreviewController.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentPhotoPreviewController.h"
#import "SNSLCommentPreviewCell.h"
#import "SNSLCommentPreviewSmallPhotoView.h"
#import "SNSLCommentNavigationBar.h"
#import <UIColor+Additions.h>
#import <Toast.h>

extern NSString * const SNSLCommentImagePickUpdateFullScreenState;

@interface SNSLCommentPhotoPreviewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mainCollectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIView *grayBar;
@property (nonatomic, strong) SNSLCommentPreviewSmallPhotoView *smallPhotoView;

@property (nonatomic, assign) BOOL fullScreenShow;//defaultNO

@property (nonatomic, strong) UIView *topMask;
@property (nonatomic, strong) UIView *bottomMask;
@property (nonatomic, strong) SNSLCommentNavigationBar *naviBar;

@property (nonatomic, copy) void(^backAction)(void);

@end

@implementation SNSLCommentPhotoPreviewController

- (instancetype)initWithBackAction:(void(^)(void))Backaction
{
    self = [super init];
    if (self) {
        self.fullScreenShow = NO;
        self.backAction = Backaction;
        
        if (@available(iOS 11.0, *)) {
             self.mainCollectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
       
        self.navigationController.navigationBar.hidden = YES;
        __weak typeof(self)weakSelf = self;
        self.naviBar = [[SNSLCommentNavigationBar alloc]initTitle:@"" titleImage:@"" leftTitle:@"" leftImage:@"snsl_comment_back"];
        self.naviBar.leftAction = ^{
            [weakSelf pop];
        };
        self.naviBar.rightAction = ^{
            [weakSelf confirm];
        };
    }
    return self;
}

- (void)confirm{
    if (PickManger.selectModels.count == 0) {
        [self.view makeToast:@"你尚未选择图片"];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if (PickManger.finishCallBack) {
        PickManger.finishCallBack(PickManger.selectedAssets);
    }
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backAction) {
        self.backAction();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.view addSubview:self.mainCollectView];
    self.grayBar = [[UIView alloc]init];
    self.grayBar.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
//    self.grayBar.backgroundColor = [UIColor clearColor];
    [self.mainCollectView addSubview:self.grayBar];
    [self.mainCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomHeight);
    }];
    [self.grayBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(kNaviBarHeight);
        make.height.mas_equalTo(15);
    }];
    
    [self.view addSubview:self.smallPhotoView];
    [self.smallPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_offset(0);
        make.bottom.mas_equalTo(- kBottomHeight);
        make.height.mas_equalTo(Get375Width(92));
    }];
    self.topMask = [[UIView alloc]init];
    self.topMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.topMask.hidden = YES;
    self.bottomMask = [[UIView alloc]init];
    self.bottomMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.bottomMask.hidden = YES;
    [self.mainCollectView addSubview:self.topMask];
    [self.mainCollectView addSubview:self.bottomMask];
    [self.topMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(Get375Width(77));
    }];
    [self.bottomMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kBottomHeight);
        make.height.mas_equalTo(Get375Width(90));
    }];
    
    [self.view addSubview:self.naviBar];
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kNaviBarHeight);
    }];
}

- (UICollectionView *)mainCollectView
{
    if (!_mainCollectView) {
        _mainCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        _mainCollectView.delegate = self;
        _mainCollectView.dataSource = self;
        _mainCollectView.pagingEnabled = YES;
        _mainCollectView.showsHorizontalScrollIndicator = NO;
        _mainCollectView.showsVerticalScrollIndicator = NO;
        [_mainCollectView registerClass:[SNSLCommentPreviewCell class] forCellWithReuseIdentifier:[SNSLCommentPreviewCell cellIdentifierWithType:SNSLCommentPreviewCellTypeBig]];
    }
    return _mainCollectView;
}

- (void)clickImage:(SNSLCommentPreviewCell *)previewCell{
    self.fullScreenShow = !self.fullScreenShow;
    if (self.fullScreenShow) {
        self.smallPhotoView.hidden = YES;
        self.grayBar.hidden = YES;
        self.naviBar.hidden = YES;
        self.topMask.hidden = NO;
        self.bottomMask.hidden = NO;
    }
    else{
        self.smallPhotoView.hidden = NO;
        self.grayBar.hidden = NO;
        self.naviBar.hidden = NO;
        self.topMask.hidden = YES;
        self.bottomMask.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:SNSLCommentImagePickUpdateFullScreenState object:nil userInfo:@{@"fullScreenState" : @(self.fullScreenShow)}];
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - kBottomHeight);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
    }
    return _layout;
}

- (SNSLCommentPreviewSmallPhotoView *)smallPhotoView
{
    if (!_smallPhotoView) {
        _smallPhotoView = [[SNSLCommentPreviewSmallPhotoView alloc]init];
        __weak typeof(self)weakSelf = self;
        _smallPhotoView.clickAction = ^(NSInteger index) {
            [weakSelf.mainCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        };
    }
    return _smallPhotoView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.selectModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SNSLCommentPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SNSLCommentPreviewCell cellIdentifierWithType:SNSLCommentPreviewCellTypeBig] forIndexPath:indexPath];
    
    cell.cellType = SNSLCommentPreviewCellTypeBig;
    SNSLCommentAssetModel *model = [self.selectModels objectAtIndex:indexPath.row];
    [cell configCellWithAsset:model];
    cell.isFullScreen = self.fullScreenShow;
    __weak typeof(self)weakSelf = self;
    cell.singleTapAction = ^(SNSLCommentPreviewCell *photoCell) {
        [weakSelf clickImage:photoCell];
    };
    cell.clickAction = ^(SNSLCommentPreviewCell *photoCell) {
        photoCell.model.isSelected = !photoCell.model.isSelected;
        photoCell.selectState = photoCell.model.isSelected;
        if (photoCell.model.isSelected) {
            PickManger.currrentSelectIndex++;
            photoCell.model.selectIndex = PickManger.currrentSelectIndex;
        }
        else{
            PickManger.currrentSelectIndex--;
            photoCell.model.selectIndex = 0;
        }
        
        [weakSelf setRightBarNumber];
        NSIndexPath *indexPath = [weakSelf.mainCollectView indexPathForCell:photoCell];
        
        [weakSelf.smallPhotoView relodIndexPath: [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        
        [PickManger synchronizeSelectModel:photoCell.model];
        
    };
    return cell;
}

- (void)setSelectModels:(NSArray<SNSLCommentAssetModel *> *)selectModels{
    _selectModels = selectModels;
    _mainCollectView.contentSize = CGSizeMake(kScreenWidth *selectModels.count, 0);
    [self setRightBarNumber];
    [self.mainCollectView reloadData];
    self.smallPhotoView.selectModels = selectModels;
}

- (void)setRightBarNumber{
    if (PickManger.currrentSelectIndex == 0) {
        [self.naviBar.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.naviBar.rightBtn setBackgroundColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.00]];
        [self.naviBar.rightBtn setTitleColor:[UIColor add_colorWithRGBHexString:@"e0e0e0"] forState:UIControlStateNormal];
    }
    else{
        [self.naviBar.rightBtn setTitle:[NSString stringWithFormat:@"确定(%li)", (long)PickManger.currrentSelectIndex] forState:UIControlStateNormal];
        [self.naviBar.rightBtn setBackgroundColor:[UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00]];
        [self.naviBar.rightBtn setTitleColor:[UIColor add_colorWithRGBHexString:@"ffffff"] forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    self.smallPhotoView.currentSelectIndex = index;
}

@end
