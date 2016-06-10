//
//  YGContact.m
//  通讯录
//
//  Created by 许亚光 on 16/6/4.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import "YGContact.h"

@implementation YGContact

//实现编码方法
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    
}

//实现解档方法

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
    }
    return self;
}

@end







