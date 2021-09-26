//
//  JZAppSetting.h
//  JZAppSetting
//
//  Created by zengzhaoying on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JZAppSetting : NSObject

+ (instancetype)shared;

+ (id)configForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+ (NSInteger)intForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
