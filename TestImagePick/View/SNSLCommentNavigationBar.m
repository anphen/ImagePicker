//
//  SNSLCommentNavigationBar.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/9.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentNavigationBar.h"
#import <Masonry.h>
#import <UIColor+Additions.h>
#import "SNSLCommentImagePickManager.h"

@implementation SNSLCommentNavigationBar

- (instancetype)initTitle:(NSString *)title titleImage:(NSString *)titleImage leftTitle:(NSString *)leftTitle leftImage:(NSString *)leftImage{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn = left;
        [self addSubview:left];
        if ([leftImage isEqualToString:@""]) {
            left.titleLabel.font = [UIFont systemFontOfSize:14];
            [left setTitle:leftTitle forState:UIControlStateNormal];
            [left setTitleColor:[UIColor add_colorWithRGBHexString:@"666666"] forState:UIControlStateNormal];
            [left mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(14);
                make.height.mas_equalTo(24);
                make.bottom.mas_equalTo(-10);
            }];
        }
        else{
            [left setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
            [left mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(14);
                make.bottom.mas_equalTo(-10);
            }];
        }
        
        UIView *leftTouchView = [[UIView alloc]init];
        leftTouchView.backgroundColor = [UIColor clearColor];
        [self addSubview:leftTouchView];
        [leftTouchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        [leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(left)]];
        
        UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 24)];
        right.titleLabel.font = [UIFont systemFontOfSize:11];
        [right setTitle:@"确定" forState:UIControlStateNormal];
        [right setBackgroundColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.00]];
        [right setTitleColor:[UIColor add_colorWithRGBHexString:@"e0e0e0"] forState:UIControlStateNormal];
        [right addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn = right;
        [self addSubview:right];
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.height.mas_equalTo(24);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(48);
        }];
        
        if (![titleImage isEqualToString:@""]) {
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.text  = title;
            titleLabel.textColor = [UIColor add_colorWithRGBHexString:@"333333"];
            titleLabel.font = [UIFont systemFontOfSize:17];
            
            UIImageView *titleImageView = [[UIImageView alloc]init];
            titleImageView.image = [UIImage imageNamed:titleImage];
            titleImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.titleLabel = titleLabel;
            self.titleImageView = titleImageView;
            self.titleView = [[UIView alloc]init];
            [self addSubview:self.titleView];
            [self.titleView addSubview:titleLabel];
            [self.titleView addSubview:titleImageView];
            [self.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(title)]];
            [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.height.mas_equalTo(44);
                make.bottom.mas_equalTo(0);
            }];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(0);
            }];
            [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).offset(4);
                make.right.top.bottom.mas_equalTo(0);
            }];
            
            UIView *bottomLine = [[UIView alloc]init];
            bottomLine.backgroundColor = [UIColor add_colorWithRGBHexString:@"dddddd"];
            [self addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(0.5);
            }];
        }
    }
    return self;
}

- (void)left{
    if (self.leftAction) {
        self.leftAction();
    }
}

- (void)right{
    if (self.rightAction) {
        self.rightAction();
    }
}

- (void)title{
    if (self.titleAction) {
        self.titleAction();
    }
}

@end
