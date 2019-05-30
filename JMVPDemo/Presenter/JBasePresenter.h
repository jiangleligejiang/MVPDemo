//
//  JBasePresenter.h
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBaseViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface JBasePresenter<T : id<JBaseViewDelegate>> : NSObject {
    __weak T _view;
}

- (instancetype)initWithView:(T)view;

- (T)view;

@end

NS_ASSUME_NONNULL_END
