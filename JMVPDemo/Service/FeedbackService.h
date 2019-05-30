//
//  FeedbackService.h
//  JMVPDemo
//
//  Created by liuqiang on 2019/5/30.
//  Copyright © 2019 jams. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackService : NSObject

- (void)postFeedback:(NSString *)text completion:(void(^)(BOOL succeed))completion;

@end

NS_ASSUME_NONNULL_END
