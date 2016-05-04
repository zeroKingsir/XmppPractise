//
//  AddViewController.m
//  XmppProject
//
//  Created by G.Z on 16/2/17.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "AddViewController.h"
#import "QFXMPP.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)addBtn:(id)sender {
    
    [[QFXMPP share] addFriend:self.jidTxt.text];
}

@end
