//
//  FeedBackPresenter.m
//  JMVPDemo
//
//  Created by liuqiang on 2019/5/30.
//  Copyright © 2019 jams. All rights reserved.
//

#import "FeedbackPresenter.h"
#import "FeedbackService.h"

@interface FeedbackPresenter ()
@property (nonatomic, strong) FeedbackService *service;
@end

@implementation FeedbackPresenter

- (void)submitFeedback:(NSString *)text {
    if (!text || text.length == 0) {
        [self.view showToast:@"输入的内容为空!!!"];
        return;
    }
    [self.view showLoading];
    [self.service postFeedback:text completion:^(BOOL succeed) {
        [self.view hideLoading];
        if (succeed) {
            [self.view showToast:@"上传成功"];
        } else {
            [self.view showToast:@"上传失败"];
        }
    }];
}

- (FeedbackService *)service {
    if (!_service) {
        _service = [[FeedbackService alloc] init];
    }
    return _service;
}

@end
