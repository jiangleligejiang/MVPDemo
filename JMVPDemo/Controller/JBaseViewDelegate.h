//
//  JBaseViewDelegate.h
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol JBaseViewDelegate <NSObject>
@required
- (void)pushViewController:(UIViewController *)controller;
- (void)popViewController;
- (void)showToast:(NSString *)text;
- (void)showLoading;
- (void)hideLoading;
@end

NS_ASSUME_NONNULL_END
