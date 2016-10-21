//
//  LLSportMainViewController.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportMainViewController.h"
#import "LLSportingViewController.h"
#import "LLSportTracking.h"

@interface LLSportMainViewController ()

@end

@implementation LLSportMainViewController


- (IBAction)startSport:(UIButton *)sender {
    
    // 根据tag区分运动类型
    LLSportType type = sender.tag;
    
    LLSportingViewController *vc = [[LLSportingViewController alloc] init];
    vc.type = type;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
