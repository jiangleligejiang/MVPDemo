//
//  FeedBackPresenter.h
//  JMVPDemo
//
//  Created by liuqiang on 2019/5/30.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackPresenter : JBasePresenter

- (void)submitFeedback:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
