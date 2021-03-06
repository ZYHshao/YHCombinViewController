//
//  ViewController.m
//  YHCombinViewController
//
//  Created by jaki on 2017/7/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import "ViewController.h"
#import "YHCombinViewController.h"
#import "MyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btn:(id)sender {
    NSMutableArray * array = [NSMutableArray array];
    for (int  i =0; i<10; i++) {
        
        if (i%2!=0) {
            UIViewController *  con = [[UIViewController alloc]init];
            con.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
            con.title = [NSString stringWithFormat:@"控制器%d",i];
            [array addObject:con];
        }else{
            MyViewController *  con = [[MyViewController alloc]init];
            con.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
            con.title = [NSString stringWithFormat:@"控制器%d",i];
            con.index = i;
            [array addObject:con];
        }
       
    }
    YHCombinViewController * combin = [[YHCombinViewController alloc]initWithControllers:array];
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    header.backgroundColor = [UIColor cyanColor];
    combin.headerView = header;
    combin.menuBar.titleTextColor = [UIColor blueColor];
    combin.menuBar.titleTextHighlightColor = [UIColor cyanColor];
    [self presentViewController:combin animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
