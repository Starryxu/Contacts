//
//  YGContact.h
//  通讯录
//
//  Created by 许亚光 on 16/6/4.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import <Foundation/Foundation.h>
                                //遵守编码协议
@interface YGContact : NSObject<NSCoding>

//姓名
@property (nonatomic, copy) NSString *name;

//电话
@property (nonatomic, copy) NSString *phoneNumber;


@end
