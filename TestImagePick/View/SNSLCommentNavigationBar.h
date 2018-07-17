//
//  SNSLCommentNavigationBar.h
//  TestImagePick
//
//  Created by xu zhao on 2018/5/9.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNSLCommentNavigationBar : UIView

@property (nonatomic, copy) void(^titleAction)(void);
@property (nonatomic, copy) void(^leftAction)(void);
@property (nonatomic, copy) void(^rightAction)(void);

@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIButton * rightBtn;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UIView *titleView;

- (instancetype)initTitle:(NSString *)title titleImage:(NSString *)titleImage leftTitle:(NSString *)leftTitle leftImage:(NSString *)leftImage;

@end
