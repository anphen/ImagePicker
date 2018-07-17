//
//  SNSLCommentAssetModel.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/6.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentAssetModel.h"
#import "SNSLCommentImagePickManager.h"

@implementation SNSLCommentAssetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectIndex = 0;
        self.isSelected = NO;
    }
    return self;
}

+ (instancetype)modelWithAsset:(id)asset type:(SNSLCommentAssetModelMediaType)type{
    SNSLCommentAssetModel *model = [[SNSLCommentAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

- (BOOL)isEqual:(id)object{
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[SNSLCommentAssetModel class]]) {
        return NO;
    }
    
    SNSLCommentAssetModel *model = object;
    if ([model.asset.localIdentifier isEqualToString:self.asset.localIdentifier]) {
        return YES;
    }
    return NO;
}

@end

@implementation SNSLCommentAlbumModel

+ (instancetype)moduleWithName:(NSString *)name assetResult:(PHFetchResult *)result{
    SNSLCommentAlbumModel *module = [[SNSLCommentAlbumModel alloc]init];
    module.name = name;
    module.result = result;
    module.models = [self getAssertFormResult:result];
    module.count = module.models.count;
    module.selectedModels = [NSMutableArray array];
    return module;
}

+ (NSArray<SNSLCommentAssetModel *>*)getAssertFormResult:(PHFetchResult *)result{
    NSMutableArray *photoArr = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SNSLCommentAssetModel *model = [self getAssetModelWithAsset:obj];
        if (model) {
            [photoArr addObject:model];
        }
    }];
    return photoArr;
}

+ (SNSLCommentAssetModel *)getAssetModelWithAsset:(id)asset{
    PHAsset *phAsset = asset;
    //此处可控制照片的展示
    switch (phAsset.mediaType) {
        case PHAssetMediaTypeVideo: {
           
        }
            break;
        case PHAssetMediaTypeImage: {
            
        }
            break;
        case PHAssetMediaTypeAudio:{
            
        }
            break;
        case PHAssetMediaTypeUnknown:{
            
        }
            break;
        default: break;
    }

    SNSLCommentAssetModel *model;
    SNSLCommentAssetModelMediaType type = [self getAssetType:asset];//可以判断类型来过滤图片
    model = [SNSLCommentAssetModel modelWithAsset:asset type:type];
    return model;
}

+ (SNSLCommentAssetModelMediaType)getAssetType:(PHAsset *)asset{
    SNSLCommentAssetModelMediaType type = SNSLCommentAssetModelMediaTypePhoto;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        if (phAsset.mediaType == PHAssetMediaTypeVideo){
             type = ZxAssetModelMediaTypeVideo;
        }
        else if (phAsset.mediaType == PHAssetMediaTypeAudio) {
            type = SNSLCommentAssetModelMediaTypeAudio;
        }
        else if (phAsset.mediaType == PHAssetMediaTypeImage) {
            if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                type = SNSLCommentAssetModelMediaTypePhotoGif;
            }
        }
    }
    return type;
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return @"";
}

@end

