//
//  NewsPresneter.m
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import "NewsPresenter.h"
#import "NewsService.h"

@interface NewsPresenter()
@property (nonatomic, strong) NewsService *service;
@end

@implementation NewsPresenter

- (void)loadData {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    [self.service loadNewsDataWithCompletion:^(NSArray<NewsModel *> *data) {
        [weakSelf.view hideLoading];
        [weakSelf.view onRefreshData:data];
    }];
}

- (void)refreshData {
    [self.view showLoading];
    __weak typeof(self) weakSelf = self;
    [self.service refreshNewsDataWithCompletion:^(NSArray<NewsModel *> *data) {
        [weakSelf.view hideLoading];
        [weakSelf.view onRefreshData:data];
    }];
}

#pragma mark - getter

- (NewsService *)service {
    if (!_service) {
        _service = [NewsService new];
    }
    return _service;
}

@end
