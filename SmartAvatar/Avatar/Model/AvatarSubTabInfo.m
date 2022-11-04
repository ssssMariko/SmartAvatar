//
//  AvatarSubTabInfo.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import "AvatarSubTabInfo.h"

@implementation AvatarSubTabInfo

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"items"]) {
        NSMutableArray *itemArr = [NSMutableArray array];
        for (NSDictionary *itemDic in value) {
            AvatarItemInfo *item = [[AvatarItemInfo alloc] init];
            [item setValuesForKeysWithDictionary:itemDic];
            [itemArr addObject:item];
        }
        self.items = itemArr;
    }
}

@end
