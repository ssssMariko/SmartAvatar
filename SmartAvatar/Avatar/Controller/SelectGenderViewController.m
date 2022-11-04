//
//  SelectGenderViewController.m
//  BeautyDemo
//
//  Created by tao yue on 2022/8/9.
//

#import "SelectGenderViewController.h"
#import <Masonry/Masonry.h>
#import "../View/GenderItemView.h"
#import "TakePhotoViewController.h"

// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

@interface SelectGenderViewController ()

//背景图
@property(nonatomic,strong) UIImageView *bgImageView;
@property(nonatomic,strong) UIButton *backBtn; // 屏幕上方最左边返回按钮
@property(nonatomic,strong) UILabel *titleLabel; //标题textview
@property(nonatomic,strong) UILabel *selectGenderLabel; //请选择性别
@property(nonatomic,strong) GenderItemView *boyItemView; //男生
@property(nonatomic,strong) GenderItemView *girlItemView; //女生
@property BOOL *isGirl; //女生

@end

@implementation SelectGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo((float)249/(float)375*ScreenHeight);
    }];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(25);
        make.top.mas_equalTo(self.view).offset(61);
        make.height.width.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.boyItemView];
    [self.boyItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.left.mas_equalTo(self.view).offset((float)(ScreenWidth - 92 * 2)/3);
        make.height.mas_equalTo(122);
        make.width.mas_equalTo(92);
    }];
    
    [self.view addSubview:self.girlItemView];
    [self.girlItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.right.mas_equalTo(self.view).offset(-(float)(ScreenWidth - 92 * 2)/3);
        make.height.mas_equalTo(122);
        make.width.mas_equalTo(92);
    }];
    
    [self.view addSubview:self.selectGenderLabel];
    [self.selectGenderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.boyItemView.mas_top).offset(-42);
        make.height.mas_equalTo(34);
    }];
}

- (void)onBack:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectFemale{
    TakePhotoViewController *viewControl = [[TakePhotoViewController alloc] init];
    viewControl.isMale = NO;
    viewControl.modalPresentationStyle = UIModalPresentationFullScreen;
    [self dismissViewControllerAnimated:NO completion:nil];
    [[TakePhotoViewController getCurrentVC] presentViewController:viewControl animated:YES completion:nil];
}

- (void)selectMale {
    TakePhotoViewController *viewControl = [[TakePhotoViewController alloc] init];
    viewControl.isMale = YES;
    viewControl.modalPresentationStyle = UIModalPresentationFullScreen;
    [self dismissViewControllerAnimated:NO completion:nil];
    [[TakePhotoViewController getCurrentVC] presentViewController:viewControl animated:YES completion:nil];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:22];
        _titleLabel.textColor = [UIColor colorWithRed:0.325 green:0.368 blue:0.458 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"生成";
    }
    return _titleLabel;
}

- (UILabel *)selectGenderLabel{
    if (!_selectGenderLabel) {
        _selectGenderLabel = [[UILabel alloc] init];
        _selectGenderLabel.font = [UIFont systemFontOfSize:20];
        _selectGenderLabel.textColor = [UIColor colorWithRed:0.325 green:0.368 blue:0.458 alpha:1];
        _selectGenderLabel.textAlignment = NSTextAlignmentCenter;
        _selectGenderLabel.text = NSLocalizedString(@"avatar_gender_select_tip",nil);
    }
    return _selectGenderLabel;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectgender_bg"]];
    }
    return _bgImageView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (GenderItemView *)boyItemView {
    if (!_boyItemView) {
        _boyItemView = [[GenderItemView alloc] initWithGender:YES selected:NO];
        [_boyItemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectMale)]];
    }
    return _boyItemView;
}

- (GenderItemView *)girlItemView {
    if (!_girlItemView) {
        _girlItemView = [[GenderItemView alloc] initWithGender:NO selected:NO];
        [_girlItemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFemale)]];
    }
    return _girlItemView;
}

@end
