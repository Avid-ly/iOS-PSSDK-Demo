//
//  ViewController.m
//  PSSDK
//
//  Created by steve on 2020/9/7.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import "ViewController.h"
#import <PSSDK/PSSDK.h>
#import <TraceAnalysisSDK/TraceAnalysis.h>

static NSString *ProductId  = @"600100";
static NSString *ChannelId  = @"32400";
static NSString *AppID      = @"id123456789";
static NSString *AccountId  = @"123456";

@interface ViewController ()
{
    UIButton *_getUserInfoBtn;
    UIButton *_requestAuthorizationBtn;
    UIButton *_updateAuthorizationBtn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TraceAnalysis initWithProductId:ProductId ChannelId:ChannelId AppID:AppID];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scrollView];
    
    CGFloat x = 70;
    CGFloat y = 50;
    CGFloat width = 250;
    CGFloat height = 40;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(x, y, width, height);
    [button setTitle:@"获取用户归属" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getUserRegion) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    [self adjustCenterH:button];
    y = button.frame.origin.y + button.frame.size.height + 20;
    
    _getUserInfoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _getUserInfoBtn.backgroundColor = [UIColor orangeColor];
    _getUserInfoBtn.frame = CGRectMake(x, y, width, height);
    [_getUserInfoBtn setTitle:@"获取隐私政策信息" forState:UIControlStateNormal];
    [_getUserInfoBtn addTarget:self action:@selector(getUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_getUserInfoBtn];
    [self adjustCenterH:_getUserInfoBtn];
    y = _getUserInfoBtn.frame.origin.y + _getUserInfoBtn.frame.size.height + 20;
    
    _requestAuthorizationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _requestAuthorizationBtn.backgroundColor = [UIColor orangeColor];
    _requestAuthorizationBtn.frame = CGRectMake(x, y, width, height);
    [_requestAuthorizationBtn setTitle:@"请求用户授权" forState:UIControlStateNormal];
    [_requestAuthorizationBtn addTarget:self action:@selector(requestAuthorization) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_requestAuthorizationBtn];
    [self adjustCenterH:_requestAuthorizationBtn];
    y = _requestAuthorizationBtn.frame.origin.y + _requestAuthorizationBtn.frame.size.height + 20;
    
    _updateAuthorizationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _updateAuthorizationBtn.backgroundColor = [UIColor orangeColor];
    _updateAuthorizationBtn.frame = CGRectMake(x, y, width, height);
    [_updateAuthorizationBtn setTitle:@"主动更新用户授权状态" forState:UIControlStateNormal];
    [_updateAuthorizationBtn addTarget:self action:@selector(updateAuthorization) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_updateAuthorizationBtn];
    [self adjustCenterH:_updateAuthorizationBtn];
    y = _updateAuthorizationBtn.frame.origin.y + _updateAuthorizationBtn.frame.size.height + 20;
    
    y = y + 50;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
    
    _getUserInfoBtn.hidden = YES;
    _requestAuthorizationBtn.hidden = YES;
    _updateAuthorizationBtn.hidden = YES;
}

- (void)adjustCenterH:(UIView*)v{
    CGPoint center = self.view.center;
    center.y = v.frame.origin.y + v.frame.size.height/2;
    v.center = center;
}

#pragma mark - click

- (void)getUserRegion {
    [PSSDK getUserRegion:^(PSUserRegionModel *model) {
        
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"";
            NSString *message = @"";
            if (model) {
                title = @"Succeed";
                message = [NSString stringWithFormat:@" 国家 %@\n 州省 %@\n 城市 %@",model.country, model.province, model.city];
                self->_getUserInfoBtn.hidden = NO;
            }
            else {
                title = @"Error";
                message = [NSString stringWithFormat:@"model is nil"];
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }];
}

- (void)getUserInfo {
    
    [PSSDK getPrivacyInfoWithProductId:ProductId accountId:AccountId completion:^(PSPrivacyModel *model) {
        
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"";
            NSString *message = @"";
            if (model) {
                title = @"Succeed";
                message = [NSString stringWithFormat:@" 政策类别: %@ \n 授权状态: %@",model.privacyPolicy,model.authorization?@"YES":@"NO"];
                if (model.privacyPolicy && ![model.privacyPolicy isEqualToString:@""]) {
                    self->_requestAuthorizationBtn.hidden = NO;
                    self->_updateAuthorizationBtn.hidden = NO;
                }
            }
            else {
                title = @"Error";
                message = [NSString stringWithFormat:@"model is nil"];
            }
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }];
}

- (void)requestAuthorization {
    [PSSDK requestAuthorizationWithAlert:self completion:^(PSPrivacyModel *model) {
        
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"";
            NSString *message = @"";
            if (model) {
                title = @"Succeed";
                message = [NSString stringWithFormat:@" 政策类别: %@ \n 授权状态: %@",model.privacyPolicy,model.authorization?@"YES":@"NO"];
            }
            else {
                title = @"Error";
                message = [NSString stringWithFormat:@"model is nil"];
            }
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }];
}

- (void)updateAuthorization {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择要更新的授权状态" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateAuthorization:YES];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateAuthorization:NO];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateAuthorization:(BOOL)b {
    [PSSDK updateAuthorization:b completion:^(PSPrivacyModel *model) {
        
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"";
            NSString *message = @"";
            if (model) {
                title = @"Succeed";
                message = [NSString stringWithFormat:@" 政策类别: %@ \n 授权状态: %@",model.privacyPolicy,model.authorization?@"YES":@"NO"];
            }
            else {
                title = @"Error";
                message = [NSString stringWithFormat:@"model is nil"];
            }
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }];
}

@end
