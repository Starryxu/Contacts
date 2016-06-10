//
//  YGEditContactController.h
//  通讯录
//
//  Created by 许亚光 on 16/6/7.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YGContact, YGEditContactController;
@protocol  YGEditContactControllerDelegate<NSObject>

-(void)editContactViewController:(YGEditContactController *)editVc contact:(YGContact *)contact;

@end

@interface YGEditContactController : UIViewController

@property (nonatomic, strong)  YGContact *contact;
@property (nonatomic, weak) id<YGEditContactControllerDelegate> delegate;

@end
