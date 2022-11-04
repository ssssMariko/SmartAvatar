//
//  AvatarPanelItemSliderView.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/9.
//

//#import "AvatarPanelItemSliderView.h"
#import <Masonry/Masonry.h>
#import "AvatarPanelitemCollectionCell.h"
#import "AvatarPanelItemSliderView.h"

@interface AvatarPanelItemSliderView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSArray *allKeys;
@end

@implementation AvatarPanelItemSliderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.bounces = NO;
    [tableView registerClass:[AvatarPanelitemTableCell class] forCellReuseIdentifier:NSStringFromClass([AvatarPanelitemTableCell class])];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setItemInfo:(AvatarItemInfo *)itemInfo
{
    _itemInfo = itemInfo;
    _allKeys = itemInfo.labels.allKeys;
    [self.tableView reloadData];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AvatarPanelitemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AvatarPanelitemTableCell class])];
    NSString *key = self.allKeys[indexPath.row];
    cell.sourceDict = @{key : self.itemInfo.labels[key]};
    cell.valueDict = @{key : self.itemInfo.valueDcit[key]};
    __weak typeof(self) weakSelf = self;
    cell.callback = ^(NSString * _Nonnull key, CGFloat value) {
//        [weakSelf.itemInfo.valueDcit setValue:@(value) forKey:key];
        [weakSelf.itemInfo updateValueDict:@(value) key:key];
        if ([weakSelf.delegate respondsToSelector:@selector(avatarItemSliderValueChange:)]) {
            [weakSelf.delegate avatarItemSliderValueChange:weakSelf.itemInfo];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
