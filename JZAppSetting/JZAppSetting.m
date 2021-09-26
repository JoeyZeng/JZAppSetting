//
//  JZAppSetting.m
//  JZAppSetting
//
//  Created by zengzhaoying on 2021/9/23.
//

#import "JZAppSetting.h"

// “Settings” 才会显示在系统设置里面，release模式隐藏配置，需要改一下名字
#define SETTINGS_BUNDLE_NAME @"Settings"

@interface JZAppSetting ()
@property (nonatomic, strong) NSMutableDictionary *defaultValueDic;
@property (nonatomic, strong) NSArray *preferenceItems;
@end

@implementation JZAppSetting

+ (instancetype)shared {
    static id instance = nil;
    if (!instance) {
        instance = [JZAppSetting new];
    }
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *settingSuffixPath = [NSString stringWithFormat:@"/%@.bundle", SETTINGS_BUNDLE_NAME];
        NSBundle *settingsBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:settingSuffixPath]];
        NSString *file = [settingsBundle pathForResource:@"Root" ofType:@"plist"];
        NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:file];
        
        // init default settings
        _defaultValueDic = [NSMutableDictionary new];
        NSArray *preferenceItems = rootDic[@"PreferenceSpecifiers"];
        self.preferenceItems = preferenceItems;
        for (NSDictionary *item in preferenceItems) {
            NSString *key = item[@"Key"];
            NSString *value = item[@"DefaultValue"];
            if (key == nil || value == nil) {
                continue;
            }
            _defaultValueDic[key] = value;
        }
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:_defaultValueDic];
    }
    return self;
}

+ (id)configForKey:(NSString *)key {
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (setting) {
//        NSLog(@"configForKey has value");
    } else {
//        NSLog(@"configForKey has no value");
        setting = [JZAppSetting shared].defaultValueDic[key];
        if (setting) {
            [[NSUserDefaults standardUserDefaults] setObject:setting forKey:key];
        }
    }
    return setting;
}

+ (BOOL)boolForKey:(NSString *)key {
    return [[self configForKey:key] boolValue];
}

+ (NSInteger)intForKey:(NSString *)key {
    return [[self configForKey:key] integerValue];
}

+ (NSString *)stringForKey:(NSString *)key {
    id setting = [self configForKey:key];
    if ([setting isKindOfClass:[NSNumber class]]) {
        return [setting stringValue];
    }
    return setting;
}

@end


