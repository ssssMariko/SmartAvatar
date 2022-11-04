//
//  AvatarResManager.h
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/7/15.
//

#import <Foundation/Foundation.h>
#import <XMagic/XMagic.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AvatarGender) {
    AvatarGenderMale = 0,    // 男
    AvatarGenderFemale,  // 女
};

typedef NS_ENUM(NSUInteger, AvatarShowType) {
    AvatarShowTypeFace,     // 捏脸
    AvatarShowTypePhoto,    // 拍照捏脸
    AvatarShowTypeBody      // 全身
};

@class AvatarEntityInfo;

@interface AvatarResManager : NSObject

@property (nonatomic, copy) NSString *photoAvatarResPath;
@property (nonatomic, copy) NSString *photoAvatarSrc; // 拍照解析出来的数据
@property (nonatomic, assign) AvatarShowType showType; //
@property (nonatomic, assign) AvatarGender photoAvatarSrcGender; // 拍照过来的数据性别

// avatar bundle路径
- (NSString *)avatarBundlepath;
// avatar 素材路径
- (NSString *)avatarResPath:(AvatarGender)gender;
// 获取男性素材
- (NSDictionary *)getMaleAvatarData;
// 获取女性素材
- (NSDictionary *)getFemaleAvatarData;
// 获取UI面板数据
- (NSArray <AvatarEntityInfo *>*)getPanelData:(AvatarGender)gender;
// 更新素材资源
- (void)updateAvatarList:(NSString *)category avatars:(NSArray *)avatars gender:(AvatarGender)gender;
// demo只展示两个，有账户体系的可以根据uid保存和获取
// 保存捏脸形象数据
- (BOOL)saveSelectedAvatarConfigs:(AvatarGender)gender;
// 获取保存的捏脸数据
- (NSString *)getSavedAvatarConfigs:(AvatarGender)gender;
// 获取背景avatar对象
- (AvatarData *)getBackGroudPanel:(BOOL)isVirtual gender:(AvatarGender)gender;

@end

NS_ASSUME_NONNULL_END
