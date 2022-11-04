//
//  TakePhotoViewController.h
//  BeautyDemo
//
//  Created by tao yue on 2022/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakePhotoViewController : UIViewController
@property (nonatomic, assign) BOOL isMale;

+ (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
