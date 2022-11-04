//
//  AvatarPanelItemSelectorView.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/9.
//

#import "AvatarPanelItemSelectorView.h"
#import <Masonry/Masonry.h>
#import "AvatarPanelitemCollectionCell.h"
#import "../Model/AvatarItemInfo.h"

static CGFloat const kLeftMargin = 16;
static CGFloat const kItemMargin = 30;

@interface AvatarPanelItemSelectorView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selecedIndex;
@property (nonatomic, assign) NSInteger itemCountOfLine;
@end

@implementation AvatarPanelItemSelectorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView
{
    self.layout = [[UICollectionViewFlowLayout alloc] init];
//    self.layout.itemSize = CGSizeMake(60, 60);
    self.layout.minimumLineSpacing = 30;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    [self addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[AvatarPanelitemCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([AvatarPanelitemCollectionCell class])];
    self.collectionView = collectionView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setItemDataSource:(NSArray *)itemDataSource
{
    _itemDataSource = itemDataSource;
    _itemCountOfLine = 3;
    _selecedIndex = 0;
    for (int i = 0; i < itemDataSource.count; i++) {
        AvatarItemInfo *info = itemDataSource[i];
        if ([info.icon hasPrefix:@"#ff"]) {
            _itemCountOfLine = 4;
        }
        if (info.isSelected == YES) {
            _selecedIndex = i;
        }
    }
//    for (AvatarItemInfo *info in itemDataSource) {
//        if ([info.icon hasPrefix:@"#ff"]) {
//            _itemCountOfLine = 4;
//        }
//    }
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemDataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AvatarPanelitemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AvatarPanelitemCollectionCell class]) forIndexPath:indexPath];
    AvatarItemInfo *info = self.itemDataSource[indexPath.row];
    [cell setInfo:info];
//    cell.selected = self.selecedIndex == indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AvatarItemInfo *selInfo = self.itemDataSource[indexPath.row];
    if (indexPath.row == self.selecedIndex) {
        return;
    }
    AvatarItemInfo *oldSelInfo = self.itemDataSource[self.selecedIndex];
    oldSelInfo.isSelected = NO;
    
    selInfo.isSelected = YES;
    self.selecedIndex = indexPath.row;
    
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(avatarItemSelectedIndex:subTabInfo:)]) {
        [self.delegate avatarItemSelectedIndex:indexPath.row subTabInfo:selInfo];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.frame.size.width;

    CGFloat itemWidth = (width - kLeftMargin * 2 - kItemMargin * 2) / _itemCountOfLine;
    return CGSizeMake(itemWidth, itemWidth);
}

@end
