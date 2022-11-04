//
//  AvatarResManager.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/7/15.
//

#import "AvatarResManager.h"
#import "../Model/AvatarEntityInfo.h"
#import "../Model/AvatarItemInfo.h"
#import "../Model/AvatarSubTabInfo.h"


// 保存的版本号
static NSString * const kSavedBuildVersion = @"kSavedBuildVersion";

@interface AvatarResManager ()
@property (nonatomic, copy) NSDictionary *maleAvatarDict;
@property (nonatomic, copy) NSDictionary *femaleAvatarDict;
@property (nonatomic, copy) NSString *saveDir;
@property (nonatomic, copy) NSString *avatarBundlePath;
@end

@implementation AvatarResManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        _saveDir = [docDir stringByAppendingFormat:@"/TXAvatar"];
        [self copyBundleToSanboxIfNeed];
    }
    return self;
}

- (NSString *)avatarBundlepath
{
    return self.avatarBundlePath;
}

- (NSString *)avatarResPath:(AvatarGender)gender
{
    // 从相机进来的，直接使用相机返回的素材地址
    if (self.photoAvatarResPath) {
        return self.photoAvatarResPath;
    }
    NSString *resName = gender == AvatarGenderFemale ? @"avatar_v2.0_female" : @"avatar_v2.0_male";
    NSString *resPath =[self.avatarBundlepath stringByAppendingPathComponent:resName];
    return resPath;
}

- (NSString *)getSaveNameWithGender:(AvatarGender)gender
{
    NSString *savedName = @"savedConfig";
    // 全身形象和捏脸要分开保存
    if (self.showType == AvatarShowTypeBody) {
        savedName = gender == AvatarGenderMale ? @"maleSavedConfig_body" : @"femaleSavedConfig_body";
    } else {
        savedName = gender == AvatarGenderMale ? @"maleSavedConfig" : @"femaleSavedConfig";
    }
    return savedName;
}

// copy资源到沙盒，因为有下载某单个素材需求，在mainBundle里面的资源文件无法修改，需要拷贝到沙盒，才可以往资源添加文件
- (void)copyBundleToSanboxIfNeed
{
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] valueForKey:kSavedBuildVersion];
    NSString *curVersion = @"1.0";
    BOOL isNewVersion = NO;
    if (oldVersion.floatValue != curVersion.floatValue) {
        isNewVersion = YES;
    }
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"avatarMotionRes" ofType:@"bundle"];
    if (!bundlePath) {
        NSLog(@"error!!!! not found avatarMotionRes.bundle");
        return;
    }
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *appLib = [libraryPath stringByAppendingString:@"/Caches"];
    self.avatarBundlePath = [appLib stringByAppendingPathComponent:@"avatarMotionRes.bundle"];
    // 如果不存在或者新版本，则copy
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.avatarBundlePath] || isNewVersion) {
        [[NSFileManager defaultManager] removeItemAtPath:self.avatarBundlePath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:self.avatarBundlePath error:nil];
        // 保存新版本
        [[NSUserDefaults standardUserDefaults] setValue:curVersion forKey:kSavedBuildVersion];
    }
}

- (BOOL)saveSelectedAvatarConfigs:(AvatarGender)gender
{
    NSMutableArray *avatarArr = [NSMutableArray array];
    NSDictionary *avatarDict = gender == AvatarGenderMale ? self.getMaleAvatarData : self.getFemaleAvatarData;
    // 1、遍历找出选中的avatar对象
    for (NSArray *arr in avatarDict.allValues) {
        for (AvatarData *config in arr) {
            if (config.type == AvatarDataTypeSelector) {
                if (config.isSelected) {
                    [avatarArr addObject:config];
                }
            } else {
                [avatarArr addObject:config];
            }
        }
    }
    // 2、调用sdk接口将选中的avatar对象导出为字符串
    NSString *savedConfig = [XMagic exportAvatar:avatarArr.copy];
    if (savedConfig.length <= 0) {
        return NO;
    }
    NSError *error;
    NSString *fileName = [self getSaveNameWithGender:gender];
    NSString *savePath = [_saveDir stringByAppendingPathComponent:fileName];
    // 判断目录是否存在，不存在则创建目录
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:_saveDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_saveDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 3、将导出的字符串写入沙盒，下次取出来可用
    [savedConfig writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

- (NSString *)getSavedAvatarConfigs:(AvatarGender)gender
{
    // 从相机拍摄过来的，直接取相机解析出来的数据作为保存的数据，沿用后面的逻辑
    if (gender == self.photoAvatarSrcGender && self.photoAvatarSrc) {
        return self.photoAvatarSrc;
    }
    
    NSString *fileName = [self getSaveNameWithGender:gender];
    NSString *savePath = [_saveDir stringByAppendingPathComponent:fileName];
    NSString *savedConfig = [NSString stringWithContentsOfFile:savePath encoding:NSUTF8StringEncoding error:nil];
    return savedConfig;
}

- (AvatarData *)getBackGroudPanel:(BOOL)isVirtual gender:(AvatarGender)gender
{
    NSDictionary *avatarDict = gender == AvatarGenderMale ? self.getMaleAvatarData : self.getFemaleAvatarData;
    NSArray *array = avatarDict[@"background_plane"];
    AvatarData *selConfig;
    // 背景实际上也是一个avatar对象，category为background_plane，替换背景就是设置不同的avatar对象
    for (AvatarData *config in array) {
        if ([config.Id isEqual:@"none"]) {
            config.isSelected = isVirtual;
        } else {
            config.isSelected = !isVirtual;
        }
        if (config.isSelected) {
            selConfig = config;
            config.isSelected = NO; // 背景选中态不保存
        }
    }
    return selConfig;
}

- (void)updateAvatarList:(NSString *)category avatars:(NSArray *)avatars gender:(AvatarGender)gender
{
    if (avatars.count == 0) {
        return;
    }
    NSMutableDictionary *mutableDict;
    if (gender == AvatarGenderMale) {
        mutableDict = self.maleAvatarDict.mutableCopy;
    } else {
        mutableDict = self.femaleAvatarDict.mutableCopy;
    }
    
    NSArray *oldArray = mutableDict[category];
    if (oldArray.count == 0) {
        [mutableDict setValue:avatars forKey:category];
    } else {
        NSMutableArray *oldArrayM = oldArray.mutableCopy;
        [oldArrayM addObjectsFromArray:avatars];
        [mutableDict setValue:oldArrayM.copy forKey:category];
    }
    if (gender == AvatarGenderMale) {
        self.maleAvatarDict = mutableDict.copy;
    } else {
        self.femaleAvatarDict = mutableDict.copy;
    }
    
}

- (NSDictionary *)getFemaleAvatarData
{
    if (!_femaleAvatarDict) {
        NSString *resDir = [self avatarResPath:AvatarGenderFemale];
        NSString *savedConfig = [self getSavedAvatarConfigs:AvatarGenderFemale];
        _femaleAvatarDict = [XMagic getAllAvatarConfig:resDir exportedAvatar:savedConfig];
    }
    
    return _femaleAvatarDict;
}

- (NSDictionary *)getMaleAvatarData
{
    if (!_maleAvatarDict) {
        NSString *resDir = [self avatarResPath:AvatarGenderMale];
        NSString *savedConfig = [self getSavedAvatarConfigs:AvatarGenderMale];
        _maleAvatarDict = [XMagic getAllAvatarConfig:resDir exportedAvatar:savedConfig];
    }
    
    return _maleAvatarDict;
}

- (NSArray *)getPanelData:(AvatarGender)gender
{
    @synchronized (self) {
        NSString *resName = gender == AvatarGenderMale ? @"avatar_v2.0_male_panel" : @"avatar_v2.0_female_panel";
        NSArray *appLanguages = [NSLocale preferredLanguages];
        NSString *currentLanguages = appLanguages.firstObject;
        NSLog(@"----- %@",currentLanguages);
        if (![currentLanguages containsString:@"zh-"]) {
            resName = [NSString stringWithFormat:@"EN_%@",resName];
        }
        NSString *panelPath = [[NSBundle mainBundle] pathForResource:resName ofType:@"json"];
        NSData *panelData = [NSData dataWithContentsOfFile:panelPath];
        NSArray *panelArr = [NSJSONSerialization JSONObjectWithData:panelData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *avatarEntitys = [NSMutableArray array];
        for (NSDictionary *dict in panelArr) {
            AvatarEntityInfo *info = [[AvatarEntityInfo alloc] init];
            [info setValuesForKeysWithDictionary:dict];
            [avatarEntitys addObject:info];
        }
        
        NSDictionary *avatarDict;
        if (gender == AvatarGenderFemale) {
            avatarDict = [self getFemaleAvatarData];
        } else {
            avatarDict = [self getMaleAvatarData];
        }
        // 更新panel面板的初始化选中态，优化:可以在这里直接把panel的数据和对应的AvatarData进行一个绑定,结偶？
        for (AvatarEntityInfo *entityInfo in avatarEntitys) {
            for (AvatarSubTabInfo *subTabinfo in entityInfo.subTabInfos) {
                NSString *category = subTabinfo.category;
                for (AvatarItemInfo *itemInfo in subTabinfo.items) {
                    NSArray *avatarArr = avatarDict[category];
                    for (AvatarData *config in avatarArr) {
                        if ([config.Id isEqualToString:itemInfo.Id]) {
                            if (config.type == AvatarDataTypeSelector) {
                                itemInfo.isSelected = config.isSelected;
                            } else {
                                itemInfo.valueDcit = config.value.mutableCopy;
                            }
                            // 将sdk模型数据直接绑定到panel模型数据上
                            itemInfo.avatarData = config;
                        }
                    }
                }
            }
        }
        return avatarEntitys.copy;
    }
}


@end
