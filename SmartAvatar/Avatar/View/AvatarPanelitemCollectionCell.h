//
//  AvatarPanelitemCollectionView.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/8.
//

#import <UIKit/UIKit.h>
#import "../Model/AvatarItemInfo.h"

NS_ASSUME_NONNULL_BEGIN


@interface CustomSlider : UISlider

@end


@interface AvatarPanelitemCollectionCell : UICollectionViewCell

@property (nonatomic, strong) AvatarItemInfo *info;

@end



typedef void(^valueChangeBlock)(NSString *key, CGFloat value);

@interface AvatarPanelitemTableCell : UITableViewCell

@property (nonatomic, copy) NSDictionary *sourceDict;
@property (nonatomic, copy) NSDictionary *valueDict;
@property (nonatomic, copy) valueChangeBlock callback;
@end

NS_ASSUME_NONNULL_END
