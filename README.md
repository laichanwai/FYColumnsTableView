#  FYColumnsTableView

分列多级列表

> 原生风格 API，上手简单。

![20170907150477653828438.png](http://7xlykq.com1.z0.glb.clouddn.com/images/upi/20170907150477653828438.png-500x500)

## 使用

### 分级列表

```objc
FYColumnsTableView *tableView = [[FYColumnsTableView alloc] initWithFrame:frame];
tableView.columns = 2;  // 指定列数
tableView.delegate = self;
```

### 分级关联列表

```objc
FYColumnsTableView *tableView = [[FYColumnsTableView alloc] initWithFrame:frame];
tableView.columns = 2;
tableView.delegate = self;
tableView.relactive = YES; // 设置关联滚动
```

