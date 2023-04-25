//
//  ViewController.m
//  PSSDK
//
//  Created by steve on 2020/9/7.
//  Copyright © 2020 guojunliu.github.io. All rights reserved.
//

#import "ViewController.h"
#import <PSSDK/PSSDK.h>

//static NSString *ProductId  = @"600100";
//static NSString *ChannelId  = @"32400";
//static NSString *AppID      = @"id123456789";
//static NSString *AccountId  = @"123456";

static NSString *ProductId  = @"600108";
static NSString *ChannelId  = @"32400";
static NSString *AppID      = @"id123456789";
static NSString *AccountId  = @"1";

@interface ViewController () <UITextFieldDelegate>
{
    UITextField *_pdtID;
    
    NSString *_productId;
    NSString *_playerId;
    UIButton *_playerIdButton;
    UIButton *_bestBtn;
    BOOL _canShow;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [PSSDK initWithProductId:ProductId accountId:AccountId];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scrollView];
    
    CGFloat x = 70;
    CGFloat y = 30;
    CGFloat width = 250;
    CGFloat height = 40;
    
    _playerId = [self getPlayerId];
    _productId = [self getProductId];
    
    _pdtID = [[UITextField alloc]init];
    _pdtID.backgroundColor = [UIColor whiteColor];
    _pdtID.layer.borderWidth = 1.0f;
    _pdtID.layer.borderColor = [UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;;
    _pdtID.text = _productId;
    _pdtID.frame = CGRectMake(x, y, width, height);
    _pdtID.textColor = [UIColor blackColor];
    _pdtID.delegate = self;
    _pdtID.returnKeyType = UIReturnKeyDone;
    _pdtID.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:_pdtID];
    [self adjustCenterH:_pdtID];
    y = _pdtID.frame.origin.y + _pdtID.frame.size.height + 20;
    
    _playerIdButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _playerIdButton.backgroundColor = [UIColor orangeColor];
    _playerIdButton.frame = CGRectMake(x, y, width, height);
    [_playerIdButton setTitle:[NSString stringWithFormat:@"当前用户ID %@ , 点击生成新用户",[_playerId substringWithRange:NSMakeRange(0, 4)]] forState:UIControlStateNormal];
    [_playerIdButton addTarget:self action:@selector(getNewPlayerId) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_playerIdButton];
    [self adjustCenterH:_playerIdButton];
    y = _playerIdButton.frame.origin.y + _playerIdButton.frame.size.height + 20;

    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearBtn.backgroundColor = [UIColor orangeColor];
    clearBtn.frame = CGRectMake(x, y, width, height);
    [clearBtn setTitle:@"清除当前用户的本地缓存" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearPlayerCache) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:clearBtn];
    [self adjustCenterH:clearBtn];
    y = clearBtn.frame.origin.y + clearBtn.frame.size.height + 20;

    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    testBtn.backgroundColor = [UIColor orangeColor];
    testBtn.frame = CGRectMake(x, y, width, height);
    [testBtn setTitle:@"最佳实现测试" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(asyncBestFunction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:testBtn];
    [self adjustCenterH:testBtn];
    y = testBtn.frame.origin.y + testBtn.frame.size.height + 20;
    
    _canShow = YES;
    
    y = y + 50;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
}

- (void)adjustCenterH:(UIView*)v{
    CGPoint center = self.view.center;
    center.y = v.frame.origin.y + v.frame.size.height/2;
    v.center = center;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_pdtID resignFirstResponder];
    
    NSString *str = textField.text;
    [self updateProductId:str];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_pdtID resignFirstResponder];

    NSString *str = textField.text;
    [self updateProductId:str];
    return YES;
}

#pragma mark - playerId

- (NSString *)getPlayerId {
    NSString *playerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TestPlayerId"];
    if (playerId == nil || [playerId isEqualToString:@""]) {
        playerId = [NSUUID UUID].UUIDString;
        [[NSUserDefaults standardUserDefaults] setObject:playerId forKey:@"TestPlayerId"];
    }
    
    return playerId;
}

- (void)getNewPlayerId {
    
    NSString *message = @"确定生成新用户吗？生成新用户后，当前用户数据会被清除";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"生成新用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //回到主线程中展示更安全
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *playerId = [NSUUID UUID].UUIDString;
            [[NSUserDefaults standardUserDefaults] setObject:playerId forKey:@"TestPlayerId"];
            self->_playerId = playerId;
            [self->_playerIdButton setTitle:[NSString stringWithFormat:@"当前用户ID：%@ , 点击可刷新",[self->_playerId substringWithRange:NSMakeRange(0, 4)]] forState:UIControlStateNormal];
        });
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clearPlayerCache {
    
    NSString *message = @"确定清除当前用户的本地缓存吗？用户的本地缓存数据会被清除，但内存中的缓存还在，需要重启APP生效";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *key = [NSString stringWithFormat:@"%@-%@-%@",ProductId, self->_playerId,@"PSPrivacyAuthorizationModel"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:key];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - product id

- (NSString *)getProductId {
    NSString *productId = [[NSUserDefaults standardUserDefaults] objectForKey:@"TestProductId"];
    if (productId == nil || [productId isEqualToString:@""]) {
        productId = ProductId;
        [[NSUserDefaults standardUserDefaults] setObject:productId forKey:@"TestProductId"];
    }
    
    return productId;
}

- (void)updateProductId:(NSString *)productId {
    
    if (productId == nil || [productId isEqualToString:@""]) {
        return;
    }
    
    _productId = productId;
    [[NSUserDefaults standardUserDefaults] setObject:productId forKey:@"TestProductId"];
}

#pragma mark - click

// 异步
- (void)asyncBestFunction {
    
    if (!_canShow) {
        return;
    }
    _canShow = NO;
    
    NSString *string;
    string = @"\n开始获取";
    NSLog(@"%@", @"开始获取");
    
    NSString *yourProductId = _productId;
    NSString *yourPlayerId = _playerId; // 如果游戏没有accountId的话，可以使用uuid代替 [NSUUID UUID].UUIDString
    [PSSDK requestPrivacyAuthorizationWithProductId:yourProductId playerId:yourPlayerId vc:self orientation:PSOrientationTypeAuto succeed:^(PSPrivacyAuthorizationModel *model) {
        
        // 3.2、打印本地的授权信息
        [self printModel:model];
        
        self->_canShow = YES;
        
        NSString *string;
        string = @"结束";
        NSLog(@"%@", string);
        
    } error:^(NSError *error) {
        NSString *string;
        string = [NSString stringWithFormat:@"%@",error];
        NSLog(@"%@", string);
        
        self->_canShow = YES;
        
        string = @"结束";
        NSLog(@"%@", string);
    }];
    
    
}

- (void)printModel:(PSPrivacyAuthorizationModel *)model {
    
    NSString *string;
    string = @"----------------------------";
    NSLog(@"%@", string);
    
    string = [NSString stringWithFormat:@"当前用户ID：%@",[_playerId substringWithRange:NSMakeRange(0, 4)]];
    NSLog(@"%@", string);
    
    string = [NSString stringWithFormat:@"隐私政策：%@",model.privacyPolicy];
    NSLog(@"%@", string);
    
    string = [NSString stringWithFormat:@"是否已向用户发起过授权：%@",model.authorizationStatus==PSPrivacyAuthorizationStatusNotDetermined?@"未请求过":@"已请求过"];
    NSLog(@"%@", string);
    
    NSString *str1;
    if (model.collectionStatus == PSPrivacyCollectionStatusUnknow) {
        str1 = @"未知";
    }
    else if (model.collectionStatus == PSPrivacyCollectionStatusDenied) {
        str1 = @"不同意";
    }
    else if (model.collectionStatus == PSPrivacyCollectionStatusAuthorized) {
        str1 = @"同意";
    }
    string = [NSString stringWithFormat:@"是否同意收集隐私信息：%@",str1];
    NSLog(@"%@", string);
    
    NSString *str2;
    if (model.sharingStatus == PSPrivacySharingStatusUnknow) {
        str2 = @"未知";
    }
    else if (model.sharingStatus == PSPrivacySharingStatusDenied) {
        str2 = @"不同意";
    }
    else if (model.sharingStatus == PSPrivacySharingStatusAuthorized) {
        str2 = @"同意";
    }
    string = [NSString stringWithFormat:@"是否同意分享隐私信息：%@",str2];
    NSLog(@"%@", string);
    
    string = @"----------------------------";
    NSLog(@"%@", string);
}

@end
