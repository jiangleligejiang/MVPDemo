//
//  FeedbackService.m
//  JMVPDemo
//
//  Created by liuqiang on 2019/5/30.
//  Copyright © 2019 jams. All rights reserved.
//

#import "FeedbackService.h"

@implementation FeedbackService

- (void)postFeedback:(NSString *)text completion:(void (^)(BOOL))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(YES);
    });
}

@end
