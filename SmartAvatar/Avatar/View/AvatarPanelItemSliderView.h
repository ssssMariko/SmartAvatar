//
//  AvatarPanelItemSliderView.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/9.
//

#import <UIKit/UIKit.h>
#import "../Model/AvatarItemInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AvatarItemSliderProtocol <NSObject>

- (void)avatarItemSliderValueChange:(AvatarItemInfo *)itemInfo;

@end

@interface AvatarPanelItemSliderView : UIView

@property (nonatomic, strong) AvatarItemInfo *itemInfo;

@property (nonatomic, weak) id<AvatarItemSliderProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
