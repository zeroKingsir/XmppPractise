//
//  QFXMPP.h
//  XmppProject
//
//  Created by G.Z on 16/2/16.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
//代表自己(主机的IP地址,准备链接服务器的IP地址,相比较直接写自己主机的IP要效率更高)
#define HOST @"127.0.0.1"

//服务器端口(openfire的)
#define PORT 5222
//导入XMPPFramework框架头文件
#import "XMPPFramework.h"

@interface QFXMPP : NSObject<XMPPStreamDelegate>//遵守协议
{
    //xmpp流 作用:连接服务器 登录 注册 获得好友列表 发消息...
    XMPPStream *_stream;
    
    //声明临时的变量用于存放密码
    NSString *_tempString;
    
    
    //添加好友(和一块儿作用)
    XMPPRoster *_roster;
    XMPPRosterCoreDataStorage *_storage;
    
}

//通过单例创建QFXMPP的对象 作用方便调用每个试图控制器
+ (QFXMPP *)share;

//记录是否点击的为登录按钮
@property (assign,nonatomic)BOOL isLogin;

- (void)login:(NSString *)jid andPwd:(NSString *)pwd;

- (void)reg:(NSString *)jid andPwd:(NSString *)pwd;

//获得好友列表
- (void)getAllFriends;

//发送消息
- (void)sendMsg:(NSString *)msg toJID:(NSString *)jid;

//添加好友
- (void)addFriend:(NSString *)jid;

@end
