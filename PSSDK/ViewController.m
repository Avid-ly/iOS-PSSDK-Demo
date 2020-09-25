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
    PSPrivacyModel *_authorizationModel;
    PSPrivacyModel *_alertModel;
    
    UIButton *_getAuthorizationBtn;
    UIButton *_updateAuthorizationBtn;
    
    UIButton *_getAlertInfoBtn;
    UIButton *_showAlertBtn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TraceAnalysis initWithProductId:ProductId ChannelId:ChannelId AppID:AppID];
    [PSSDK initWithProductId:ProductId accountId:AccountId];
    
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
    
    _getAuthorizationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _getAuthorizationBtn.backgroundColor = [UIColor orangeColor];
    _getAuthorizationBtn.frame = CGRectMake(x, y, width, height);
    [_getAuthorizationBtn setTitle:@"获取用户政策信息和授权状态" forState:UIControlStateNormal];
    [_getAuthorizationBtn addTarget:self action:@selector(getAuthorization) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_getAuthorizationBtn];
    [self adjustCenterH:_getAuthorizationBtn];
    y = _getAuthorizationBtn.frame.origin.y + _getAuthorizationBtn.frame.size.height + 20;
    
    _updateAuthorizationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _updateAuthorizationBtn.backgroundColor = [UIColor orangeColor];
    _updateAuthorizationBtn.frame = CGRectMake(x, y, width, height);
    [_updateAuthorizationBtn setTitle:@"主动更新用户授权状态" forState:UIControlStateNormal];
    [_updateAuthorizationBtn addTarget:self action:@selector(updateAuthorization) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_updateAuthorizationBtn];
    [self adjustCenterH:_updateAuthorizationBtn];
    y = _updateAuthorizationBtn.frame.origin.y + _updateAuthorizationBtn.frame.size.height + 20;
    
    _getAlertInfoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _getAlertInfoBtn.backgroundColor = [UIColor orangeColor];
    _getAlertInfoBtn.frame = CGRectMake(x, y, width, height);
    [_getAlertInfoBtn setTitle:@"获取隐私政策弹窗信息" forState:UIControlStateNormal];
    [_getAlertInfoBtn addTarget:self action:@selector(getAlertInfo) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_getAlertInfoBtn];
    [self adjustCenterH:_getAlertInfoBtn];
    y = _getAlertInfoBtn.frame.origin.y + _getAlertInfoBtn.frame.size.height + 20;
    
    _showAlertBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _showAlertBtn.backgroundColor = [UIColor orangeColor];
    _showAlertBtn.frame = CGRectMake(x, y, width, height);
    [_showAlertBtn setTitle:@"使用弹窗请求用户授权" forState:UIControlStateNormal];
    [_showAlertBtn addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_showAlertBtn];
    [self adjustCenterH:_showAlertBtn];
    y = _showAlertBtn.frame.origin.y + _showAlertBtn.frame.size.height + 20;
    
    y = y + 50;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
    
    _getAuthorizationBtn.hidden = YES;
    _updateAuthorizationBtn.hidden = YES;
    
    _getAlertInfoBtn.hidden = YES;
    _showAlertBtn.hidden = YES;
}

- (void)adjustCenterH:(UIView*)v{
    CGPoint center = self.view.center;
    center.y = v.frame.origin.y + v.frame.size.height/2;
    v.center = center;
}

#pragma mark - click

// ------------ Region ------------

- (void)getUserRegion {
    [PSSDK getUserRegion:^(PSUserRegionModel *model) {
        
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"";
            NSString *message = @"";
            if (model) {
                title = @"Succeed";
                message = [NSString stringWithFormat:@" 国家 %@\n 州省 %@\n 城市 %@",model.country, model.province, model.city];
                self->_getAuthorizationBtn.hidden = NO;
                self->_getAlertInfoBtn.hidden = NO;
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

// ------------ Authorization ------------

- (void)getAuthorization {
    
    [PSSDK getAuthorization:^(PSPrivacyModel *model) {
        
        self->_authorizationModel = model;
        
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"";
            NSString *message = @"";
            if (model) {
                title = @"Succeed";
                message = [NSString stringWithFormat:@" 政策类别: %@ \n 授权状态: %@",model.privacyPolicy,model.authorization?@"YES":@"NO"];
                if (model.privacyPolicy && ![model.privacyPolicy isEqualToString:@""]) {
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

- (void)updateAuthorization {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择要更新的授权状态" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateAuthorization:YES privacyPolicy:self->_authorizationModel.privacyPolicy];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateAuthorization:NO privacyPolicy:self->_authorizationModel.privacyPolicy];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateAuthorization:(BOOL)b privacyPolicy:(NSString *)privacyPolicy {
    
    [PSSDK updateAuthorization:b privacyPolicy:privacyPolicy completion:^(BOOL succeed) {
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"";
            NSString *message = @"";
            if (succeed) {
                title = @"Succeed";
                message = [NSString stringWithFormat:@" 政策类别: %@ \n 授权状态: %@",self->_authorizationModel.privacyPolicy,b?@"YES":@"NO"];
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

// ------------ Alert ------------

- (void)getAlertInfo {
    [PSSDK getPrivacyPolicyAlertInfo:^(PSPrivacyModel *model) {
        self->_alertModel = model;
        
        // 回到主线程处理
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"";
            NSString *message = @"";
            if (model) {
                title = @"Succeed";
                message = [NSString stringWithFormat:@" 政策类别: %@ \n 授权状态: %@",model.privacyPolicy,model.authorization?@"YES":@"NO"];
                self->_showAlertBtn.hidden = NO;
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

- (void)showAlert {

    [PSSDK showPrivacyPolicyAlert:self completion:^(PSPrivacyModel *model) {
        
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
