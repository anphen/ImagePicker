//
//  SNSLCommentAlbumCell.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/7.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSLCommentAssetModel.h"

@interface SNSLCommentAlbumCell : UITableViewCell

@property (nonatomic, strong) SNSLCommentAlbumModel *albumModel;

+ (NSString *)cellIdentifier;

- (void)configCellWithAlbum:(SNSLCommentAlbumModel *)albumModel;

@end
