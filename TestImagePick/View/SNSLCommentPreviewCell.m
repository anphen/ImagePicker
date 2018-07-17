//
//  SNSLCommentPreviewCell.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/8.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentPreviewCell.h"
#import <Masonry.h>

NSString * const SNSLCommentImagePickUpdateFullScreenState = @"SNSLCommentImagePickUpdateFullScreenState";

@interface SNSLCommentPreviewCell()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *zoomScrollView;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation SNSLCommentPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.zoomScrollView = [[UIScrollView alloc]init];
        self.zoomScrollView.minimumZoomScale = 1.0;
        self.zoomScrollView.maximumZoomScale = 2.5;
        self.zoomScrollView.delegate = self;
        self.zoomScrollView.frame = self.contentView.bounds;
        
        self.photo = [[UIImageView alloc]init];
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        self.photo.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        self.photo.center = self.contentView.center;
        self.selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snsl_comment_selected"]];
        self.selectImageView.userInteractionEnabled = YES;
        self.selectImageView.contentMode = UIViewContentModeCenter;
        self.selectImageView.hidden = YES;
        
        self.maskView = [[UIView alloc]init];
        self.maskView.hidden = YES;
        self.maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        
        [self.contentView addSubview:self.zoomScrollView];
        
        [self.zoomScrollView addSubview:self.photo];
        
        [self.contentView addSubview:self.selectImageView];
        
        [self.contentView addSubview:self.maskView];
        
        [self.zoomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(22 + Get375Width(10));
            make.top.mas_equalTo(kNaviBarHeight + Get375Width(15) + Get375Width(10));
            make.right.mas_equalTo(self.contentView.mas_right).offset(-Get375Width(10));
        }];
        
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFullScreen:) name:SNSLCommentImagePickUpdateFullScreenState object:nil];
        
    }
    return self;
}

- (void)updateFullScreen:(NSNotification *)notification{
    NSNumber *fullScreen = [notification.userInfo valueForKey:@"fullScreenState"];
    self.isFullScreen = fullScreen.boolValue;
}

- (void)singleTap{
    if (self.singleTapAction) {
        self.singleTapAction(self);
    }
}

- (void)selectAction{
    if (self.clickAction) {
        self.clickAction(self);
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap{
    if (self.zoomScrollView.zoomScale > 1.0) {
        [self.zoomScrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.photo];
        CGFloat scale = self.zoomScrollView.maximumZoomScale;
        CGRect newRect = [self getRectWithScale:scale andCenter:touchPoint];
        [self.zoomScrollView zoomToRect:newRect animated:YES];
    }
}

- (CGRect)getRectWithScale:(CGFloat)scale andCenter:(CGPoint)center{
    CGRect newRect = CGRectZero;
    newRect.size.width =  self.zoomScrollView.frame.size.width/scale;
    newRect.size.height = self.zoomScrollView.frame.size.height/scale;
    newRect.origin.x = center.x - newRect.size.width * 0.5;
    newRect.origin.y = center.y - newRect.size.height * 0.5;
    return newRect;
}

- (void)setCellType:(SNSLCommentPreviewCellType)cellType
{
    _cellType = cellType;
    if (cellType == SNSLCommentPreviewCellTypeBig) {
        self.selectImageView.hidden = NO;
        [self.selectImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAction)]];
         self.photo.contentMode = UIViewContentModeScaleAspectFit;
        self.contentView.multipleTouchEnabled = YES;
        UITapGestureRecognizer *signleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
        [self.contentView addGestureRecognizer:signleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.delegate = self;
        doubleTap.numberOfTapsRequired = 2;
        [signleTap requireGestureRecognizerToFail:doubleTap];
        [self.contentView addGestureRecognizer:doubleTap];
    }
    if (cellType == SNSLCommentPreviewCellTypeSmall) {
        self.selectImageView.hidden = YES;
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.zoomScrollView.userInteractionEnabled = NO;
    }
}

- (void)configCellWithAsset:(SNSLCommentAssetModel *)model{
    self.model = model;
    self.selectState = model.isSelected;
    CGFloat pixelWidth = 0.0;
    CGFloat pixelHeight = 0.0;
    if (self.cellType == SNSLCommentPreviewCellTypeBig) {
        PHAsset *phAsset = (PHAsset *)model.asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        pixelWidth = kScreenWidth * PickManger.screenScale * 1.5;
        // 超宽图片
        if (aspectRatio > 1.8) {
            pixelWidth = pixelWidth * aspectRatio;
        }
        // 超高图片
        if (aspectRatio < 0.2) {
            pixelWidth = pixelWidth * 0.5;
        }
        pixelHeight = pixelWidth / aspectRatio;
    }
    
    if (self.cellType == SNSLCommentPreviewCellTypeSmall) {
        pixelWidth = Get375Width(62) *PickManger.screenScale;
        pixelHeight = pixelWidth;
    }
    
    __weak typeof(self)weakSelf = self;
    [PickManger getImageViewAsset:model.asset width:pixelWidth height:pixelHeight complete:^(UIImage *image) {
        weakSelf.photo.image = image;
    }];
}

+ (NSString *)cellIdentifierWithType:(SNSLCommentPreviewCellType)cellType{
    if (cellType == SNSLCommentPreviewCellTypeBig) {
        return @"SNSLCommentPreviewBigCellIdentifier";
    }
    if (cellType == SNSLCommentPreviewCellTypeSmall) {
        return @"SNSLCommentPreviewSmallCellIdentifier";
    }
    return @"SNSLCommentPreviewBigCellIdentifier";
}


- (void)setSelectState:(BOOL)selectState{
    _selectState = selectState;
    if (selectState) {
        if (self.cellType == SNSLCommentPreviewCellTypeBig) {
            self.selectImageView.image = [UIImage imageNamed:@"snsl_comment_selected"];
        }
        if (self.cellType == SNSLCommentPreviewCellTypeSmall) {
            self.maskView.hidden = YES;
        }
    }
    else{
        if (self.cellType == SNSLCommentPreviewCellTypeBig) {
            self.selectImageView.image = [UIImage imageNamed:@"snsl_comment_cancelsel"];
        }
        if (self.cellType == SNSLCommentPreviewCellTypeSmall) {
            self.maskView.hidden = NO;
        }
    }
}

- (void)setIsStroke:(BOOL)isStroke
{
    _isStroke = isStroke;
    if (isStroke) {
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00].CGColor;
    }
    else{
         self.contentView.layer.borderWidth = 0;
    }
}

- (void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;
    if (isFullScreen && self.cellType == SNSLCommentPreviewCellTypeBig) {
        self.selectImageView.hidden = YES;
    }else if (self.cellType == SNSLCommentPreviewCellTypeBig){
        self.selectImageView.hidden = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photo;
}

#pragma mark - UIGestureRecognizerDelegate

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

