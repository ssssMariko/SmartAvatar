//
//  AvatarPanelItemSelectorView.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/9.
//

#import <UIKit/UIKit.h>
#import "../Model/AvatarItemInfo.h"
NS_ASSUME_NONNULL_BEGIN

@protocol AvatarItemSelectorProtocol <NSObject>

- (void)avatarItemSelectedIndex:(NSInteger)index subTabInfo:(AvatarItemInfo *)itemInfo;

@end

@interface AvatarPanelItemSelectorView : UIView
@property (nonatomic, weak) id<AvatarItemSelectorProtocol> delegate;
@property (nonatomic, copy) NSArray *itemDataSource;

@end

NS_ASSUME_NONNULL_END
