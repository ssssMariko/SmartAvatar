//
//  AvatarPanelView.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import <UIKit/UIKit.h>
#import "../Model/AvatarItemInfo.h"

NS_ASSUME_NONNULL_BEGIN
@class AvatarData;
@interface AvatarSelectedInfo : NSObject

@property (nonatomic, copy) NSString * _Nonnull category;
@property (nonatomic, copy) NSString * _Nonnull Id;
@property (nonatomic, copy) NSString * _Nonnull entityName;
@property (nonatomic, copy) NSString * downloadUrl; // 下载链接
@property (nonatomic, copy) NSString * relatedCategory; // 关联的类型，选中某个时会影响关联的那个，需要将关联的配置根据之前的状态重新设置上去
//@property (nonatomic, assign) NSInteger type; // 0:选择型数据 1:滑杆型数据
@property (nonatomic, copy) NSDictionary *valueDcit;
@property (nonatomic, copy) NSArray <NSDictionary *>*bindData; // 绑定的类型，选中某个时要跟随选中绑定的这个
@end

@protocol AvatarPanelProtocol <NSObject>
// panel面板值改变
- (void)avatarPanelItemUpdate:(AvatarSelectedInfo *)info avatarData:(AvatarData *)selAvatar;
// 脸部类型变换回调，脸部类型 和 脸部微调修改的是同一个值，需要联动。。
- (void)avatarPanelFaceTypeChange:(AvatarSelectedInfo *)info faceItem:(AvatarItemInfo *)itemInfo;
// 脸部微调调整，需要将脸部类型选中置为非选中状态
- (void)avatarPanelFaceShapeValueChange:(AvatarSelectedInfo *)info resetCategory:(NSString *)category;
@end



@interface AvatarPanelView : UIView

- (void)setupDataSource:(NSArray *)dataSource;
@property (nonatomic, weak) id<AvatarPanelProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
