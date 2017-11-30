//
//  YHCombinViewController.h
//  YHCombinViewController
//
//  Created by jaki on 2017/7/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHMenuBar.h"
@interface YHCombinViewController : UIViewController


-(instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers;

@property(nonatomic,strong)YHMenuBar * menuBar;

@property(nonatomic,strong,readonly)NSArray<UIViewController*> *controllerArrays;

@property(nonatomic,assign)CGFloat menuHeight;//minum is 30 maxmum is 70

-(void)selectControllerIndex:(int)index;

@property(nonatomic,strong)UIView * headerView;

@end
