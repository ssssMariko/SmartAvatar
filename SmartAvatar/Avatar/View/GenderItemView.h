//
//  GenderItemView.h
//  BeautyDemo
//
//  Created by tao yue on 2022/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GenderItemView : UIView

- (instancetype)initWithGender:(BOOL)isBoy
               selected:(BOOL)isSelected;

- (void)setSelect:(BOOL)select;

@end

NS_ASSUME_NONNULL_END
