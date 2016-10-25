//
//  LLSportMapModeViewController.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/25.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportMapModeViewController.h"

@interface LLSportMapModeViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *mapButtons;

@end

@implementation LLSportMapModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置按钮的初始选中位置
    for (UIButton *btn  in _mapButtons) {
        // 判断当前按钮的tag值 是否和地图类型一样
        btn.selected = (btn.tag == _currentType);
    }
    
}

- (IBAction)selectMapButton:(UIButton *)sender {
    
    if (sender.tag == _currentType) {
        return;
    }
    
    _currentType = sender.tag;
    // 设置地图类型
    if (_didSelectedMapMode != nil) {
        _didSelectedMapMode(_currentType);
    }
    // 设置按钮的选中状态
    for (UIButton *button in _mapButtons) {
        button.selected = (button == sender);
    }
}


@end
