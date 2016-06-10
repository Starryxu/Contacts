//
//  YGAddContactController.h
//  通讯录
//
//  Created by 许亚光 on 16/6/5.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import <UIKit/UIKit.h>

//生命协议
@class YGContact, YGAddContactController;
@protocol  YGAddContactControllerDelegate <NSObject>
//可选协议
@optional
//协议方法
- (void)addContactController:(YGAddContactController *)vc contact:(YGContact *)contact;

@end

@interface YGAddContactController : UIViewController


//代理属性
@property (nonatomic, weak) id<YGAddContactControllerDelegate> delegate;

@end
