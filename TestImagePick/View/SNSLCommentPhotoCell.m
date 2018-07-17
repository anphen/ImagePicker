//
//  SNSLCommentPhotoCell.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/6.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentPhotoCell.h"
#import "SNSLCommentAssetModel.h"
#import <Masonry.h>
#import "SNSLCommentImagePickManager.h"

@interface SNSLCommentPhotoCell()

@property (nonatomic, strong) UIImageView *photo;

@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation SNSLCommentPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.indexLabel = [[UILabel alloc]init];
        self.indexLabel.font = [UIFont systemFontOfSize:Get375Width(15)];
        self.indexLabel.textColor = [UIColor whiteColor];
        self.indexLabel.hidden = YES;
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        self.photo = [[UIImageView alloc]init];
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        self.selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snsl_comment_unsel"]];
        [self.contentView addSubview:self.photo];
        [self.contentView addSubview:self.selectImageView];
        [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(Get375Width(22));
            make.top.mas_equalTo(Get375Width(4));
            make.right.mas_equalTo(self.photo.mas_right).offset(-Get375Width(4));
        }];
        
        [self.selectImageView addSubview:self.indexLabel];
        [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)]];
    }
    return self;
}

- (void)click{
    if (self.clickAction) {
        self.clickAction(self);
    }
}

- (void)configCellWithAsset:(SNSLCommentAssetModel *)model{
    PHAsset *originAsset =_model.asset;
    
   
    self.selectState = model.isSelected;
    self.selectIndex = model.selectIndex;
    __weak typeof(self)weakSelf = self;
    
//    NSLog(@"----old = %@ new = %@ (%i)", originAsset.localIdentifier, model.asset.localIdentifier, [originAsset.localIdentifier isEqualToString: model.asset.localIdentifier]);
    
    if ([originAsset isEqual:model.asset]) {
        _model = model;
        return;
    }
    _model = model;
    [PickManger getImageViewAsset:model.asset width:(kScreenWidth- Get375Width(48))/3.0 * PickManger.screenScale complete:^(UIImage *image) {
        weakSelf.photo.image = image;
    }];
}

- (void)setSelectState:(BOOL)selectState{
    _selectState = selectState;
    if (selectState) {
        self.selectImageView.image = [UIImage imageNamed:@"snsl_comment_selected_bg"];
    }
    else{
        self.selectImageView.image = [UIImage imageNamed:@"snsl_comment_unsel"];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    if (selectIndex == 0) {
        self.indexLabel.hidden = YES;
    }
    else{
        self.indexLabel.hidden = NO;
        self.indexLabel.text = [NSString stringWithFormat:@"%li",(long)selectIndex];
    }
}

+ (NSString *)cellIdentifier{
    return @"SNSLCommentPhotoCellIdentifier";
}

@end
