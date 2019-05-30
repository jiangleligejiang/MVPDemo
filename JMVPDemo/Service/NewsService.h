//
//  NewsService.h
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsService : NSObject

- (void)loadNewsDataWithCompletion:(void(^)(NSArray<NewsModel *> *data))completion;

- (void)refreshNewsDataWithCompletion:(void(^)(NSArray<NewsModel *> *data))completion;

@end

NS_ASSUME_NONNULL_END
