//
//  AvatarPanelitemCollectionView.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/8.
//

#import "AvatarPanelitemCollectionCell.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#define RGBAHex(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define SLIDER_X_BOUND 30
#define SLIDER_Y_BOUND 30

@implementation CustomSlider
static CGRect lastBounds;
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value;
{

    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    //记录下最终的frame
    lastBounds = result;
    return result;
}
// 检查点击事件点击范围是否能够交给self处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
// 调用父类方法,找到能够处理event的view
    UIView* result = [super hitTest:point withEvent:event];
    if (result != self) {
        /*如果这个view不是self,我们给slider扩充一下响应范围,
          这里的扩充范围数据就可以自己设置了
        */
        if ((point.y >= -15) &&
            (point.y < (lastBounds.size.height + SLIDER_Y_BOUND)) &&
            (point.x >= 0 && point.x < CGRectGetWidth(self.bounds))) {
            //如果在扩充的范围类,就将event的处理权交给self
            result = self;
        }
    }
    // 否则,返回能够处理的view
    return result;
}
// 检查是点击事件的点是否在slider范围内
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //调用父类判断
    BOOL result = [super pointInside:point withEvent:event];
    
    if (!result) {
        // 同理,如果不在slider范围类,扩充响应范围
        if ((point.x >= (lastBounds.origin.x - SLIDER_X_BOUND)) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + SLIDER_X_BOUND))
            && (point.y >= -SLIDER_Y_BOUND) && (point.y < (lastBounds.size.height + SLIDER_Y_BOUND))) {
            // 在扩充范围内,返回yes
            result = YES;
        }
    }
    return result;
}

@end


@interface AvatarPanelitemCollectionCell ()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@end

@implementation AvatarPanelitemCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
//    self.contentView.backgroundColor = [UIColor redColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageV = imageView;
    imageView.layer.cornerRadius = 12.0;
    imageView.clipsToBounds = YES;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self).offset(1);
        make.top.left.mas_equalTo(1.5);
        make.right.bottom.mas_equalTo(-1.5);
    }];
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0.25);
    gradientLayer.endPoint   = CGPointMake(1, 0.75);
    gradientLayer.colors = @[(id)RGBAHex(0x0035EE, 1.0).CGColor,(id)RGBAHex(0x1DDCF6, 1.0).CGColor];
    gradientLayer.cornerRadius = 14;
    [self.contentView.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
    gradientLayer.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.frame = self.contentView.bounds;
    [CATransaction commit];
}

- (void)setInfo:(AvatarItemInfo *)info
{
    _info = info;
    
    if ([info.icon hasPrefix:@"http"]) {
        self.imageV.backgroundColor = [UIColor clearColor];
        [self.imageV setImageWithURL:[NSURL URLWithString:info.icon]];
    } else {
        self.imageV.image = nil;
        NSString *hexColor = [info.icon substringFromIndex:3];
        self.imageV.backgroundColor = [self.class getColor:hexColor];
    }
    
    [self updateSelectorState];
}

+ (UIColor *)getColor:(NSString *)hexColor {
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

- (void)updateSelectorState
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.hidden = !self.info.isSelected;
    [CATransaction commit];
}


@end



@interface AvatarPanelitemTableCell ()

@property (nonatomic, weak) UILabel *titleLb;
@property (nonatomic, weak) CustomSlider *slider;

@end

@implementation AvatarPanelitemTableCell


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGBAHex(0x535E75, 1.0);
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    self.titleLb = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(70);
    }];
    
    CustomSlider *slider = [[CustomSlider alloc] init];
//    slider.minimumTrackTintColor = RGBAHex(0xF0F7FF, 1.0);
    slider.maximumTrackTintColor = RGBAHex(0xF0F7FF, 1.0);
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider setThumbImage:[UIImage imageNamed:@"Rectangle"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    slider.value = 0;
    [self.contentView addSubview:slider];
    self.slider = slider;
    
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(8);
    }];
}

- (void)setSourceDict:(NSDictionary *)sourceDict
{
    _sourceDict = sourceDict;
    self.titleLb.text = sourceDict.allValues.firstObject;
}

- (void)setValueDict:(NSDictionary *)valueDict
{
    _valueDict = valueDict;
    self.slider.value = [valueDict.allValues.firstObject floatValue];
}

- (void)sliderValueChange:(UISlider *)slider
{
    if (_callback) {
        _callback(_sourceDict.allKeys.firstObject,slider.value);
    }
}

@end

