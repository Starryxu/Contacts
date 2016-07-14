//
//  YGContactController.m
//  通讯录
//
//  Created by 许亚光 on 16/6/5.
//  Copyright © 2016年 许亚光. All rights reserved.
//

#import "YGContactController.h"
#import "YGContact.h"
#import "YGContactCell.h"
#import "YGAddContactController.h"
#import "YGEditContactController.h"
#import "NSString+Path.h"


@interface YGContactController ()<YGAddContactControllerDelegate,YGEditContactControllerDelegate>

@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation YGContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.navigationItem.title = [NSString stringWithFormat:@"%@的联系人列表",self.titleName];
    
    //设置左上角注销按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logoutBtnClick)];
    
    //添加空白尾部视图
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - 设置cell的分割线顶格显示
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layoutMargins = UIEdgeInsetsZero;
}


#pragma mark - 编辑的样式"插入和删除"
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) { // 如果是第0行cell开启编辑之后它应该是插入
        return UITableViewCellEditingStyleInsert;
    } else { // 只要不是第0行都是删除
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark - 设置删除按钮的文字
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


#pragma mark - 开启或关闭cell编辑模式
- (IBAction)editBtnClick:(UIBarButtonItem *)sender {
    // 动态开关  编辑模式
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

#pragma mark - 移动cell重新排序
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // 交换数组中的对象位置
    [self.contacts exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    // 保存最新数据
    [self saveContacts];
}

#pragma mark - 滑动删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 如果是删除
        
        // 先删除模型数组中要删除行的对应的模型数据
        [self.contacts removeObjectAtIndex:indexPath.row];
        
        // 再删除指定行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else {
        
        // 手动执行指定标识的segue 去添加新的联系人"把要做插入新数据的cell索引传去"
        [self performSegueWithIdentifier:@"addContact" sender:@(indexPath.row)];
        
    }
    
    // 保存最新数据
    [self saveContacts];
}


#pragma mark - 注销
- (void)logoutBtnClick
{
    //创建底部弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您真的要注销吗" preferredStyle:UIAlertControllerStyleActionSheet];
    //创建取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //创建注销按钮
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //pop去登录页面
        [self.navigationController popViewControllerAnimated:YES];
    }];
    //添加按钮到弹窗上
    [alert addAction:cancel];
    [alert addAction:logout];
    
    //展示弹窗
    [self presentViewController:alert animated:YES completion:nil];
}

//代理方法
-(void)addContactController:(YGAddContactController *)vc contact:(YGContact *)contact
{
    if (vc.view.tag == -1) { // 在最后直接添加"点击导航条右边的添加按钮时应该这样去做"
        
        // 添加模型
        [self.contacts addObject:contact];
        // 刷新表格
        [self.tableView reloadData];
        
    } else { // 是通过插入方式来添加联系人"在要插入cell的后面插入一个新的模型"
        
        [self.contacts insertObject:contact atIndex:(vc.view.tag + 1)];
        
        // 创建要插入cell的索引
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:vc.view.tag + 1 inSection:0];
        
        // 在指定索引指定一行cell
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    //数据归档
    [self saveContacts];
}


#pragma mark - 归档数据
- (void)saveContacts
{
    // 拼接归档文件路径
    NSString *filePath = [@"contact" appendDocumentPath];
    
    // 归档"归档数组时它会把数组中的每一个对象拿一个一个的去归"
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:filePath];
}



#pragma mark - 在跳转之前都会来调用此方法做跳转前的准备工作
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 获取目标控制器
    UIViewController *vc = segue.destinationViewController;
    
    // 如果目标控制器是添加联系人控制器
    if ([vc isKindOfClass:[YGAddContactController class]]) {
        
        // 获取目标控制器"添加联系人控制器"
        YGAddContactController *addVc = (YGAddContactController *)vc;
        
        // 给添加联系人控制器设置代理
        addVc.delegate = self;
        
        // 判断执行segue时传过来的是不是我想要的东西
        if ([sender isKindOfClass:[NSNumber class]]) {
            
            addVc.view.tag = [sender integerValue]; // 应该在要插入的cell后面去添加一个新的cell
        } else {
            addVc.view.tag = -1; // 点击导航条右上角的添加按钮去在cell最后面加一个新联系人
        }
        
    } else {//如果目标控制器是编辑联系人
        //获取目标控制器
        YGEditContactController *editVc = (YGEditContactController *)vc;
        //获取当前选择的cell的索引
        NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
        //给目标控制器属性赋值
        editVc.contact = self.contacts[selectedPath.row];
        
        //给遍历练习人控制器设置代理
        editVc.delegate = self;
    }
}



#pragma mark - 代理方法
-(void)editContactViewController:(YGEditContactController *)editVc contact:(YGContact *)contact
{
    //刷新数据
    [self.tableView reloadData];
}




#pragma mark - 数据源方法
//一组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}
//返回每一行应该显示的数据信息
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    YGContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //设置数据
    cell.contact = self.contacts[indexPath.row];
    //返回cell
    return cell;
}


#pragma mark - 懒加载
-(NSMutableArray *)contacts
{
    if (_contacts == nil)//如果联系人数组属性为空
    {
        //首先进行数据解档
        //获取解档文件路径
        NSString *filePath = [@"contact" appendDocumentPath];
        //解档,读取数据
        self.contacts = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        //如果解档没有获取到内容
        if (_contacts == nil) {
            //实例化数组属性
            _contacts = [[NSMutableArray alloc] init];
        }
    }
    return _contacts;
}
@end
