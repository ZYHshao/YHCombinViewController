//
//  ViewController.m
//  YHCombinViewController
//
//  Created by jaki on 2017/7/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import "ViewController.h"
#import "YHCombinViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btn:(id)sender {
    UIViewController * con1 = [[UIViewController alloc]init];
    con1.view.backgroundColor = [UIColor redColor];
    UIViewController * con2 = [[UIViewController alloc]init];
    con2.view.backgroundColor = [UIColor blueColor];
    YHCombinViewController * combin = [[YHCombinViewController alloc]initWithControllers:@[con1,con2]];
    [self presentViewController:combin animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
