//
//  SNSLCommentAlbumController.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentAlbumController.h"

@interface SNSLCommentAlbumController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation SNSLCommentAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(- Get375Width(179) - kNaviBarHeight);
    }];
}

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        [_mainTableView registerClass:[SNSLCommentAlbumCell class] forCellReuseIdentifier:[SNSLCommentAlbumCell cellIdentifier]];
        _mainTableView.rowHeight = Get375Width(87);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (void)setAlbums:(NSArray<SNSLCommentAlbumModel *> *)albums{
    _albums = albums;
    [self.mainTableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNSLCommentAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:[SNSLCommentAlbumCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithAlbum:[self.albums objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(clickAlbum:)]) {
        [self.delegate clickAlbum:[self.albums objectAtIndex:indexPath.row]];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


@end
