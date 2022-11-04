//
//  AvatarEntityView.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "../Model/AvatarEntityInfo.h"

NS_ASSUME_NONNULL_BEGIN


@protocol AvatarEntityProtocol <NSObject>

- (void)avatarEntitySelectedIndex:(NSInteger)index entityInfo:(AvatarEntityInfo *)info;

@end

@interface AvatarEntityView : UIView

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, weak) id<AvatarEntityProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
