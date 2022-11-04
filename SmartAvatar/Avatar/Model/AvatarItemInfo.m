//
//  AvatarItemInfo.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import "AvatarItemInfo.h"

@implementation AvatarItemInfo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"labels"]) {
        self.labels = value;
        NSMutableDictionary *valueDict = [NSMutableDictionary dictionary];
        for (NSString *k in [(NSDictionary *)value allKeys]) {
            [valueDict setValue:@(0) forKey:k];
        }
        self.valueDcit = valueDict;
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.avatarData.isSelected = isSelected;
}

//- (void)setValueDcit:(NSMutableDictionary *)valueDcit
//{
//    _valueDcit = valueDcit;
//    self.avatarData.value = valueDcit;
//}

- (void)updateValueDict:(id)value key:(id)key
{
    [_valueDcit setObject:value forKey:key];
    self.avatarData.value = _valueDcit;
}

@end
