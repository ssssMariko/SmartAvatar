//
//  AvatarPanelSubTabView.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/8.
//

#import "AvatarPanelSubTabView.h"
#import <Masonry/Masonry.h>
#import "../Model/AvatarSubTabInfo.h"

#define RGBAHex(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface AvatarSubTabCell : UICollectionViewCell
@property (nonatomic, weak) UIButton *titleBtn;
@property (nonatomic, strong) AvatarSubTabInfo *info;
@end

@implementation AvatarSubTabCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:RGBAHex(0x0161F5, 1.0) forState:UIControlStateSelected];
    [btn setTitleColor:RGBAHex(0x9EA7B9, 1.0) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.userInteractionEnabled = NO;
    [self.contentView addSubview:btn];
    self.titleBtn = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

//- (void)setSelected:(BOOL)selected
//{
//    self.titleBtn.selected = selected;
//}

- (void)updateBtnSelectedState:(BOOL)selected
{
    self.titleBtn.selected = selected;
}

- (void)setInfo:(AvatarSubTabInfo *)info
{
    _info = info;
    [self.titleBtn setTitle:info.label forState:UIControlStateNormal];
}

@end

@interface AvatarPanelSubTabView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger selecedIndex;

@end

@implementation AvatarPanelSubTabView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selecedIndex = 0;
        [self setupCellectionView];
    }
    return self;
}

- (void)setupCellectionView
{
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.itemSize = CGSizeMake(40, self.frame.size.height);
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    [self addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[AvatarSubTabCell class] forCellWithReuseIdentifier:NSStringFromClass([AvatarSubTabCell class])];
    self.collectionView = collectionView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    
}

- (void)setInfo:(AvatarEntityInfo *)info
{
    _info = info;
    _selecedIndex = 0;
    [self.collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(avatarSubTabSelectedIndex: subTabInfo:)]) {
        [self.delegate avatarSubTabSelectedIndex:self.selecedIndex subTabInfo:self.info.subTabInfos[_selecedIndex]];
    }
}


#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.info.subTabInfos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AvatarSubTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AvatarSubTabCell class]) forIndexPath:indexPath];
    AvatarSubTabInfo *info = self.info.subTabInfos[indexPath.row];
    [cell setInfo:info];
    [cell updateBtnSelectedState:self.selecedIndex == indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.selecedIndex) {
        return;
    }
    
    AvatarSubTabCell *cell = (AvatarSubTabCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selecedIndex inSection:0]];
    [cell updateBtnSelectedState:NO];

    AvatarSubTabCell *selCell = (AvatarSubTabCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [selCell updateBtnSelectedState:YES];
    self.selecedIndex = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(avatarSubTabSelectedIndex:subTabInfo:)]) {
        [self.delegate avatarSubTabSelectedIndex:self.selecedIndex subTabInfo:self.info.subTabInfos[_selecedIndex]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AvatarSubTabInfo *info = self.info.subTabInfos[indexPath.row];
    CGSize titleSize = [info.label sizeWithFont:[UIFont systemFontOfSize:16]];
    CGFloat width = titleSize.width + 15;
    if (width < 60) {
        width = 60;
    }
    return CGSizeMake(width, self.frame.size.height);
}


@end
