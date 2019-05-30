//
//  NewsCell.h
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsCell : UITableViewCell

@property (nonatomic, strong) NewsModel *model;

@end

NS_ASSUME_NONNULL_END
