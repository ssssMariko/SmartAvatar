//
//  AvatarEntityInfo.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import <Foundation/Foundation.h>
#import "AvatarSubTabInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface AvatarEntityInfo : NSObject
//
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *label; // 部位名称
@property (nonatomic, copy) NSString *checkedIconUrl; // 选中url
@property (nonatomic, copy) NSString *iconUrl; // 默认图标
@property (nonatomic, copy) NSArray <AvatarSubTabInfo *>*subTabInfos; // 二级菜单
@end

NS_ASSUME_NONNULL_END
