//
//  SNSLCommentImagePickManager.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSLCommentAssetModel.h"

//#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
//#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
//#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
//#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
//#define iOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

#define isIphoneX [SNSLCommentImagePickManager isIPhoneX]

#define kNaviBarHeight ([SNSLCommentImagePickManager statusBarHeight]+44)

#define kBottomHeight (isIphoneX ? 34 : 0)

#define Get375Width(w) (w) * kScreenWidth / 375.f

#define PickManger [SNSLCommentImagePickManager manager]

typedef void(^arrayBlock)(NSArray *selectAssets);

@protocol SNSLCommentImagePickDelegate <NSObject>


@end

@interface SNSLCommentImagePickManager : NSObject

+ (instancetype)manager;

+ (void)deallocManager;

@property (nonatomic, strong) NSMutableArray<SNSLCommentAssetModel *> *selectModels;

@property (nonatomic, assign) CGFloat screenScale;

@property (nonatomic, strong) NSArray *selectedAssets;

@property (nonatomic, assign) NSInteger currrentSelectIndex;

@property (nonatomic, assign) NSInteger maxPickCount;//5，最大可选照片数

@property (nonatomic, assign) BOOL allowPickVideo;//no

@property (nonatomic, assign) NSInteger colunmNumber;//3,每行展示照片数目

@property (nonatomic, weak) id<SNSLCommentImagePickDelegate> imagePickDelegate;

@property (nonatomic, copy) arrayBlock finishCallBack;

- (void)getAllPhotoComplete:(void(^)(SNSLCommentAlbumModel *model))complete;

- (void)getAllAlbumComplete:(void (^)(NSArray<SNSLCommentAlbumModel *> * albumModel))complete;

- (void)getImageViewAsset:(id)asset width:(CGFloat)width complete:(void(^)(UIImage *image))complete;

- (void)getImageViewAsset:(id)asset width:(CGFloat)width height:(CGFloat)height complete:(void(^)(UIImage *image))complete;

- (void)synchronizeSelectModel:(SNSLCommentAssetModel *)model;

- (void)synchronizeAlbum:(SNSLCommentAlbumModel *)album;

- (void)configSelectAssets:(NSArray<PHAsset *> *)selectAssets;

- (void)reSetAlbum:(SNSLCommentAlbumModel *)album;//重置相册选中状态

- (void)checkAuthorizationStatus:(void(^)(BOOL authorization))complete;

- (NSDictionary *)getInfoDictionary;

+ (BOOL)isIPhoneX;

+ (CGFloat)statusBarHeight;

@end
