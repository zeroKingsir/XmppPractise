
//
//  ChatViewController.m
//  XmppProject
//
//  Created by G.Z on 16/2/16.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
{
    //存数聊天记录
    NSMutableString *_muString;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _muString = [[NSMutableString alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgNotification:) name:@"MSG" object:nil];
}


- (void)msgNotification:(NSNotification *)n
{
    NSString *reciveString = n.object;
    
    [_muString appendFormat:@"他说:%@\n",reciveString];
    
    self.msgTxt.text = _muString;
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

- (IBAction)sendBtn:(id)sender {
    
    [[QFXMPP share] sendMsg:self.sendTxt.text  toJID:self.jid];
    
    [_muString appendFormat:@"我说:%@\n",self.sendTxt.text];
    
    self.msgTxt.text = _muString;

}
@end
