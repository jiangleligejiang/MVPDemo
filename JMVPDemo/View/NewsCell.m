//
//  NewsCell.m
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import "NewsCell.h"
#import "Masonry.h"

@interface NewsCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(5);
        make.left.mas_equalTo(weakSelf).offset(20);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-5);
        make.left.mas_equalTo(weakSelf.titleLabel);
    }];
}

- (void)setModel:(NewsModel *)model {
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

@end
