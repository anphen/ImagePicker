//
//  SNSLCommentAssetModel.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/6.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    SNSLCommentAssetModelMediaTypePhoto = 0,
    SNSLCommentAssetModelMediaTypeLivePhoto,
    SNSLCommentAssetModelMediaTypePhotoGif,
    ZxAssetModelMediaTypeVideo,
    SNSLCommentAssetModelMediaTypeAudio
} SNSLCommentAssetModelMediaType;

@interface SNSLCommentAssetModel : NSObject

@property (nonatomic, assign) NSInteger selectIndex;//第几个被选中

@property (nonatomic, strong) PHAsset *asset;             ///< PHAsset or ALAsset
@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No
@property (nonatomic, assign) SNSLCommentAssetModelMediaType type;

/// Init a photo dataModel With a asset
/// 用一个PHAsset/ALAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(id)asset type:(SNSLCommentAssetModelMediaType)type;

@end


@interface SNSLCommentAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) id result;             ///< PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>

@property (nonatomic, strong) NSArray *models;//SNSLCommentAssetModel,从result转过来
@property (nonatomic, strong) NSMutableArray *selectedModels;//SNSLCommentAssetModel,已选中图片数组
//@property (nonatomic, assign) NSUInteger selectedCount;

@property (nonatomic, assign) BOOL isCameraRoll;//是不是所有图片

+ (instancetype)moduleWithName:(NSString *)name assetResult:(PHFetchResult *)result;

+ (SNSLCommentAssetModelMediaType)getAssetType:(PHAsset *)asset;
@end
