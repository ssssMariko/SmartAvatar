//
//  AvatarEntityInfo.m
//  AvatarPalneDemo
//
//  Created by chavezchen on 2022/8/4.
//

#import "AvatarEntityInfo.h"

@implementation AvatarEntityInfo


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"subTabs"]) {
        NSMutableArray *subTabs = [NSMutableArray array];
        for (NSDictionary *info in value) {
            AvatarSubTabInfo *subModel = [[AvatarSubTabInfo alloc] init];
            [subModel setValuesForKeysWithDictionary:info];
            [subTabs addObject:subModel];
        }
        self.subTabInfos = subTabs;
    } else if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}

@end
