//
//  SNSLCommentNavigationController.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentNavigationController.h"

@interface SNSLCommentNavigationController ()

@end

@implementation SNSLCommentNavigationController

- (void)dealloc{
    NSLog(@"===============delloc____%@========", self.class);
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        if (@available(iOS 11.0, *)) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.navigationBar.hidden = YES;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
