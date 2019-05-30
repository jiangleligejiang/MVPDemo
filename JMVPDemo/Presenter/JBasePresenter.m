//
//  JBasePresenter.m
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBasePresenter.h"

@implementation JBasePresenter

- (instancetype)initWithView:(id<JBaseViewDelegate>)view {
    if (self = [super init]) {
        _view = view;
    }
    return self;
}

- (id<JBaseViewDelegate>)view {
    return _view;
}

@end
