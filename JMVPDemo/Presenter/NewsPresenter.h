//
//  NewsPresneter.h
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBasePresenter.h"
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NewsViewDelegate <JBaseViewDelegate>
@required
- (void)onRefreshData:(NSArray<NewsModel *> *)data;
@end

@interface NewsPresenter : JBasePresenter<id<NewsViewDelegate>>

- (void)loadData;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
