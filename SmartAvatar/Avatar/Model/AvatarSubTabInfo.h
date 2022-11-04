//
//  AvatarSubTabInfo.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import <Foundation/Foundation.h>
#import "AvatarItemInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AvatarSubTabType)
{
    AvatarSubTabTypeSelector = 0, // 选择型数据。例如眼镜，有多种眼镜，使用时选择一种
    AvatarSubTabTypeSlider        // 滑杆调节型数据。例如调整脸颊宽度
};

@interface AvatarSubTabInfo : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *relatedCategory;
@property (nonatomic, assign) AvatarSubTabType type;
@property (nonatomic, copy) NSArray <AvatarItemInfo *>*items;
@end

NS_ASSUME_NONNULL_END
