//
//  SNSLCommentPhotoPickController.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentPhotoPickController.h"
#import "SNSLCommentPhotoCell.h"
#import "SNSLCommentAlbumController.h"
#import <Toast.h>
#import "SNSLCommentPhotoPreviewController.h"
#import <UIColor+Additions.h>
#import "SNSLCommentNavigationBar.h"

@interface SNSLCommentPhotoPickController ()<UICollectionViewDelegate, UICollectionViewDataSource, SNSLCommentAlbumControllerDelegate>

@property (nonatomic, strong) UICollectionView *mainCollectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) SNSLCommentAlbumController *albumVC;

@property (nonatomic, assign) BOOL isShowAlbum;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) UIButton *confirmItem;

@property (nonatomic, strong) UILabel *noAuthorTitle;

@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic, strong) SNSLCommentNavigationBar *naviBar;

@property (nonatomic, strong) UIButton *previewBtn;

@end

@implementation SNSLCommentPhotoPickController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowAlbum = NO;
    if (@available(iOS 11.0, *)) {
        self.mainCollectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configAuthorizationUI{
    self.navigationController.navigationBar.hidden = YES;

    [self.view addSubview:self.mainCollectView];
    [self.mainCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-Get375Width(56) - kBottomHeight);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNaviBarHeight);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previewBtn = button;
    [button setTitle:@"预览" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:Get375Width(14)];
    [button setTitleColor:[UIColor add_colorWithRGBHexString:@"dddddd"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bottomView addSubview:button];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomHeight);
        make.height.mas_equalTo(Get375Width(56));
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(Get375Width(14));
    }];
    
    [self.view addSubview:self.coverView];
    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNaviBarHeight);
    }];
    
    self.naviBar = [[SNSLCommentNavigationBar alloc]initTitle:@"全部图片" titleImage:@"snsl_comment_down" leftTitle:@"取消" leftImage:@""];
    __weak typeof(self)weakSelf = self;
    self.naviBar.leftAction = ^{
        [weakSelf cancel];
    };
    self.naviBar.rightAction = ^{
        [weakSelf confirm];
    };
    self.naviBar.titleAction = ^{
        [weakSelf handleAlbum];
    };
    [self.view addSubview:self.naviBar];
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kNaviBarHeight);
    }];
}

- (void)showNoAuthorization{
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"照片";
    [self.view addSubview:self.noAuthorTitle];
    [self.view addSubview:self.setBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    [self.noAuthorTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(Get375Width(-467));
    }];
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.noAuthorTitle.mas_bottom).offset(0);
        make.width.mas_equalTo(70);
    }];
}

- (void)hiddenNoAuthorization{
    [self configAuthorizationUI];
}

#pragma mark - getters and setters

- (void)setAlbumModel:(SNSLCommentAlbumModel *)albumModel{
    _albumModel = albumModel;
    [self setRightBarNumber];
    
    NSLog(@"\n========currentAlbum = %@ \n ========allSelect = %@,",self.albumModel.selectedModels, PickManger.selectModels);
    [self.mainCollectView reloadData];
    if (_albumModel.models.count<=0) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mainCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_albumModel.models.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    });
}

- (UILabel *)noAuthorTitle
{
    if (!_noAuthorTitle) {
        _noAuthorTitle = [[UILabel alloc]init];
        NSDictionary *infoDict = [PickManger getInfoDictionary];
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
        _noAuthorTitle.text = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册",appName];
        _noAuthorTitle.numberOfLines = 0;
        _noAuthorTitle.font = [UIFont systemFontOfSize:Get375Width(16)];
        _noAuthorTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _noAuthorTitle;
}

- (UIButton *)setBtn
{
    if (!_setBtn) {
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_setBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _setBtn.titleLabel.font = [UIFont systemFontOfSize:Get375Width(16)];
        [_setBtn addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}

- (void)goSetting{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]init];
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _coverView.hidden = YES;
    }
    return _coverView;
}

- (UICollectionView *)mainCollectView
{
    if (!_mainCollectView) {
        _mainCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectView.delegate = self;
        _mainCollectView.dataSource = self;
        _mainCollectView.backgroundColor = [UIColor whiteColor];
       [_mainCollectView registerClass:[SNSLCommentPhotoCell class] forCellWithReuseIdentifier:[SNSLCommentPhotoCell cellIdentifier]];
    }
    return _mainCollectView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.sectionInset = UIEdgeInsetsMake(Get375Width(10), Get375Width(14), Get375Width(10), Get375Width(14));
        _layout.itemSize = CGSizeMake(floor((kScreenWidth - Get375Width(48))/3.0), floor((kScreenWidth - Get375Width(48))/3.0));
        _layout.minimumLineSpacing = Get375Width(10);
        _layout.minimumInteritemSpacing = Get375Width(10);
    }
    return _layout;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.albumModel.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SNSLCommentPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:[SNSLCommentPhotoCell cellIdentifier] forIndexPath:indexPath];
    photoCell.clickAction = nil;
    [photoCell configCellWithAsset:[self.albumModel.models objectAtIndex:indexPath.row]];
    return photoCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SNSLCommentPhotoCell *photoCell = (SNSLCommentPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (!photoCell.model.isSelected && (PickManger.selectModels.count == PickManger.maxPickCount)) {
        [self.view makeToast:[NSString stringWithFormat:@"最多选%li张图片",(long)PickManger.maxPickCount]];
        return;
    }
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
    
    //改变确定按钮的数字
    [self setRightBarNumber];
    //设置当前选中的数字，0：隐藏 其他显示
    photoCell.selectIndex = photoCell.model.selectIndex;
    //同步到整体的selectedModels
    [PickManger synchronizeSelectModel:photoCell.model];
    
    if (!photoCell.model.isSelected) {
        //删减图片需要重新排序,里面更新当前相册selectedModels
        [PickManger synchronizeAlbum:self.albumModel];
        NSMutableArray *indexPathArray = [NSMutableArray array];
        for (SNSLCommentAssetModel *model in self.albumModel.selectedModels) {
            NSInteger row = [self.albumModel.models indexOfObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPathArray addObject:indexPath];
        }
        [self.mainCollectView reloadItemsAtIndexPaths:indexPathArray];
    }
    else{
        //更新更新当前相册selectedModels
        [self.albumModel.selectedModels addObject:photoCell.model];
    }
    NSLog(@"\n========currentAlbum = %@ \n ========allSelect = %@,",self.albumModel.selectedModels, PickManger.selectModels);
}

#pragma mark - SNSLCommentAlbumControllerDelegate
- (void)clickAlbum:(SNSLCommentAlbumModel *)album{
    [self hiddenAlbum];
    self.naviBar.titleLabel.text = album.name;
    [PickManger synchronizeAlbum:album];
    self.albumModel = album;
}

#pragma mark - action
- (void)setRightBarNumber{
    if (PickManger.currrentSelectIndex == 0) {
        [self.naviBar.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.naviBar.rightBtn setBackgroundColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.00]];
        [self.naviBar.rightBtn setTitleColor:[UIColor add_colorWithRGBHexString:@"e0e0e0"] forState:UIControlStateNormal];
        [self.previewBtn setTitleColor:[UIColor add_colorWithRGBHexString:@"dddddd"] forState:UIControlStateNormal];
    }
    else{
        [self.naviBar.rightBtn setTitle:[NSString stringWithFormat:@"确定(%li)", (long)PickManger.currrentSelectIndex] forState:UIControlStateNormal];
        [self.naviBar.rightBtn setBackgroundColor:[UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00]];
        [self.naviBar.rightBtn setTitleColor:[UIColor add_colorWithRGBHexString:@"ffffff"] forState:UIControlStateNormal];
        [self.previewBtn setTitleColor:[UIColor add_colorWithRGBHexString:@"666666"] forState:UIControlStateNormal];
    }
}

- (void)preview{
    if (PickManger.selectModels.count == 0) {
        [self.view makeToast:@"你尚未选择图片"];
        return;
    }
    __weak typeof(self)weakSelf = self;
    SNSLCommentPhotoPreviewController *previewVC = [[SNSLCommentPhotoPreviewController alloc]initWithBackAction:^{
        [PickManger reSetAlbum:weakSelf.albumModel];
        [PickManger synchronizeAlbum:weakSelf.albumModel];
        [weakSelf.mainCollectView reloadData];
        [weakSelf setRightBarNumber];
    }];
    previewVC.selectModels = [PickManger.selectModels copy];
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)handleAlbum{
    if (!self.albumVC) {
        self.albumVC = [[SNSLCommentAlbumController alloc]init];
        self.albumVC.delegate = self;
        UITapGestureRecognizer *tapGet = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlbum)];
        tapGet.delegate = self.albumVC;
        [self.albumVC.view addGestureRecognizer:tapGet];
        [self.view insertSubview:self.albumVC.view aboveSubview:self.coverView];
        [self.albumVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_top);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.view.mas_height);
        }];
        [self.view layoutIfNeeded];
    }
    if (self.isShowAlbum) {
        [self hiddenAlbum];
    }
    else{
        [self showAlbum];
    }
}

- (void)hiddenAlbum{
   __weak typeof(self)weakSelf = self;
    self.naviBar.titleImageView.image = [UIImage imageNamed:@"snsl_comment_down"];
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.albumVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_top);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.view.mas_height);
        }];
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.isShowAlbum = NO;
        weakSelf.coverView.hidden = YES;
    }];
}

- (void)showAlbum{
    __weak typeof(self)weakSelf = self;
     self.naviBar.titleImageView.image = [UIImage imageNamed:@"snsl_comment_up"];
    [PickManger getAllAlbumComplete:^(NSArray<SNSLCommentAlbumModel *> *albumModel) {
        weakSelf.albumVC.albums = albumModel;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.albumVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.view.mas_height);
            make.top.mas_equalTo(kNaviBarHeight);
        }];
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.isShowAlbum = YES;
        weakSelf.coverView.hidden = NO;
    }];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
