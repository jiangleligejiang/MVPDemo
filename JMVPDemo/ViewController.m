//
//  ViewController.m
//  JMVPDemo
//
//  Created by jams on 2019/5/23.
//  Copyright © 2019 jams. All rights reserved.
//

#import "ViewController.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "NewsPresenter.h"
#import "FeedbackPresenter.h"
#import "Masonry.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, NewsViewDelegate>
@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSMutableArray<NewsModel *> *dataSource;
@property (nonatomic, strong) NewsPresenter *newsPresenter;
@property (nonatomic, strong) FeedbackPresenter *feedbackPresenter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.refresh];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.sendBtn];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(50);
        make.height.mas_equalTo(400);
        make.width.mas_equalTo(weakSelf.view.bounds.size.width);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tableView.mas_bottom).offset(80);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300, 100));
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.textView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    [self.newsPresenter loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource ? self.dataSource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewsCell class])];
    if (!cell) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NewsCell class])];
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - NewsViewDelegate
- (void)onRefreshData:(NSArray<NewsModel *> *)data {
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    [self.dataSource addObjectsFromArray:data];
    [self.tableView reloadData];
}

#pragma mark - event
- (void)pullToRefresh {
    [self.refresh endRefreshing];
    [self.newsPresenter refreshData];
}

- (void)sendBtnDidClick:(UIButton *)btn {
    [self.feedbackPresenter submitFeedback:self.textView.text];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - getter
- (UIRefreshControl *)refresh {
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc] init];
        [_refresh addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor lightGrayColor];
        [_tableView registerClass:[NewsCell class] forCellReuseIdentifier:NSStringFromClass([NewsCell class])];
    }
    return _tableView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor blueColor];
        _textView.font = [UIFont boldSystemFontOfSize:14];
        _textView.textColor = [UIColor whiteColor];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.editable = YES;
    }
    return _textView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor lightGrayColor];
        [_sendBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (NewsPresenter *)newsPresenter {
    if (!_newsPresenter) {
        _newsPresenter = [[NewsPresenter alloc] initWithView:self];
    }
    return _newsPresenter;
}

- (FeedbackPresenter *)feedbackPresenter {
    if (!_feedbackPresenter) {
        _feedbackPresenter = [[FeedbackPresenter alloc] initWithView:self];
    }
    return _feedbackPresenter;
}

@end
