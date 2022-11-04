//
//  GenderItemView.m
//  BeautyDemo
//
//  Created by tao yue on 2022/8/9.
//

#import "GenderItemView.h"
#import <Masonry/Masonry.h>

@interface GenderItemView()

@property (nonatomic, strong) UIImageView *whiteRoundImageView;
@property (nonatomic, strong) UIImageView *blueCircleImageView;
@property (nonatomic, strong) UIImageView *genderIcon;
@property (nonatomic, strong) UIImageView *selectedIcon;
@property (nonatomic, strong) UILabel *genderEnglishLabel;
@property (nonatomic, strong) UILabel *genderChineseLabel;
@property bool boy;
@property bool selected;

@end

@implementation GenderItemView

- (instancetype)initWithGender:(BOOL)isBoy selected:(BOOL)isSelected{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.boy = isBoy;
        self.selected = isSelected;
        
        [self addSubview:self.whiteRoundImageView];
        [self.whiteRoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.width.height.mas_equalTo(92);
        }];
        
        [self addSubview:self.blueCircleImageView];
        [self.blueCircleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(7);
            make.top.equalTo(self).offset(5);
            make.width.mas_equalTo(105);
            make.height.mas_equalTo(103);
        }];
        self.blueCircleImageView.hidden = !self.selected;
        
        [self addSubview:self.genderIcon];
        [self.genderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.top.equalTo(self).offset(10);
            make.width.height.mas_equalTo(70);
        }];
        
        [self addSubview:self.selectedIcon];
        [self.selectedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(45);
            make.right.equalTo(self).offset(-45);
            make.top.equalTo(self).offset(95);
            make.width.height.mas_equalTo(33);
        }];
        self.selectedIcon.hidden = !self.selected;
        
//        [self addSubview:self.genderEnglishLabel];
//        [self.genderEnglishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self);
//            make.top.equalTo(self).offset(143);
//            make.height.mas_equalTo(26);
//        }];
        
        [self addSubview:self.genderChineseLabel];
        [self.genderChineseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(100);
            make.height.mas_equalTo(22);
        }];
    }
    return  self;
}

- (void)setSelect:(BOOL)select{
    self.selected = select;
    self.blueCircleImageView.hidden = !select;
    self.selectedIcon.hidden = !select;
}

- (UIImageView *)whiteRoundImageView{
    if (!_whiteRoundImageView) {
        _whiteRoundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteRound"]];
        _whiteRoundImageView.userInteractionEnabled = YES;
    }
    return _whiteRoundImageView;
}

- (UIImageView *)blueCircleImageView{
    if (!_blueCircleImageView) {
        _blueCircleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueCircle"]];
        _blueCircleImageView.userInteractionEnabled = YES;
    }
    return _blueCircleImageView;
}

- (UIImageView *)genderIcon{
    if (!_genderIcon) {
        _genderIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.boy ? @"boy_icon" : @"girl_icon"]];
        _genderIcon.userInteractionEnabled = YES;
    }
    return _genderIcon;
}

- (UIImageView *)selectedIcon{
    if (!_selectedIcon) {
        _selectedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_icon"]];
        _selectedIcon.userInteractionEnabled = YES;
    }
    return _selectedIcon;
}

- (UILabel *)genderEnglishLabel{
    if (!_genderEnglishLabel) {
        _genderEnglishLabel = [[UILabel alloc] init];
        _genderEnglishLabel.userInteractionEnabled = YES;
        _genderEnglishLabel.font = [UIFont systemFontOfSize:32];
        _genderEnglishLabel.textColor = [UIColor colorWithRed:0.325 green:0.368 blue:0.458 alpha:1];
        _genderEnglishLabel.textAlignment = NSTextAlignmentCenter;
        _genderEnglishLabel.text = self.boy ? @"BOY" : @"GIRL";
    }
    return _genderEnglishLabel;
}

- (UILabel *)genderChineseLabel{
    if (!_genderChineseLabel) {
        _genderChineseLabel = [[UILabel alloc] init];
        _genderChineseLabel.userInteractionEnabled = YES;
        _genderChineseLabel.font = [UIFont systemFontOfSize:16];
        _genderChineseLabel.textColor = [UIColor colorWithRed:0.325 green:0.368 blue:0.458 alpha:1];
        _genderChineseLabel.textAlignment = NSTextAlignmentCenter;
        _genderChineseLabel.text = self.boy ? NSLocalizedString(@"avatar_gender_male",nil) : NSLocalizedString(@"avatar_gender_female",nil);
    }
    return _genderChineseLabel;
}

@end
