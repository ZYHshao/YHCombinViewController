//
//  YHCombinViewController.h
//  YHCombinViewController
//
//  Created by jaki on 2017/7/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCombinViewController : UIViewController


-(instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers;


@property(nonatomic,strong,readonly)NSArray<UIViewController*> *controllerArrays;

@end
