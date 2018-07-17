
//
//  SNSLCommentAlbumCell.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/7.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentAlbumCell.h"
#import <Masonry.h>
#import "SNSLCommentImagePickManager.h"

@interface SNSLCommentAlbumCell()

@property (nonatomic, strong) UIImageView *albumImage;
@property (nonatomic, strong) UILabel *albumName;
@property (nonatomic, strong) UIImageView *indicatorView;

@end

@implementation SNSLCommentAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indicatorView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snsl_comment_more"]];
        self.indicatorView.contentMode = UIViewContentModeScaleAspectFit;
        self.albumImage = [[UIImageView alloc]init];
        self.albumImage.contentMode = UIViewContentModeScaleAspectFill;
        self.albumImage.clipsToBounds = YES;
        self.albumName = [[UILabel alloc]init];
        self.albumName.font = [UIFont systemFontOfSize:15];
        self.albumName.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
        [self.contentView addSubview:self.albumImage];
        [self.contentView addSubview:self.albumName];
        [self.contentView addSubview:self.indicatorView];
        [self.albumImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Get375Width(14));
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(Get375Width(70));
            make.height.mas_equalTo(Get375Width(70));
        }];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.albumImage.mas_centerY);
            make.right.mas_equalTo(-Get375Width(16));
            make.width.mas_equalTo(Get375Width(16));
            make.height.mas_equalTo(Get375Width(16));
        }];
        [self.albumName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.albumImage.mas_right).offset(Get375Width(18));
            make.centerY.mas_equalTo(self.albumImage.mas_centerY);
            make.right.mas_equalTo(self.indicatorView.mas_left).offset(-Get375Width(18));
        }];
    }
    return self;
}

- (void)configCellWithAlbum:(SNSLCommentAlbumModel *)albumModel{
    self.albumModel = albumModel;
    PHAsset *asset = [albumModel.result lastObject];
    __weak typeof(self)weakSelf = self;
    [PickManger getImageViewAsset:asset width:Get375Width(70) * PickManger.screenScale complete:^(UIImage *image) {
        weakSelf.albumImage.image = image;
    }];
    self.albumName.text = [NSString stringWithFormat:@"%@ (%ld)",albumModel.name,(long)albumModel.count];
}

+ (NSString *)cellIdentifier{
    return @"SNSLCommentAlbumCellIdentifier";
}

@end
