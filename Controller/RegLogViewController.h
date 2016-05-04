//
//  RegLogViewController.h
//  XmppProject
//
//  Created by G.Z on 16/2/16.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegLogViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *jidTxt;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxt;
- (IBAction)loginBtn:(id)sender;
- (IBAction)regBtn:(id)sender;

@end
