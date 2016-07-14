//
//  YGLoginController.m
//  通讯录
//
//  Created by 许亚光 on 16/6/4.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import "YGLoginController.h"
#import "MBProgressHUD+Ex.h"
#import "YGContactController.h"
#import "YGEditContactController.h"

#define KAccountText @"accountText"
#define KPasswordText @"passwordText"
#define KRemeberBtn @"remeberPasBtn"
#define KAutoLoginBtn @"autoLoginBtn"

@interface YGLoginController ()
//账号
@property (weak, nonatomic) IBOutlet UITextField *accountLbl;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordLbl;
//记住密码
@property (weak, nonatomic) IBOutlet UIButton *remberPasswordBtn;
//自动登录
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;
//登录
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation YGLoginController

#pragma mark - 读取偏好设置
- (void)viewDidLoad {
    [super viewDidLoad];
    //给账号和密码文本框添加内容改变监听事件
    [self.accountLbl addTarget:self action:@selector(textEidtingChing) forControlEvents:UIControlEventEditingChanged];
    [self.passwordLbl addTarget:self action:@selector(textEidtingChing) forControlEvents:UIControlEventEditingChanged];
    
    // 获取偏好设置
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    // 设置账号
    self.accountLbl.text = [ud valueForKey:KAccountText];
    // 取出记住密码开头的状态
    self.remberPasswordBtn.selected = [ud boolForKey:KRemeberBtn];
    // 取出自动登录开关的状态
    self.autoLoginBtn.selected = [ud boolForKey:KAutoLoginBtn];
    
    if (self.remberPasswordBtn.isSelected) { // 如果是记住密码就设置密码文本框中的文字
        self.passwordLbl.text = [ud valueForKey:KPasswordText];
    }
    
    if (self.autoLoginBtn.isSelected) { // 如果自动登录开关是打开的就自动登录
        // 直接调用登录按钮的点击方法
        [self loginBtnClick];
        
    }else{
    //程序启动时将账号文本框设置问第一响应者
    [self.accountLbl becomeFirstResponder];
    }
    //如果两个文本框中都有文字那么就打开登录按钮
    self.loginBtn.enabled = self.accountLbl.text.length > 0 && self.passwordLbl.text.length > 0;
}

#pragma mark -  文本框内容改变时所做的事情
- (void)textEidtingChing {
    //当两个文本框中都有内容时设置登录按钮为可点击状态
    self.loginBtn.enabled = self.accountLbl.text.length > 0 && self.passwordLbl.text.length > 0;
}

#pragma mark -  记住密码和自动登录状态的设置
- (IBAction)selectStateBtn:(UIButton *)sender {
    
    if (sender == self.autoLoginBtn ) {//如果点击的是自动登录选项
        if (self.autoLoginBtn.isSelected == YES) {//当自动登录选项已经被选择的时候
            self.autoLoginBtn.selected = NO;//将选项取消
        }else{//如果没有被选择
            self.autoLoginBtn.selected = YES;//将自动登录选项选择打开
            self.remberPasswordBtn.selected = YES;//同事也需要记住密码选项打开
        }
    }else{//如果点击的是记住密码选项
        if(self.remberPasswordBtn.isSelected == YES){//当选项已经被选择的时候
            self.remberPasswordBtn.selected = NO;//取消记住密码的选项
            self.autoLoginBtn.selected = NO;//此时也要取消自动登录的选项,因为密码都记不住了怎么自动登录
        }else{//当记住密码选项没有被选择的时候
            self.remberPasswordBtn.selected = YES;//就打开记住密码选项
        }
    }
}

#pragma mark - 登录按钮点击事件
- (IBAction)loginBtnClick {
    
    //结束编辑状态退出键盘
    [self.view endEditing:YES];
    
    //添加弹窗
    [MBProgressHUD showMessage:@"拼命加载中"];
    
    //模拟网络延迟,时间 1 秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //将登录弹窗隐藏
        [MBProgressHUD hideHUD];
        
        //判断密码是否正确,如果正确执行内部代码
        if ([self.accountLbl.text isEqualToString:@"admin"] && [self.passwordLbl.text isEqualToString:@"123"]) {
            
            //存储偏好设置
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults]; //获取偏好设置
            
            // MARK: - 登录成功后保存数据
            
            [ud setObject:self.accountLbl.text forKey:KAccountText];//保存账号
            [ud setObject:self.passwordLbl.text forKey:KPasswordText];//保存密码
            [ud setBool:self.remberPasswordBtn.isSelected forKey:KRemeberBtn];//保存记住密码按钮状态呢
            [ud setBool:self.autoLoginBtn.isSelected forKey:KAutoLoginBtn];//保存自动登录按钮状态
            
            //立即写入
            [ud synchronize];
            
            //通过标识符加载控制器进入下一个界面
            [self performSegueWithIdentifier:@"login2Contacts" sender:nil];
            
        }else{//当账号密码有错误时候
            
            [MBProgressHUD showError:@"密码或者账号错误!"];//添加弹窗提示用户账号或者密码错误,此时不要做详细的判断提示到底是什么错了,要不能暴力破解账号密码了
        }
    });
    
}

/**
 *  属性传值
 */

#pragma mark - sugue创建和设置好它的源控制器及目标控制器之后,来做跳转前的准备,会自动调用此方法
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //获取目标控制器的对象
    YGContactController *vc = segue.destinationViewController;
    //吧账号的文本值传给目标控制器的属性
    vc.titleName = self.accountLbl.text;
   
}


@end
