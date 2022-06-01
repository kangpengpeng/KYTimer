# KYTimer

[![CI Status](https://img.shields.io/travis/搁浅de烟花/KYTimer.svg?style=flat)](https://travis-ci.org/搁浅de烟花/KYTimer)
[![Version](https://img.shields.io/cocoapods/v/KYTimer.svg?style=flat)](https://cocoapods.org/pods/KYTimer)
[![License](https://img.shields.io/cocoapods/l/KYTimer.svg?style=flat)](https://cocoapods.org/pods/KYTimer)
[![Platform](https://img.shields.io/cocoapods/p/KYTimer.svg?style=flat)](https://cocoapods.org/pods/KYTimer)

## Example

为解决命名冲突问题，修改索引文件名称为 KYMyTimer.podspec
项目中实际

```
    // 第一种定时器调用方式，需要调用者手动启动
    static int i = 0;
    [[KYTimerManager shared] timerWithName:@"com.kpp.timerExample" interval:1 repeats:YES block:^{
        i++;
        NSLog(@"定时器任务 %d", i);
        if (i > 10) {
            NSLog(@"定时器销毁");
            [[KYTimerManager shared] cancelTimerWithName:@"com.kpp.timerExample"];
        }
    }];
    [[KYTimerManager shared] resumeTimerWithName:@"com.kpp.timerExample"];
```

```
    // 第二种定时器调用方式，自动启动
    static int i = 0;
    [[KYTimerManager shared] scheduleTimerWithName:@"com.kpp.timerExample" interval:1 repeats:YES block:^{
        i++;
        NSLog(@"定时器任务 %d", i);
        if (i > 10) {
            NSLog(@"定时器销毁");
            [[KYTimerManager shared] cancelTimerWithName:@"com.kpp.timerExample"];
        }
    }];
```

## Requirements



## Installation

KYTimer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'KYMyTimer', '~> 0.1.1'
```

## Author

搁浅de烟花, 353327533@qq.com, kangpp@163.com

## License

KYTimer is available under the MIT license. See the LICENSE file for more info.
