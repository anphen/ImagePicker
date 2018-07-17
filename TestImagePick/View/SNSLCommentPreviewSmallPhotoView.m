//
//  SNSLCommentPreviewSmallPhotoView.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/8.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentPreviewSmallPhotoView.h"
#import "SNSLCommentPreviewCell.h"
#import <Masonry.h>

@interface SNSLCommentPreviewSmallPhotoView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mainCollectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) SNSLCommentPreviewCell *currentSelectCell;

@end

@implementation SNSLCommentPreviewSmallPhotoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentSelectIndex = 0;
        [self addSubview:self.mainCollectView];
        [self.mainCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (UICollectionView *)mainCollectView
{
    if (!_mainCollectView) {
        _mainCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:0.5];
        _mainCollectView.delegate = self;
        _mainCollectView.dataSource = self;
        [_mainCollectView registerClass:[SNSLCommentPreviewCell class] forCellWithReuseIdentifier:[SNSLCommentPreviewCell cellIdentifierWithType:SNSLCommentPreviewCellTypeSmall]];
        if (@available(iOS 11.0, *)) {
            _mainCollectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _mainCollectView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake(Get375Width(62), Get375Width(62));
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = Get375Width(9);
        _layout.minimumInteritemSpacing = Get375Width(9);
        _layout.sectionInset = UIEdgeInsetsMake(Get375Width(15), Get375Width(15), Get375Width(15), Get375Width(15));
    }
    return _layout;
}

- (void)relodIndexPath:(NSIndexPath *)indexPath{
    if (indexPath) {
        [self.mainCollectView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex{
    if (self.currentSelectCell) {
        self.currentSelectCell.isStroke = NO;
    }
    SNSLCommentPreviewCell *cell = (SNSLCommentPreviewCell *)[self.mainCollectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentSelectIndex inSection:0]];
    cell.isStroke = YES;
    self.currentSelectCell = cell;
    _currentSelectIndex = currentSelectIndex;
}

- (void)setSelectModels:(NSArray<SNSLCommentAssetModel *> *)selectModels
{
    _selectModels = selectModels;
    [self.mainCollectView reloadData];
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
    SNSLCommentPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SNSLCommentPreviewCell cellIdentifierWithType:SNSLCommentPreviewCellTypeSmall] forIndexPath:indexPath];
    
    cell.cellType = SNSLCommentPreviewCellTypeSmall;
    SNSLCommentAssetModel *model = [self.selectModels objectAtIndex:indexPath.row];
    [cell configCellWithAsset:model];
    if (indexPath.row == self.currentSelectIndex) {
        cell.isStroke = YES;
        self.currentSelectCell = cell;
    }
    else{
        cell.isStroke = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentSelectIndex = indexPath.row;
    if (self.clickAction) {
        self.clickAction(indexPath.row);
    }
}

@end
