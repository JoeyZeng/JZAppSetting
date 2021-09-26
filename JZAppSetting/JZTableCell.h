//
//  JZTableCell.h
//  JZAppSetting
//
//  Created by zengzhaoying on 2021/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JZTableCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *cellData;
- (void)initUI;
@end

@interface JZSwitchTableCell : JZTableCell
@property (nonatomic, strong) UISwitch *triggerSwitch;
@end

@interface JZTextTableCell : JZTableCell
@end

@interface JZMultiTableCell : JZTableCell
@end

@interface JZOptionTableCell : JZTableCell
@end

NS_ASSUME_NONNULL_END
