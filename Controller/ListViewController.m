//
//  ListViewController.m
//  XmppProject
//
//  Created by G.Z on 16/2/16.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "ListViewController.h"
#import "QFXMPP.h"
#import "ChatViewController.h"
#import "AddViewController.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //声明数据源数组
    NSArray *_array;
    
    //声明聊天控制器变量
    ChatViewController *_chatController;
    
    //声明添加好友成员变量
    AddViewController *_addController;
}

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //添加导航条右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClick:)];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.tv.dataSource = self;
    
    self.tv.delegate = self;
    
    //监听必须写在 getAllFriends 之前
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friends:) name:@"Fri" object:nil];
    
    //
    [[QFXMPP share] getAllFriends];
}


- (void)rightBtnClick:(UIBarButtonItem *)btn
{
    //侧滑到添加好友页面
    _addController = [[AddViewController alloc] init];
    
    [self.navigationController pushViewController:_addController animated:YES];
}

- (void)friends:(NSNotification *)n
{
    //通过:n.object 拿到数组中的协议
    NSMutableArray *mutArr = n.object;
    
    _array = [[NSArray alloc] initWithArray:mutArr];
    
    [self.tv reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"str";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _chatController = [[ChatViewController alloc] init];
    
    _chatController.jid = [_array objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:_chatController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
