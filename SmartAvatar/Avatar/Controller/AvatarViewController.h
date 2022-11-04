//
//  AvatarViewController.h
//  BeautyDemo
//
//  Created by chavezchen on 2022/8/10.
//

#import <UIKit/UIKit.h>
//#import "../../BeautyDefine.h"
#import "../DataSource/AvatarResManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AvatarProcessType) {
    AvatarPixelData,
    AvatarTextureData
};

@interface AvatarViewController : UIViewController
//@property(nonatomic, assign) PreviewResolution currentPreviewResolution;
@property (nonatomic, assign) AvatarProcessType currentDebugProcessType;
@property (nonatomic, copy) NSString *photoAvatarSrc;
@property (nonatomic, copy) NSString *photoAvatarResPath;
@property (nonatomic, assign) AvatarGender photoGender;
@property (nonatomic, assign) AvatarShowType showType;
@end

NS_ASSUME_NONNULL_END
