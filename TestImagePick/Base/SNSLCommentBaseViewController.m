//
//  SNSLCommentBaseViewController.m
//  TestImagePick
//
//  Created by xu zhao on 2018/5/4.
//  Copyright © 2018年 zhaoxu. All rights reserved.
//

#import "SNSLCommentBaseViewController.h"

@interface SNSLCommentBaseViewController ()

@end

@implementation SNSLCommentBaseViewController

- (void)dealloc{
    NSLog(@"===============delloc____%@========", self.class);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
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


//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}
- (BOOL)shouldAutorotate{
    return NO;
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
