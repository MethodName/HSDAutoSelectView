# HSDAutoSelectView


######效果图（一）
![img](https://github.com/MethodName/HSDAutoSelectView/blob/master/2017-11-24%2015_22_34.gif)

######效果图（二）
自动适应下拉选择控件，类似于网页下拉列表

![img](https://github.com/MethodName/HSDAutoSelectView/blob/master/2017-11-23%2013_53_04.gif)


+ 自动适应唤起控件位置
+ 自动适应控件大小
+ 包含默认选择设置

#使用

```objc
//引入头文件
#import "HSDAutoSelectView.h"

//初始化
HSDAutoSelectView *selectView = [HSDAutoSelectView instanceView];
//设置默认选中项
selectView.selectIndex = sender.tag;
//设置数据源
selectView.dataArray = @[@"河南省",@"江苏省",@"湖北省",@"山东省",@"上海市",@"河南省",@"江苏省",@"湖北省",@"山东省",@"上海市"];
//显示选择控件
[selectView showWithView:sender callBack:^(NSInteger selectedIndex, NSString *selectTitle) {
    //selectedIndex：选择下标、selectTitle：选中标题
    //todo...
}];

>更多详细内容，请查看demo


```

