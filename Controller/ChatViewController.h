//
//  ChatViewController.h
//  XmppProject
//
//  Created by G.Z on 16/2/16.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QFXMPP.h"

@interface ChatViewController : UIViewController


//接受正向传值
@property (copy,nonatomic)NSString *jid;

@property (weak, nonatomic) IBOutlet UITextView *msgTxt;
@property (weak, nonatomic) IBOutlet UITextField *sendTxt;
- (IBAction)sendBtn:(id)sender;

@end
