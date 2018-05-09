# Router



## 名称规则说明

* `scheme` ： 由于`iOS`对于`scheme`的大小写不敏感，所以为了方便的去匹配，这里所有的`scheme`都会被处理成小写字母的模式，不过外部在使用的时候不用在意这个，这个在都是在内部自动的转换的。所以，外部在使用的时候，`scheme://`和`SchEme://`的效果都是一样的。
* `path` : 为了方便的匹配，这里所有的`path`如果以`/`开头都会被删掉，所以外部在执行跳转的时候，`/market/detail`和`market/detail`的效果都是一样的。

## 功能

1. 支持基本的`push`和`present`的页面跳转
2. 支持页面的返回`pop`、`dismiss`操作
3. 支持`keyWindow`的根视图的切换操作
4. 支持页面跳转的拦截
5. 支持对于目标页面的`callback`
6. 支持参数的动态映射
7. 等等。。。

## 基本信息注册

### 1、注册`scheme`

`scheme`是识别一个`app`的重要标识，所以这个必须注册，当然，也提供了取消注册的方法。

对于注册，这里提供三种方式：

#### 直接注册

可以使用`registerScheme:`方法，给定一个有效的`scheme`直接注册。

#### 隐式的注册

可以直接在注册路由地址(`path`，即`registerPath:`系列方法)的时候注册，如果路由地址中带有`scheme`则会自动的去注册。

#### 使用全局的`scheme`

使用`registerDefaultScheme:`方法注册，注册了以后，在后续的路由地址的操作的时候，如果不带`scheme`，则会使用这个默认的`scheme`来执行相应的操作。

### 2、注册路由地址

由于所有的路由地址都是跟`scheme`进行了绑定，所以在注册路由地址的时候必须得有对应的`scheme`，有两种方式：

* `scheme` + `path`的方式，如`ft://market/detail`这样，如果发现`ft`这个`scheme`没有被注册，那么便会自动给注册，并绑定上`market/detail`路由地址。
* 使用`registerDefaultScheme:`注册一个默认的`scheme`，那么在项目内的所有不带`scheme`的路由地址，在执行跳转、注册等，都会默认的使用注册的默认的`scheme`。

再者，由于使用路由地址跳转的时候，需要知道目标对象是谁，所以，每个路由地址再注册的时候都必须绑定对应的类名，否则会注册失败。

此处还提供了批量的注册，即可以使用`plist`和`JSON`文件，或者字典注册，其实内部都是转成了字典并去注册的，其格式必须如下：

```json
{
  "account/setting" : "SettingViewController",
  "contract/list" : "ContractsListViewController",
  "ft://order/flash" : "FlashOrderViewController",
  "ft://contract/edit" : "GroupEditViewController"
}
```

## 路由跳转

```objective-c
__weak typeof(self) weakself = self;
// 带回调block
[FTRouter routeURL:[NSURL URLWithString:@"ft://present/contract/edit"] parameters:@{@"datas" : self.datas} callBack:^id(__weak id directedTarget, id userInfo) {
    __strong typeof(weakself) strongSelf = weakself;
    [strongSelf randomDatas];
    return nil;
}];
```

如果注册了默认的`scheme`，那么这里跳转的路由地址可以不带`scheme`，如直接跳转`market/detail`即可。

这里可以附带一些参数进去，当然也能附带一个回调的`block`，会调用`mergeParamsFromComponents:`方法映射到目标的对象。

### 1、路由地址的解析

这里默认跳转的路由地址如：`scheme://host/path?query#fragment`，所有解析到的信息都会保存到`FTRouterComponents`对象里。

* `scheme` : 开始也说了，对于一个`app`的识别标识，如果注册了默认的`scheme`，那么跳转的时候也可以不用带。在前面也说了，`scheme`在使用的时候，`Router`内会自动的转成小写的，所以外面在使用的时候不必在意大小写。
* `host` : 看个人的使用习惯了，比如可以在一个项目里分多个模块，每个模块用不同的`host`做标识，等等。因为这是`URL`的一个标准，所以在这里做了一下处理，有一个全局的参数`alwaysTreatsHostAsPathComponent`，如果设置为`YES`，那么会把`host`拼到`path`里去，否则就不管。
* `path` : 在前面注册了的页面唯一的地址，用于在执行跳转的时候知道目标页面时哪里，这里也做了一下特殊处理。在解析`path`的时候，会对其做一个拆分，并对第一部分做一个判断，如果是以下几种的话，会解析成相应的跳转方式，即`transitionType`属性，并从`path`中删除，所以，在注册地址的时候，最好不要使用以下几种作为开头地址：
  * `push` - 解析为`FTRouterTransitionTypePush`，用于`UINavigationController`的页面跳转；
  * `present` - 解析为`FTRouterTransitionTypePresent`，即页面间模态的跳转；
  * `back` - 解析为`FTRouterTransitionTypePageback`，即执行返回操作；
  * `root` - 解析为`FTRouterTransitionTypeRoot`，即切换当前`keyWindow`的根视图的操作。
* `query` : 通常以键值对的形式存在，如`a=b&c=d&e=f`等，这里会解析成一个字典，放在`queryParams`属性里。
* `fragment` - 在`URL`里做锚点，用于跳到页面的指定位置，在这里用作跳转到目标页面后有目标页面执行的一个`URL`。如果`fragment`里没有带`scheme`的话，会将当前跳转的`URL`中的`scheme`拼进来。使用的场景如，跳转到别的APP的时候，别的`APP`可以通过这个附加的地址回调回来，并传回所需要的信息。

### 2、基本跳转

在FTRouter`单例里注册一个`handlerBlock`，那么在所有执行的跳转中都会调用这个`block`，并把跳转中解析到的所有数据都传递到这里来，由自己来决定跳转到哪个页面，该怎么跳转，如：

```objective-c
[[FTRouter shared] setHandlerBlock:^BOOL(FTRouterComponents *components) {
    // ....
    return YES;
}];
```

### 3、自动跳转

在`FTRouter`中可以设置一个`keyWindow`，如果没有设置`handlerBlock`，那么在执行页面跳转的时候就可以自动的执行页面的各种跳转。

当然，也有几个属性可以控制自动的跳转的流程。

- `shouldAutoTransitionInspector`是一个`block`，用于控制是否可以执行自动的页面跳转，如果返回`NO`，那么就会终止页面的跳转流程。
- `willTransitionInspector`是一个`block`，用于对即将跳转的页面做特殊的处理，比如注册的是一个普通的视图控制器页面，但是在执行`present`跳转的时候我需要跳转到一个导航控制器的页面，那么就可以这么做：

```objective-c
[[FTRouter shared] setWillTransitionInspector:^id(FTRouterComponents *components, UIViewController *topViewController) {
    if (components.transitionType == FTRouterTransitionTypePresent ||
        components.transitionType == FTRouterTransitionTypeRoot) {

        Class destCls = components.destination ? NSClassFromString(components.destination) : NULL;
        if (destCls != NULL && [destCls isSubclassOfClass:[UIViewController class]]) {
            UIViewController *destVC = [[destCls alloc] init];
            // 由于对页面做了特殊的处理，返回的不是注册的页面，所以需要自己调用这个方法做参数的映射
            [destVC mergeParamsFromComponents:components transitionFrom:topViewController];
            return [[UINavigationController alloc] initWithRootViewController:destVC];
        }
    }
    // 如果返回为nil，那么会在内部自己去实例化目标页面并做参数的映射。
    return nil;
}];
```

当然，对于`back`和`root`两种跳转方式也支持。

## 关于

[Using URL Schemes to Communicate with Apps](https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html)

[Structure of a URL](https://developer.apple.com/documentation/foundation/nsurl)

[iOS中scheme详解](https://blog.csdn.net/jsd0915/article/details/72547855?utm_source=itdadao&utm_medium=referral)

## TODO

- [x] 单例视图跳转的支持可以看[这里](https://github.com/JyHu/ReusedNavigationPage)
- [ ] 稳定性的调试和优化
- [x] 增加URL中文UTF8编解码的支持
- [ ] 自动跳转时特殊处理的`willTransitionInspector`优化
- [ ] 增加一些常用的第三方APP的`scheme`

## License

[`MIT License`](./LICENSE)
