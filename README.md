# Router



## 名称规则说明

* `scheme` ： 由于`iOS`对于`scheme`的大小写不明感，所以这里为了方便的去匹配，所以所有的`scheme`都会被处理成小写字母的模式。
* `path` : 为了方便的匹配，这里所有的`path`如果以`/`开头都会被删掉。

## 基本用法

### 1、注册`scheme`

`scheme`是识别一个`app`的重要标识，所以这个必须注册，当然，也提供了取消注册的方法。

对于注册，这里提供三种方式：

#### 直接注册

可以使用`registerScheme:`方法，给定一个有效的`scheme`直接注册；

#### 隐式的注册

可以直接在注册路由地址(`path`，即`registerPath:`系列方法)的时候注册，如果路由地址中带有`scheme`则会自动的去注册。

#### 使用全局的`scheme`

使用`registerDefaultScheme:`方法注册，注册了以后，在后续的路由地址的操作的时候，如果不带`scheme`，则会使用这个默认的`scheme`来执行相应的操作。

### 2、注册路由地址



## 进阶用法

## License

[`MIT License`](https://github.com/JyHu/Router/blob/master/LICENSE)