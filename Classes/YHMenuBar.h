//
//  YHMenuBar.h
//  YHCombinViewController
//
//  Created by jaki on 2017/7/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YHMenuBarDelegate <NSObject>

-(void)selectedItemWithIndex:(int)index;

@end

@interface YHMenuBar : UIView

-(instancetype)initWithTitles:(NSArray<NSString *> *)titles;

-(void)reloadBarWithTitle:(NSArray<NSString *> *)titles;

@property(nonatomic,weak)id<YHMenuBarDelegate> delegate;

-(void)selectIndex:(int)index;

@property(nonatomic,strong)UIColor * titleTextColor;

@property(nonatomic,strong)UIColor * titleTextHighlightColor;

@end
