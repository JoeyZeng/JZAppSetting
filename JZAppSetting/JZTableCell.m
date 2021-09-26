//
//  JZTableCell.m
//  JZAppSetting
//
//  Created by zengzhaoying on 2021/9/24.
//

#import "JZTableCell.h"
#import "JZAppSettingMacro.h"

@implementation JZTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation JZSwitchTableCell

- (void)initUI {
    [super initUI];
    
    self.triggerSwitch = [UISwitch new];
    self.accessoryView = self.triggerSwitch;
    
    [self.triggerSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
}

- (void)switchAction {
    [[NSUserDefaults standardUserDefaults] setBool:self.triggerSwitch.isOn forKey:self.cellData[kKey]];
}

@end

@implementation JZTextTableCell

- (void)initUI {
    [super initUI];
    
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end

@implementation JZMultiTableCell

- (void)initUI {
    [super initUI];
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end

@implementation JZOptionTableCell

- (void)initUI {
    [super initUI];
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
