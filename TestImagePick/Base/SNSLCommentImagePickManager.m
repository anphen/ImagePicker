//
//  SNSLCommentImagePickManager.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentImagePickManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MBProgressHUD.h>
#import <sys/utsname.h>

@interface SNSLCommentImagePickManager()<PHPhotoLibraryChangeObserver>

@end

@implementation SNSLCommentImagePickManager

static SNSLCommentImagePickManager *manager;
static dispatch_once_t onceToken;
+ (instancetype)manager {
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    
    });
    return manager;
}

+ (void)deallocManager {
    onceToken = 0;
    manager = nil;
}

- (void)dealloc{
    [[PHPhotoLibrary sharedPhotoLibrary]unregisterChangeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxPickCount = 5;
        self.allowPickVideo = NO;
        self.colunmNumber = 3;
        self.currrentSelectIndex = 0;
        self.selectedAssets = [NSMutableArray array];
        self.selectModels = [NSMutableArray array];
        self.screenScale = 2.0;
    }
    return self;
}

- (void)getAllPhotoComplete:(void(^)(SNSLCommentAlbumModel *model))complete{
    __block SNSLCommentAlbumModel *model;
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //过滤视频文件
    if (!self.allowPickVideo) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for (PHAssetCollection *collection in smartAlbums) {
        // 有可能是PHCollectionList类的的对象，过滤掉
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        // 过滤空相册
        if (collection.estimatedAssetCount <= 0) continue;
        if ([self isCameraRollAlbum:collection]) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            model = [SNSLCommentAlbumModel moduleWithName:collection.localizedTitle assetResult:fetchResult];
            model.isCameraRoll = YES;
            if (complete) {
                complete(model);
            };
            break;
        }
    }
}

- (BOOL)isCameraRollAlbum:(id)metadata {
    return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
}

//case Album //从 iTunes 同步来的相册，以及用户在 Photos 中自己建立的相册
//case SmartAlbum //经由相机得来的相册
//case Moment //Photos 为我们自动生成的时间分组的相册
- (void)getAllAlbumComplete:(void (^)(NSArray<SNSLCommentAlbumModel *> * albumModel))complete{
    NSMutableArray *albumArr = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!self.allowPickVideo){
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }
//    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];//用户的 iCloud 照片流
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];//系统相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];//获取用户自己建立的相册和文件夹
//    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];//从iPhoto同步到设备的相册
//    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];//用户使用 iCloud 共享的相册
    NSArray *allAlbums = @[smartAlbums,topLevelUserCollections];
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
//            NSLog(@"====== %@ ======", collection.localizedTitle);
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            // 过滤空相册
            if (collection.estimatedAssetCount <= 0) continue;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle containsString:@"Hidden"] || [collection.localizedTitle isEqualToString:@"已隐藏"]) continue;
            if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) continue;
            if ([self isCameraRollAlbum:collection]) {
                SNSLCommentAlbumModel *model = [SNSLCommentAlbumModel moduleWithName:collection.localizedTitle assetResult:fetchResult];
                model.isCameraRoll = YES;
                [albumArr insertObject:model atIndex:0];
                
            } else {
                [albumArr addObject:[SNSLCommentAlbumModel moduleWithName:collection.localizedTitle assetResult:fetchResult]];
            }
        }
    }
    if (complete && albumArr.count > 0) {
        complete(albumArr);
    };
}

- (void)getImageViewAsset:(id)asset width:(CGFloat)width complete:(void(^)(UIImage *image))complete{
    [self getImageViewAsset:asset width:width height:width complete:complete];
}

- (void)getImageViewAsset:(id)asset width:(CGFloat)width height:(CGFloat)height complete:(void(^)(UIImage *image))complete{
    PHAsset *phAsset = (PHAsset *)asset;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager]requestImageForAsset:phAsset targetSize:CGSizeMake(width, height) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(result);
            }
        });
    }];
}

- (void)synchronizeSelectModel:(SNSLCommentAssetModel *)model{
    if (![self.selectModels containsObject:model]) {
        if (model.isSelected) {
            [self.selectModels addObject:model];
        }
    }
    else{
        NSInteger index = [self.selectModels indexOfObject:model];
        SNSLCommentAssetModel *assetModel = [self.selectModels objectAtIndex:index];
        if (!model.isSelected) {
            assetModel.isSelected = NO;
            assetModel.selectIndex = 0;
            [self.selectModels removeObject:assetModel];
            //重新排序选中的model
            for (int i=0; i<self.selectModels.count; i++) {
                SNSLCommentAssetModel *assetModel = [self.selectModels objectAtIndex:i];
                assetModel.selectIndex = i + 1;
            }
        }
    }
}

- (void)synchronizeAlbum:(SNSLCommentAlbumModel *)album{
//    if (self.selectModels.count <= 0) {
//        return;
//    }
    NSMutableArray *selectArray = [NSMutableArray array];
    
    for (SNSLCommentAssetModel *selectModel in self.selectModels) {
        if ([album.models containsObject:selectModel]) {
            NSInteger index = [album.models indexOfObject:selectModel];
            SNSLCommentAssetModel *assetModel = [album.models objectAtIndex:index];
            assetModel.isSelected = selectModel.isSelected;
            assetModel.selectIndex = selectModel.selectIndex;
            [selectArray addObject:assetModel];
        }
    }
    //更新selectedModels
    album.selectedModels = selectArray;
}

- (void)reSetAlbum:(SNSLCommentAlbumModel *)album{
    for (SNSLCommentAssetModel *assetModel in album.models){
        if (![self.selectModels containsObject:assetModel]) {
            assetModel.isSelected = NO;
            assetModel.selectIndex = 0;
        }
    }
}

- (void)configSelectAssets:(NSArray<PHAsset *> *)selectAssets{
    if (selectAssets.count == 0||!selectAssets) {
        return;
    }
    self.selectedAssets = selectAssets;
    if (selectAssets.count >= self.maxPickCount) {
        selectAssets = [selectAssets subarrayWithRange:NSMakeRange(0, self.maxPickCount)];
    }
    
    NSMutableArray *assetModelArray = [NSMutableArray array];
    NSInteger selectIndex = 1;
    for (int i = 0; i < selectAssets.count; i++) {
        PHAsset *asset = [selectAssets objectAtIndex:i];
        SNSLCommentAssetModelMediaType type = [SNSLCommentAlbumModel getAssetType:asset];
        if (type == SNSLCommentAssetModelMediaTypePhoto ) {
            SNSLCommentAssetModel *model = [SNSLCommentAssetModel modelWithAsset:asset type:SNSLCommentAssetModelMediaTypePhoto];
            model.isSelected  = YES;
            model.selectIndex = selectIndex;
            [assetModelArray addObject:model];
            selectIndex ++;
        }
    }
    self.selectModels = assetModelArray;
    self.currrentSelectIndex = self.selectModels.count;
}

- (NSArray *)selectedAssets{
    NSMutableArray *selectAssetArray = [NSMutableArray array];
    for (int i = 0; i < self.selectModels.count; i++) {
        SNSLCommentAssetModel *model = [self.selectModels objectAtIndex:i];
        [selectAssetArray addObject:model.asset];
    }
    return [NSArray arrayWithArray:selectAssetArray];
}

- (void)checkAuthorizationStatus:(void(^)(BOOL authorization))complete{
    [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self];
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
        if (complete) {
            complete(NO);
        }
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alertView show];
        if (complete) {
            complete(NO);
        }
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        if (complete) {
            complete(YES);
        }
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                if (complete) {
                    complete(YES);
                }
            }
            else{
                if (complete) {
                    complete(NO);
                }
            }
        }];
    }
}

- (NSDictionary *)getInfoDictionary {
    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
    if (!infoDict || !infoDict.count) {
        infoDict = [NSBundle mainBundle].infoDictionary;
    }
    if (!infoDict || !infoDict.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return infoDict ? infoDict : @{};
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

+(BOOL)isIPhoneX{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // 模拟器下采用屏幕的高度来判断
        return [UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812;
    }
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}

+ (CGFloat)statusBarHeight {
    return [self isIPhoneX] ? 44 : 20;
}

#pragma mark - PHPhotoLibraryChangeObserver
//接收照片改变的消息
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    
}

@end
