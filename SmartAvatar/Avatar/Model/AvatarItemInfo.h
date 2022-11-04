//
//  AvatarItemInfo.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import <Foundation/Foundation.h>
#import <XMagic/XMagic.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvatarItemInfo : NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *downloadUrl; // 下载链接
@property (nonatomic, copy) NSDictionary *labels;
@property (nonatomic, strong) NSMutableDictionary *valueDcit;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSArray <NSDictionary *>*bindData;
@property (nonatomic, strong) AvatarData *avatarData;

- (void)updateValueDict:(id)value key:(id)key;

@end

NS_ASSUME_NONNULL_END
