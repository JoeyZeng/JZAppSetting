//
//  JZAppSettingTableVC.m
//  JZAppSetting
//
//  Created by zengzhaoying on 2021/9/24.
//

#import "JZAppSettingTableVC.h"
#import "JZAppSetting.h"
#import "JZTableCell.h"
#import "JZAppSettingMacro.h"

@interface JZOptionTableVC : UITableViewController
@property (nonatomic, copy) NSDictionary *settingDic;
@property (nonatomic, copy, readonly) NSArray *options;
@property (nonatomic, readonly) NSUInteger selectedIndex;
@end

@implementation JZOptionTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.settingDic[kTitle];
    _options = self.settingDic[kTitles];
    
    NSString *value = [JZAppSetting stringForKey:self.settingDic[kKey]];
    NSUInteger index = 0;
    for (NSString *title in self.options) {
        if ([value isEqualToString:title]) {
            _selectedIndex = index;
            break;
        }
        index ++;
    }
    
    [self.tableView registerClass:[JZOptionTableCell class] forCellReuseIdentifier:@"cellId"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JZOptionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = self.options[indexPath.row];
    cell.accessoryType = self.selectedIndex == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.options[self.selectedIndex] forKey:self.settingDic[kKey]];
}

@end

@interface JZAppSettingTableVC ()
@property (nonatomic, copy) NSArray *dataArray;
@end

@implementation JZAppSettingTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title  = @"App Settings";
    [self initDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChangeAction) name:NSUserDefaultsDidChangeNotification object:nil];
    
    // If enter from present model, add left back nav item
    if (self.presentingViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
}

- (void)userDefaultsDidChangeAction {
    [self.tableView reloadData];
}

- (void)dismiss {
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)initDataSource {
    NSArray *items = [[JZAppSetting shared] valueForKey:@"preferenceItems"];
    NSMutableArray <NSDictionary *>*dataArray = [NSMutableArray new];
    NSMutableArray <NSDictionary *>*subArray = nil;
    for (NSDictionary *item in items) {
        NSString *type = item[kType];
        if ([type isEqualToString:kTypeGroup]) {
            // Divid by group
            subArray = [NSMutableArray new];
            NSDictionary *dic = @{@"title": item[@"Title"], @"items": subArray};
            [dataArray addObject:dic];
        } else {
            // only show 3 type
            if ([type isEqualToString:kTypeText] ||
                [type isEqualToString:kTypeSwitch] ||
                [type isEqualToString:kTypeMulti]) {
                [subArray addObject:item];
            }
        }
    }
    self.dataArray = dataArray.copy;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subArray = self.dataArray[section][@"items"];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JZTableCell *cell = nil;
    
    NSDictionary *item = self.dataArray[indexPath.section][@"items"][indexPath.row];
    NSString *type = item[kType];
    if ([type isEqualToString:kTypeSwitch]) {
        JZSwitchTableCell *switchCell = [tableView dequeueReusableCellWithIdentifier:kTypeSwitch];
        if (switchCell == nil) {
            switchCell = [[JZSwitchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTypeSwitch];
        }
        
        switchCell.triggerSwitch.on = [JZAppSetting boolForKey:item[kKey]];
        cell = switchCell;
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:type];
        if (cell == nil) {
            if ([type isEqualToString:kTypeText]) {
                cell = [[JZTextTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:type];
            } else {
                cell = [[JZMultiTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:type];
            }
        }

        cell.detailTextLabel.text = [JZAppSetting stringForKey:item[kKey]];
        
    }
    
    cell.textLabel.text = item[kTitle];
    cell.cellData = item;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section][@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.dataArray[indexPath.section][@"items"][indexPath.row];
    NSString *type = item[kType];
    if ([type isEqualToString:kTypeMulti]) {
        JZOptionTableVC *optionVC = [[JZOptionTableVC alloc] initWithStyle:UITableViewStyleGrouped];
        optionVC.settingDic = item;
        [self.navigationController pushViewController:optionVC animated:YES];
    }
}

@end
