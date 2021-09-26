# JZAppSetting
轻量级应用彩蛋设置，结合Settings.bundle，实现App功能设置并持久化。

## 集成方法
源码集成
- 1、把源码Download下来；
- 2、把`JZAppSetting`文件夹拉进工程；

## 使用

### 一、编辑Settings.bundle
不了解Settings可以自行百度一下，工程包含这个bundle在手机系统`设置`里可以查看配置，应用程序里通过`NSUserDefaults`即可访问对应配置。比如：AB测试，当前使用A功能，隐藏B功能，后面再切换，其实是一个开关功能，但不想让用户感知。

Settings可以支持5个Type，分别是Multi Value、Slider、TextField、Title、Toggle Switch，期中Slider、TextField这两种类型比较少用，也可以用其他三种代替。下面是Demo中的配置：

```
		<dict>
			<key>Type</key>
			<string>PSGroupSpecifier</string>
			<key>Title</key>
			<string>Group1</string>
		</dict>
		<dict>
			<key>Type</key>
			<string>PSToggleSwitchSpecifier</string>
			<key>Title</key>
			<string>A功能</string>
			<key>Key</key>
			<string>enabled_preference</string>
			<key>DefaultValue</key>
			<true/>
		</dict>
		<dict>
			<key>Type</key>
			<string>PSToggleSwitchSpecifier</string>
			<key>Title</key>
			<string>B显示</string>
			<key>Key</key>
			<string>enabled1_preference</string>
			<key>DefaultValue</key>
			<false/>
		</dict>
		<dict>
			<key>Type</key>
			<string>PSMultiValueSpecifier</string>
			<key>Title</key>
			<string>服务器环境</string>
			<key>Key</key>
			<string>env_preference</string>
			<key>DefaultValue</key>
			<string>开发</string>
			<key>Titles</key>
			<array>
				<string>开发</string>
				<string>测试</string>
				<string>预生产</string>
				<string>生产</string>
			</array>
			<key>Values</key>
			<array>
				<string>开发</string>
				<string>测试</string>
				<string>预生产</string>
				<string>生产</string>
			</array>
		</dict>
		<dict>
			<key>Type</key>
			<string>PSGroupSpecifier</string>
			<key>Title</key>
			<string>Group2</string>
		</dict>
		<dict>
			<key>Type</key>
			<string>PSTitleValueSpecifier</string>
			<key>Title</key>
			<string>版本</string>
			<key>Key</key>
			<string>version_preference</string>
			<key>DefaultValue</key>
			<string>1.0</string>
		</dict>
		<dict>
			<key>Type</key>
			<string>PSTitleValueSpecifier</string>
			<key>Title</key>
			<string>Build</string>
			<key>Key</key>
			<string>build_preference</string>
			<key>DefaultValue</key>
			<string>1</string>
		</dict>
```

### 二、读取配置

使用`JZAppSetting.h`的API可方便读取配置，对应的key为Settings中Key，如`version_preference`。

```objc
@interface JZAppSetting : NSObject

+ (instancetype)shared;

+ (id)configForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+ (NSInteger)intForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;

@end
```

### 三、显示配置彩蛋

`JZAppSettingTableVC`模拟系统设置页面，读取Settings里面信息，达到彩蛋的目的。

在需要显示配置彩蛋，直接Present或者Push进入JZAppSettingTableVC即可，比如在关于页面，快速点击5次icon进入彩蛋。

### 四、隐藏系统设置
系统加载Settings.bundle会自动在设置里出现对应App的配置，若要隐藏，只需修改Settings.bundle名称，如Settings_release.bundle，同时，JZAppSetting需要读取Settings信息，对应要在源码也要修改：

```objc
// “Settings” 才会显示在系统设置里面，release模式隐藏配置，需要改一下名字
#define SETTINGS_BUNDLE_NAME @"Settings"
```

  为什么要在系统设置隐藏配置？ - 因为彩蛋配置一般不希望用户感知。

