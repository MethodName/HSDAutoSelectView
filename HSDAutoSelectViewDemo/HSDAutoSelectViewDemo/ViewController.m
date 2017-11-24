//
//  ViewController.m
//  HSDAutoSelectViewDemo
//
//  Created by 唐明明 on 2017/11/24.
//  Copyright © 2017年 Methodname. All rights reserved.
//

#import "ViewController.h"
#import "HSDAutoSelectView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectBTClick:(UIButton *)sender {
    
    __block UIButton * weakButton = sender;
    HSDAutoSelectView *selectView = [HSDAutoSelectView instanceView];
    selectView.selectIndex = sender.tag;
    
    
    selectView.dataArray = @[@"河南省",@"江苏省",@"湖北省",@"山东省",@"河南省",@"江苏省",@"湖北省",@"山东省",@"河南省",@"江苏省",@"湖北省",@"山东省",@"河南省",@"江苏省",@"湖北省",@"山东省",@"河南省",@"江苏省",@"湖北省",@"山东省"];
    [selectView showWithView:sender callBack:^(NSInteger selectedIndex, NSString *selectTitle) {
        [weakButton setTitle:selectTitle forState:0];
        weakButton.tag = selectedIndex;
    }];
    
}

@end
