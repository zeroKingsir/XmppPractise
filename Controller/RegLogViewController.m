//
//  RegLogViewController.m
//  XmppProject
//
//  Created by G.Z on 16/2/16.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "RegLogViewController.h"
#import "QFXMPP.h"
#import "ListViewController.h"

@interface RegLogViewController ()
{
    ListViewController *_listController;
    
    UINavigationController *_navController;
}

@end

@implementation RegLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toListViewController:) name:@"LoginSuccess" object:nil];
}


//跳转到好友列表界面
- (void)toListViewController:(NSNotification *)n
{
    _listController = [[ListViewController alloc] init];
    
    _navController = [[UINavigationController alloc]initWithRootViewController:_listController];
    
    [self presentViewController:_navController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//登录
- (IBAction)loginBtn:(id)sender {
    
    [[QFXMPP share] login:self.jidTxt.text andPwd:self.pwdTxt.text];
    
}

//注册
- (IBAction)regBtn:(id)sender {
    
    //调用业务类中的注册方法
    [[QFXMPP share] reg:self.jidTxt.text andPwd:self.pwdTxt.text];
}
@end
