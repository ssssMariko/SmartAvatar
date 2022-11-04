//
//  AvatarPanelSubTabView.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/8.
//

#import <UIKit/UIKit.h>
#import "../Model/AvatarEntityInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AvatarSubTabProtocol <NSObject>

- (void)avatarSubTabSelectedIndex:(NSInteger)index subTabInfo:(AvatarSubTabInfo *)subInfo;

@end

@interface AvatarPanelSubTabView : UIView
@property (nonatomic, strong) AvatarEntityInfo *info;
@property (nonatomic, weak) id<AvatarSubTabProtocol> delegate;
@end

NS_ASSUME_NONNULL_END
