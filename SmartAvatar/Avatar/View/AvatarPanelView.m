//
//  AvatarPanelView.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import "AvatarPanelView.h"
#import "AvatarEntityView.h"
#import <Masonry/Masonry.h>
#import "AvatarPanelSubTabView.h"
#import "AvatarPanelItemSelectorView.h"
#import "AvatarPanelItemSliderView.h"

@implementation AvatarSelectedInfo

@end

@interface AvatarPanelView ()<AvatarEntityProtocol,AvatarSubTabProtocol,AvatarItemSelectorProtocol,AvatarItemSliderProtocol>

@property (nonatomic, copy) NSArray *dataSource;
//@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, weak) AvatarEntityView *entityView;
@property (nonatomic, weak) AvatarPanelSubTabView *subTabView;
@property (nonatomic, weak) AvatarPanelItemSelectorView *selectorView;
@property (nonatomic, weak) AvatarPanelItemSliderView *sliderView;

@property (nonatomic, strong) AvatarEntityInfo *curEntityInfo;
@property (nonatomic, strong) AvatarSubTabInfo *curSubTabInfo;

@end

@implementation AvatarPanelView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.selectedArray = [NSMutableArray array];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    AvatarEntityView *entityView = [[AvatarEntityView alloc] init];
    entityView.delegate = self;
    [self addSubview:entityView];
    self.entityView = entityView;
    
    [entityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    AvatarPanelSubTabView *subTabView = [[AvatarPanelSubTabView alloc] init];
    subTabView.delegate = self;
    [self addSubview:subTabView];
    self.subTabView = subTabView;
    [subTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(entityView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    AvatarPanelItemSelectorView *selectorView = [[AvatarPanelItemSelectorView alloc] init];
    selectorView.delegate = self;
    [self addSubview:selectorView];
    self.selectorView = selectorView;
    [selectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.subTabView.mas_bottom);
    }];
    
    AvatarPanelItemSliderView *sliderView = [[AvatarPanelItemSliderView alloc] init];
    sliderView.delegate = self;
    [self addSubview:sliderView];
    self.sliderView = sliderView;
    
    [sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.subTabView.mas_bottom);
    }];
    
}

- (void)setupDataSource:(NSArray *)dataSource
{
    self.dataSource = dataSource;
    self.entityView.dataSource = dataSource;
}

#pragma mark - AvatarEntityProtocol
- (void)avatarEntitySelectedIndex:(NSInteger)index entityInfo:(nonnull AvatarEntityInfo *)info
{
    NSLog(@"selected name : %@",info.label);
    self.curEntityInfo = info;
    self.subTabView.info = info;
}

#pragma mark - AvatarSubTabProtocol
- (void)avatarSubTabSelectedIndex:(NSInteger)index subTabInfo:(nonnull AvatarSubTabInfo *)subInfo
{
    self.curSubTabInfo = subInfo;
    NSLog(@"--- subTabInfo:%@",subInfo.label);
    BOOL isSelectorType = subInfo.type == AvatarSubTabTypeSelector;
    self.selectorView.hidden = !isSelectorType;
    self.sliderView.hidden = isSelectorType;
    
    if (isSelectorType) {
        self.selectorView.itemDataSource = subInfo.items;
    } else {
        self.sliderView.itemInfo = subInfo.items.firstObject;
    }
}

#pragma mark - AvatarItemSelectorProtocol
- (void)avatarItemSelectedIndex:(NSInteger)index subTabInfo:(AvatarItemInfo *)itemInfo
{
    AvatarSelectedInfo *selInfo = [[AvatarSelectedInfo alloc] init];
    selInfo.category = self.curSubTabInfo.category;
    selInfo.relatedCategory = self.curSubTabInfo.relatedCategory;
    selInfo.Id = itemInfo.Id;
    selInfo.entityName = self.curEntityInfo.Id;
    selInfo.downloadUrl = itemInfo.downloadUrl;
    selInfo.bindData = itemInfo.bindData;
    
    if ([self.delegate respondsToSelector:@selector(avatarPanelItemUpdate:avatarData:)]) {
        [self.delegate avatarPanelItemUpdate:selInfo avatarData:itemInfo.avatarData];
    }
    
    // 脸型和脸型微调要联动
    if ([selInfo.category isEqualToString:@"face_type"]) {
        for (AvatarSubTabInfo * subTabInfo in self.curEntityInfo.subTabInfos) {
            if ([subTabInfo.category isEqualToString:@"face_shape_value"]) {
                AvatarItemInfo *item = subTabInfo.items.firstObject;
                if ([self.delegate respondsToSelector:@selector(avatarPanelFaceTypeChange:faceItem:)]) {
                    [self.delegate avatarPanelFaceTypeChange:selInfo faceItem:item];
                }
                break;
            }
        }
    }
}

#pragma mark - AvatarItemSliderProtocol
- (void)avatarItemSliderValueChange:(AvatarItemInfo *)itemInfo
{
    AvatarSelectedInfo *selInfo = [[AvatarSelectedInfo alloc] init];
    selInfo.category = self.curSubTabInfo.category;
    selInfo.Id = itemInfo.Id;
    selInfo.entityName = self.curEntityInfo.Id;
    selInfo.valueDcit = itemInfo.valueDcit;
    selInfo.downloadUrl = itemInfo.downloadUrl;
    selInfo.relatedCategory = self.curSubTabInfo.relatedCategory;
    selInfo.bindData = itemInfo.bindData;
    
    if ([self.delegate respondsToSelector:@selector(avatarPanelItemUpdate:avatarData:)]) {
        [self.delegate avatarPanelItemUpdate:selInfo avatarData:itemInfo.avatarData];
    }
    
    // 脸型和脸型微调要联动
    if ([selInfo.category isEqualToString:@"face_shape_value"]) {
        AvatarItemInfo *oldItem ;
        for (AvatarSubTabInfo * subTabInfo in self.curEntityInfo.subTabInfos) {
            if ([subTabInfo.category isEqualToString:@"face_type"]) {
                for (AvatarItemInfo *item in subTabInfo.items) {
                    if (item.isSelected) {
                        oldItem = item;
                        item.isSelected = NO;
                        break;
                    }
                }
                if ([self.delegate respondsToSelector:@selector(avatarPanelFaceShapeValueChange:resetCategory:)]) {
                    [self.delegate avatarPanelFaceShapeValueChange:selInfo resetCategory:@"face_type"];
                }
                break;
            }
        }
    }
    
}

@end
