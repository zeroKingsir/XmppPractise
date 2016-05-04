//
//  QFXMPP.m
//  XmppProject
//
//  Created by G.Z on 16/2/16.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "QFXMPP.h"

@implementation QFXMPP

+ (QFXMPP *)share
{
    static QFXMPP *xmpp = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        xmpp = [[QFXMPP alloc] init];
    });
    
    return xmpp;

}

//重写构造方法
- (id)init
{
    self = [super init];
    
    if (self) {
        
        //创建xmpp流
        _stream = [[XMPPStream alloc]init];
        
        //设置下划线stream准备链接服务器的端口
        [_stream setHostName:HOST];
        
        [_stream setHostPort:PORT];
        
        //设置代理回调
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];//主线程
        
        //创建添加好友的类的对象
        _storage = [[XMPPRosterCoreDataStorage alloc] init];
        
        _roster = [[XMPPRoster alloc] init];
        
        [_roster addDelegate:self delegateQueue:dispatch_get_main_queue()];//主线程
        
        //绑定就具有了联合性
        [_roster activate:_stream];

    }
    return self;
}


//登录
- (void)login:(NSString *)jid andPwd:(NSString *)pwd
{
    //若xmpp流处于连接状态的时候 断开连接
    if ([_stream isConnected]) {
        
        [_stream disconnect];
    }
    
    //设置属性为登录的状态
    self.isLogin = YES;
    
    _tempString = pwd;
    
    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
    
    //设置登录的用户名
    [_stream setMyJID:xmppJID];
    
    //连接服务器
    [_stream connectWithTimeout:-1 error:nil];
}

//注册
- (void)reg:(NSString *)jid andPwd:(NSString *)pwd
{
    //若xmpp流处于连接状态的时候 断开连接
    if ([_stream isConnected]) {
        
        [_stream disconnect];
    }
    //设置属性注册时候 登录关闭状态
    self.isLogin = NO;
    
    //将密码保存到临时变量中
    _tempString = pwd;
    
    //将字符串封装成XMPPJID类型
    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
    
    //设置_stream的用户名
    [_stream setMyJID:xmppJID];
    
    //-1代表永远不超时
    [_stream connectWithTimeout:-1 error:nil];
}

//当连接服务器成功时候 调用
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    
    if (self.isLogin) {
        
        //登录过程
        //校验一下
        [_stream authenticateWithPassword:_tempString error:nil];
        
    }else{
        
        //注册过程(注册密码)
        [_stream registerWithPassword:_tempString error:nil];
    }
    
}

//登陆成功的时候调用
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"登录成功");
    
    [self getOnLine];//控制登陆上线 在服务器端的点亮状态
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
}

//注册成功的时候调用
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    
}

- (void)getAllFriends
{
    //获得好友列表的XMPP节点
    //XMPP中的节点: XMPPPresence,XMPPIQ,XMPPMessage
    NSString *getAllFriendsString=@"<iq type=\"get\"><query xmlns=\"jabber:iq:roster\"/></iq>";
    
    DDXMLElement *element = [[DDXMLElement alloc] initWithXMLString:getAllFriendsString error:nil];
    
    //将获得好友列表的节点发送到服务器
    [_stream sendElement:element];
}

//接收到好友列表时候调用
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    //存放所有好友列表名称
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    NSLog(@"%@",iq);
    
    DDXMLElement *queryElement = [iq elementForName:@"query"];//elementForName注意不带s
    
    NSArray *elementArray = [queryElement elementsForName:@"item"];//这里用elements
    
    for (int i = 0;  i < elementArray.count; i++) {
        
        DDXMLElement *itemElement = [elementArray objectAtIndex:i];
        
        NSString *jidName = [itemElement attributeForName:@"jid"].stringValue;
        
        NSLog(@"jidName:%@",jidName);
        
        //将好友名称添加到数组
        [mutArray addObject:jidName];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Fri" object:mutArray];
    
    return YES;
}

//接收到好友消息时候调用
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    //NSLog(@"%@",message);
    
    DDXMLElement *bodyElement = [message elementForName:@"body"];
    
    NSLog(@"%@",bodyElement.stringValue);
    
    //通过通知中性 讲接收到的好友消息 传递到聊天页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MSG" object:bodyElement.stringValue];
}



//接收到好友状态 时候调用
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
    NSLog(@"%@",presence);
}



//发送消息
- (void)sendMsg:(NSString *)msg toJID:(NSString *)jid
{
    DDXMLElement *bodyElement = [DDXMLElement elementWithName:@"body"];
    
    [bodyElement setStringValue:msg];
    
    DDXMLElement *messageElement = [DDXMLElement elementWithName:@"message"];
    
    [messageElement addAttributeWithName:@"type" stringValue:@"chat"];
    
    [messageElement addAttributeWithName:@"to" stringValue:jid];
    
     [messageElement addAttributeWithName:@"msgType" stringValue:@"0"];
     //
     [messageElement addChild:bodyElement];
     
     
     //发送一包这样的消息
     [_stream sendElement:messageElement];

}

//通知服务器上线
- (void)getOnLine
{
    XMPPPresence *pre = [XMPPPresence presence];
    
    [_stream sendElement:pre];
}

//添加好友
- (void)addFriend:(NSString *)jid
{
    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
    
    NSString *nickName = [jid componentsSeparatedByString:@"@"].firstObject;
    
    //Nickname -> 注意是这个
    [_roster addUser:xmppJID withNickname:nickName];
}

@end
