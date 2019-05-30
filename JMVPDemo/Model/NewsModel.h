//
//  NewsModel.h
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject
@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
