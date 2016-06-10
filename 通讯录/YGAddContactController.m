//
//  YGAddContactController.m
//  通讯录
//
//  Created by 许亚光 on 16/6/5.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import "YGAddContactController.h"
#import "YGContact.h"

@interface YGAddContactController ()
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//添加按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;

@end

@implementation YGAddContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加文本框内容改变监听事件
    [self.nameTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    
    //让电话号码文本框成为第一响应者
    [self.phoneTextField becomeFirstResponder];
    
    
}


//文本框内容改变时需要做的事情
- (void)textFieldChange
{
    //设置添加按钮的状态
    self.addBtn.enabled = self.nameTextField.text.length > 0 && self.phoneTextField.text.length > 0;
}



//添加联系人按钮点击事件
- (IBAction)addBtnClick{
    
    //结束编辑退出键盘
    [self.view endEditing:YES];
    
    //判断代理有没有事项协议方法,如果实现了,让代理做事
    if ([self.delegate respondsToSelector:@selector(addContactController:contact:)]) {
        
        //获取模型对象
        YGContact *contact = [[YGContact alloc] init];
        
        //给模型属性赋值
        contact.name = self.nameTextField.text;
        contact.phoneNumber = self.phoneTextField.text;
        
        //将模型对象通过代理方法传递给代理控制器
        [self.delegate addContactController:self contact:contact];
    }
    
    //将控制器以动画的形式出栈
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 点击添加之后回到上一控制器
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
