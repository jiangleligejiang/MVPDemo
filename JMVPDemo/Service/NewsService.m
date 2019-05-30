//
//  NewsService.m
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import "NewsService.h"

@implementation NewsService

- (void)loadNewsDataWithCompletion:(void (^)(NSArray<NewsModel *> * _Nonnull))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NewsModel *model1 = [NewsModel new];
        model1.title = @"title1";
        model1.content = @"content1";
        NewsModel *model2 = [NewsModel new];
        model2.title = @"title2";
        model2.content = @"content2";
        NSArray *arr = @[model1, model2];
        completion(arr);
    });
}

- (void)refreshNewsDataWithCompletion:(void (^)(NSArray<NewsModel *> * _Nonnull))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NewsModel *model1 = [NewsModel new];
        model1.title = @"refresh_title1";
        model1.content = @"refresh_content1";
        NewsModel *model2 = [NewsModel new];
        model2.title = @"refresh_title2";
        model2.content = @"refresh_content2";
        NSArray *arr = @[model1, model2];
        completion(arr);
    });
}

@end
