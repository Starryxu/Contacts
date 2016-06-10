//
//  YGEditContactController.m
//  通讯录
//
//  Created by 许亚光 on 16/6/7.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import "YGEditContactController.h"
#import "YGContact.h"

@interface YGEditContactController ()
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextFied;
//电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//添加
@property (weak, nonatomic) IBOutlet UIButton *addBtn;



@end

@implementation YGEditContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置数据
    self.nameTextFied.text = self.contact.name;
    self.phoneTextField.text = self.contact.phoneNumber;
    
    //设置默认文本框不准编辑
    self.nameTextFied.enabled = NO;
    self.phoneTextField.enabled = NO;
    
    
    //设置默认情况下添加按钮隐藏
    self.addBtn.hidden = YES;
    
}

//点击编辑按钮设置相应数据
- (IBAction)editOrCancelBtn:(UIBarButtonItem *)sender {
    
    if (self.addBtn.hidden == YES)
    {
        sender.title = @"取消";
        
        self.nameTextFied.enabled = YES;
        self.phoneTextField.enabled = YES;
        
        self.addBtn.hidden = NO;
        self.addBtn.enabled = NO;
        
        [self.phoneTextField becomeFirstResponder];
    }else{
        
        sender.title = @"编辑";
        
        self.nameTextFied.enabled = YES;
        self.phoneTextField.enabled= NO;
        
        [self.view endEditing:YES];
        
        self.addBtn.hidden = YES;
        
        //将数据设置回原来的数据
        self.nameTextFied.text = self.contact.name;
        self.phoneTextField.text = self.contact.phoneNumber;
    
    }
}

//点击添加按钮
- (IBAction)addBtnCilck {
    
    //如果代理实现了方法
    if ([self.delegate respondsToSelector:@selector(editContactViewController:contact:)]) {
        
        //直接给模型赋值
        self.contact.name = self.nameTextFied.text;
        self.contact.phoneNumber = self.phoneTextField.text;
        
        //代理传值
        [self.delegate editContactViewController:self contact:self.contact];
        
    }
    //pop回上一个控制器
    [self.navigationController popViewControllerAnimated:YES];
    
}

//编辑取消按钮点击事件
- (IBAction)editOrCancelTextFieldChanged:(UITextField *)sender {
    
    //按钮状态
    self.addBtn.enabled = self.nameTextFied.text.length > 0 && self.phoneTextField.text.length > 0;
}

@end













