//
//  AvatarEntityView.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import "AvatarEntityView.h"
#import <Masonry/Masonry.h>

@interface AvatarEntityCell : UICollectionViewCell
@property (nonatomic, weak) UIImageView *imageV;
@end

@implementation AvatarEntityCell

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
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageV = imageView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(35);
    }];
}

@end



@interface AvatarEntityView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger selecedIndex;
@end

@implementation AvatarEntityView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupCellectionView];
        [self setupLineView];
    }
    return self;
}

- (void)setupCellectionView
{
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.itemSize = CGSizeMake(60, self.frame.size.height);
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[AvatarEntityCell class] forCellWithReuseIdentifier:NSStringFromClass([AvatarEntityCell class])];
    self.collectionView = collectionView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setupLineView
{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(avatarEntitySelectedIndex:entityInfo:)]) {
        [self.delegate avatarEntitySelectedIndex:self.selecedIndex entityInfo:dataSource[_selecedIndex]];
    }
}


#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AvatarEntityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AvatarEntityCell class]) forIndexPath:indexPath];
    AvatarEntityInfo *info = self.dataSource[indexPath.row];
    NSString *imageUrl = info.iconUrl;
    if (indexPath.row == self.selecedIndex) {
        imageUrl = info.checkedIconUrl;
    }
    [cell.imageV setImageWithURL:[NSURL URLWithString:imageUrl]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.selecedIndex) {
        return;
    }
    AvatarEntityInfo *info = self.dataSource[self.selecedIndex];
    AvatarEntityCell *cell = (AvatarEntityCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selecedIndex inSection:0]];
    [cell.imageV setImageWithURL:[NSURL URLWithString:info.iconUrl]];

    AvatarEntityInfo *selInfo = self.dataSource[indexPath.row];
    AvatarEntityCell *selCell = (AvatarEntityCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [selCell.imageV setImageWithURL:[NSURL URLWithString:selInfo.checkedIconUrl]];
    self.selecedIndex = indexPath.row;
//    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(avatarEntitySelectedIndex:entityInfo:)]) {
        [self.delegate avatarEntitySelectedIndex:self.selecedIndex entityInfo:selInfo];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, self.frame.size.height);
}


@end
