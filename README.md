## 前言
> 最近在做一些重构项目的工作，发现项目中存在一个非常麻烦却又常见的问题——“庞大臃肿”的view controller！麻烦的原因是view controller中包含太多业务处理了，比较难下手。而说常见的原因是这种现状已经成为很多大型项目的通病了！动不动就上千行，阅读起来非常不便，后期迭代和维护也很麻烦。

## 分析原因
> 大致阅读了一些较为复杂的view controller，发现主要包括以下原因：
- 分层不清晰，view controller里面不仅包括视图绑定/更新，还有网络请求、数据解析，业务迭代逻辑等等...
- 业务逻辑划分不明确，基本上都在放在一起，只是简单用```#params```来划分
- view controller之间相互被引用，迁移性差
......

## 怎么搞
> 针对上面的原因分析，接下来就要思考怎么解决。其实，很简单，我们就是要对view controller进行“瘦身”，把一些不必要的东西分割出去。重点是如何去分割呢？目前市场上比较流行的架构便是MVC、MVP和MVVM三种了。原本项目采用的便是MVC架构，其实并非MVC不好，只是分层不清晰的话，就会导致很多问题。所以这次重构就摒除了这种选择。若采用MVVM架构的话，则需要利用到动态绑定技术。一般会选取[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)作为动态绑定方案，而它需要一定的学习成本，且定位问题起来也比较麻烦。所以，最终决定采用MVP架构来进行重构。

## MVP架构
![](https://user-gold-cdn.xitu.io/2019/5/30/16b08ec0b5f09e12?w=760&h=313&f=png&s=28477)
> 未重构前的架构图如上所示，view controller几乎包含了所有职责处理。

![](https://user-gold-cdn.xitu.io/2019/5/30/16b08ec68f5dea12?w=762&h=227&f=png&s=23903)
> 如上图所示，对比原来的view controller，新增了presenter层和service层。将业务逻辑放在presenter层，数据请求/解析放在service层，model层只是作为实体模型数据。

**那么这么做，有什么优势呢？**
- 可以将业务很好地区分开来，比如若包括业务P1,P2...Pn，那么我们可以将不同业务交给不同的presenter来处理。当然我们也不是说一个业务就对应一个presenter，可以将相同/相似的业务放在同一个presenter中。具体业务的粒度就要视情况而定了。只不过对比起只放在view controller，我们现在这么做，可以更灵活地去做。

![](https://user-gold-cdn.xitu.io/2019/5/30/16b08ed107436fad?w=734&h=202&f=png&s=21454)

## 具体怎么实现
> 我们以一个简单的例子来说明，假设我们的```view controller```中包含两个业务，一个是新闻列表刷新，另一个是反馈内容上传（原谅我这脑洞....），具体如下图所示：

![](https://user-gold-cdn.xitu.io/2019/5/30/16b08b5b5ab94754)

### view的定义
> 在大型项目中很多```view controller```中需要用到很多公共的控件，比如视图跳转、加载和提示等。为此，我们可以先定义一个公共的```view delegate```，然后定义一个```BaseViewController```去实现它。这样我们在后面就可以很方便去调用这些接口。
```objc
@protocol JBaseViewDelegate <NSObject>
@required
- (void)pushViewController:(UIViewController *)controller;
- (void)popViewController;
- (void)showToast:(NSString *)text;
- (void)showLoading;
- (void)hideLoading;
@end

@interface JBaseViewController : UIViewController <JBaseViewDelegate>
@end
@implementation JBaseViewController
....
@end
```
### presenter的定义
> 我们知道presenter在处理业务逻辑时，需要对视图进行"操作"（注意：这里的操作并非真正去更新视图，而是通知view去更新）。所以presenter需要对```view delegate```进行绑定。

```objc
@interface JBasePresenter<T : id<JBaseViewDelegate>> : NSObject {
    __weak T _view;
}
- (instancetype)initWithView:(T)view;
- (T)view;
@end

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
```
- Q1:为什么这里使用泛型T
> 我们使用继承```JBaseViewDelegate```的泛型T作为presenter的视图，这么做的目的是可以保证presenter可以使用```JBaseViewDelegate```中定义的接口方法，并且可以对其进行扩展，以满足业务要求，具体可以看后面的```NewsViewDelegate```。
- Q2:这里为什么不使用成员变量，而是使用成员属性
> 很简单，因为成员变量无法使用泛型T表示，只能使用id来表示泛型，如果这么做会导致子类```view delegate```的接口方法没有限制。

#### 新闻列表业务```NewsPresenter```
> 这里简单地列举了两个功能，一个是刚进入界面时，刷新数据，另一个是下拉刷新界面
```objc
@protocol NewsViewDelegate <JBaseViewDelegate>
@required
- (void)onRefreshData:(NSArray<NewsModel *> *)data;
@end

@interface NewsPresenter : JBasePresenter<id<NewsViewDelegate>>
- (void)loadData;
- (void)refreshData;
@end
```

- Q：为什么```NewsPresenter```后面要实现```id<NewsViewDelegate>```
> 我们回到之前```BasePresenter```的定义：```<T : id<JBaseViewDelegate>>```，所以这里的```id<NewsViewDelegate>```其实就是这里的泛型T。

```objc
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
```
如上所示，相关的业务逻辑和网络请求都是在这里执行，当然这里的网络请求并不是“真正”的网络请求，具体的网路请求是交给```service```层去处理的。返回结果之后，就可以通过```view delegate```接口去通知```view```去做相关更新工作。

#### 反馈业务```FeedbackPresenter```
> 这里简单模拟反馈业务，用户输入内容，提交之后，最后响应结果。
```objc
@interface FeedbackPresenter : JBasePresenter
- (void)submitFeedback:(NSString *)text;
@end

@interface FeedbackPresenter ()
@property (nonatomic, strong) FeedbackService *service;
@end
@implementation FeedbackPresenter
- (void)submitFeedback:(NSString *)text {
    if (!text || text.length == 0) {
        [self.view showToast:@"输入的内容为空!!!"];
        return;
    }
    [self.view showLoading];
    [self.service postFeedback:text completion:^(BOOL succeed) {
        [self.view hideLoading];
        if (succeed) {
            [self.view showToast:@"上传成功"];
        } else {
            [self.view showToast:@"上传失败"];
        }
    }];
}
- (FeedbackService *)service {
    if (!_service) {
        _service = [[FeedbackService alloc] init];
    }
    return _service;
}
@end
```
- Q：为什么这里的```FeedbackPresenter```后面不需要实现协议呢？
> 因为反馈业务中并不需要对```JBaseViewDelegate```进行扩展，所以这里不需要额外实现扩展的```view delegate```。默认会绑定```JBaseViewDelegate```视图。

### Controller
> 我们将业务逻辑交给presenter，网络请求交给service，那么这时controller的职责就变得很少了。只需负责视图初始化和实现```view delegate```的接口，以及对视图的交互事件委托给presenter处理。

```objc
@interface ViewController () <UITableViewDelegate, UITableViewDataSource, NewsViewDelegate>
....
@property (nonatomic, strong) NewsPresenter *newsPresenter;
@property (nonatomic, strong) FeedbackPresenter *feedbackPresenter;
@end
....
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

#pragma mark - getter
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
```
## 小结
> 对比使用MVC架构，MVP架构能比较好地对业务进行划分，比如上面的两个业务例子，若使用MVC，那么势必会导致两个业务都会放置在view controller中。而随着业务的增加，controller就会变得非常“臃肿”了。当然MVP也存在一些劣势，比如接口和类增加，但个人觉得对比起越来越难维护的controller来说，这也是值得的。此外，使用MVP比较让人头疼的一点，就是如何划分presenter，粒度过小会导致presenter过去多，粒度过大，又会导致presenter“臃肿”起来。所以如何把握好粒度的划分也是要好好思考一下的。
