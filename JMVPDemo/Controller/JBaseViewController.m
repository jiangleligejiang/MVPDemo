//
//  JBaseViewController.m
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBaseViewController.h"
#import "MBProgressHUD.h"

@interface JBaseViewController () 
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation JBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - JBaseViewDelegate
- (void)pushViewController:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showToast:(NSString *)text {
    if (![self.view.subviews containsObject:self.hud]) {
        [self.view addSubview:self.hud];
    }
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = text;
    [self.view bringSubviewToFront:self.hud];
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:2];
    [self.hud removeFromSuperViewOnHide];
}

- (void)showLoading {
    if (![self.view.subviews containsObject:self.hud]) {
        [self.view addSubview:self.hud];
    }
    self.hud.label.text = nil;
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.view bringSubviewToFront:self.hud];
    [self.hud showAnimated:YES];
}

- (void)hideLoading {
    if ([self.view.subviews containsObject:self.hud]) {
        [self.hud hideAnimated:YES];
        [self.hud removeFromSuperViewOnHide];
        self.hud = nil;
    }
}

#pragma mark - getter
- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
        _hud.mode = MBProgressHUDModeText;
        _hud.userInteractionEnabled = NO;
    }
    return _hud;
}

@end
