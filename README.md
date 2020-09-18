**Echo**是一款客户端的桌面端调试工具，中文意思`回声`，寓意着Mac端和手机端之间就像回声一样相互联动。

## 背景

客户端在研发调试阶段基本都会集成一些debug工具，用来显示App的网络请求、卡顿检测结果等调试信息，以辅助RD&QA发现定位问题。目前的debug工具基本都是内置在App中。这些小屏调试工具虽然可以满足客户端相关开发同学的日常研发需求，但是同样存在着一些问题：

* 由于手机屏幕的限制，现有的debug工具在数据展示、辅助功能等方便不够丰富，在浏览以及功能操作上体验一般
* 研发调试过程中需要频繁在App和debug工具之间切换，通过功能切换完成问题验证和分析，这会打断我们在App的页面操作，使用低效。通常，为了研发调试时有更好的体验，我们可能会更习惯使用Charles、Reveal等Mac端软件来实现调试需求
* Debug工具其实是各种小调试能力的集合，现有的Debug工具基本是在展示入口上完成了聚集，一个新的调试能力的集成往往需要从零开始，扩展成本高

基于以上现状和问题，Echo大屏调试工具不仅可以满足客户端的研发调试需求，相比其他debug工具，它还具有以下优势：

* 大屏幕：显示效果更优，不影响原App的用户操作，使用体验更好
* 扩展性：内置通用模板及插件机制可快速扩展新功能，只需关注业务数据即可，降低新功能扩展成本
* 聚合型：收敛客户端研发调试工具为一体，提高RD和QA同学的效率
* 缓存机制：插件自带缓存机制，出现问题时即使脱离大屏，后续也可快速连接排查定位

## 介绍

**Echo**是一款简单易用、插件化易扩展、大屏显示和操作的客户端研发调试工具，可以实时查看App各类数据（网络请求、日志、埋点等），也可以无须改动代码快速修改预览App的效果。

![img](https://github.com/didi/echo/raw/master/Images/intro.jpg)


## 特点

* **简单易用**：将Echo和App连接到同一个局域网即可，无须额外配置。
* **功能齐全**：目前已拥有网络请求、视图层级查看修改等10几个功能，覆盖了客户端研发的大部分场景。
* **高扩展性**：插件和模块机制可以方便我们快速添加新功能。

## 功能

目前Echo已支持的功能模块分为四部分：

* **基础功能**：网络请求、NSUserDefaults查看修改、日志查看、Crash查看、GPS模拟、通知查看
* **UI视图**：视图层级查看修改、视图边框查看
* **性能检测**：内存泄漏、卡顿检测
* **业务功能**：基于插件能力可快速扩展你自己的业务插件能力

## 扩展性

**插件**

在功能章节介绍的每个能力在开发时都被抽象为一个插件，每个插件只需要关注要采集的数据及操作的响应即可，这样的设定便于我们快速的扩展新的功能。下面介绍如何快速的扩展一个新的插件：

1、新建一个继承自ECOBasePlugin的插件类，同时在`init`方法中设置插件名称以及注册渲染的UI模板。

```objectivec
+ (void)load {
    //注册插件
    [[ECOClient sharedClient] registerPlugin:[self class]];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"日志";
        [self registerTemplate:ECOUITemplateType_ListDetail data:nil];
    }
    return self;
}
```

2、如果你想在SDK连接到Mac客户端时发送连接数据或其他功能参数，请覆写`device:didChangedAuthState:`方法：

```objectivec
//连接状态变更
- (void)device:(ECOChannelDeviceInfo *)device didChangedAuthState:(BOOL)isAuthed {
    if (isAuthed) {
        id yourData = "要发送的信息";
        !self.deviceSendBlock ?: self.deviceSendBlock(device, yourData);
    }
}
```

3、如果你想处理Mac客户端发送的命令，请覆写`didReceivedPacketData:`方法：

```objectivec
#pragma mark - ECOBasePlugin methods
- (void)didReceivedPacketData:(id)data {
    // 在这里实现你自己的业务功能
    NSDictionary *dict = (NSDictionary *)data;
}
```

以上就是扩展新插件的步骤，新插件只需要关注自己的数据逻辑即可，扩展接入时都比较方便。

**模板**

在Echo的mac客户端中，内置了List-Detail、Outline和H5三个通用模板，满足了大部分业务插件的显示需求，即使不懂Mac开发也能快速的接入。
对于熟悉Mac开发的同学或者有自定义要求的同学，可以构建自己的插件模板显示，接入时只需要将模板名称与UI在Echo中做映射即可。

## 技术方案

![img](https://github.com/didi/echo/raw/master/Images/solution.jpg)

![img](https://github.com/didi/echo/raw/master/Images/echoArch.jpg)

## 如何使用

1、添加CocoaPods依赖

```
pod 'EchoSDK', :configurations => ["Debug"]
```

2、由于iOS14系统本地网络权限限制，需在工程的Info.plist文件中添加NSLocalNetworkUsageDescription和NSBonjourServices配置。在Xcode中选中Info.plist文件，右键选择Open As Source Code，并添加如下内容：

```
<key>NSLocalNetworkUsageDescription</key>
<string></string>
<key>NSBonjourServices</key>
<array>
	<string>_ECHO._tcp</string>
</array>
```

在Xcode中显示效果如下图：

![img](https://github.com/didi/echo/raw/master/Images/ios14permission.jpg)

3、在App启动时添加以下代码

```
#ifdef DEBUG
#import <EchoSDK/ECOClient.h>
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #ifdef DEBUG
    	[[ECOClient sharedClient] start];
    #endif
}
```

4、启动Echo的Mac端

手动build工程的话，可以在/Mac目录下执行`pod install`之后，启动`Echo.xcworkspace`并运行。

## iOS14 适配

iOS14系统对本地网络权限进行了更严格的限制，鉴于Echo底层用到了Bonjour服务，在Xcode12之后需要在工程的Info.plist文件中添加NSLocalNetworkUsageDescription和NSBonjourServices配置。在Xcode中选中Info.plist文件，右键选择Open As Source Code，并添加如下内容：

```
<key>NSLocalNetworkUsageDescription</key>
<string></string>
<key>NSBonjourServices</key>
<array>
	<string>_ECHO._tcp</string>
</array>
```

添加之后在Xcode中显示效果如下图：

![img](https://github.com/didi/echo/raw/master/Images/ios14permission.jpg)

> 注：即使不进行上述适配，Echo的自动连接功能仍会生效：你可以通过USB连接真机或者直接在同一台电脑上运行模拟器来实现自动连接。

## 感谢

在开发过程中，`Echo`使用和参考了以下优秀项目的部分代码

* [DoraemonKit](https://github.com/didi/DoraemonKit)
* [YourView](https://github.com/TalkingData/YourView)
* [MLeaksFinder](https://github.com/Tencent/MLeaksFinder)

## 协议

<img alt="Apache-2.0 license" src="https://www.apache.org/img/ASF20thAnniversary.jpg" width="128">

Echo 基于 Apache-2.0 协议进行分发和使用，更多信息参见 [协议文件](LICENSE)。



