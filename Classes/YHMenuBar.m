//
//  YHMenuBar.m
//  YHCombinViewController
//
//  Created by jaki on 2017/7/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import "YHMenuBar.h"


@interface YHMenuBar()
{
    UIColor * _titleTextHighlightColor;
    UIColor * _titleTextColor;
    int _index;
}
@property(nonatomic,strong)NSMutableArray * titlesArray;

@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)NSMutableArray<UIButton*> *itemArray;



@end

@implementation YHMenuBar
@synthesize titleTextHighlightColor;
@synthesize titleTextColor;
-(instancetype)initWithTitles:(NSArray<NSString *> *)titles{
    self = [super init];
    if (self) {
        [self.titlesArray addObjectsFromArray:titles];
        [self layoutView];
    }
    return self;
}


-(void)layoutView{
    self.backgroundColor = [UIColor whiteColor];
    for (UIButton * btn in self.itemArray) {
        [btn removeConstraints:btn.constraints];
        [btn removeFromSuperview];
    }
    [self.itemArray removeAllObjects];
    float allWidth = 0;
    for (int i=0; i<self.titlesArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollView addSubview:btn];
        [btn setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn setTitleColor:self.titleTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(allWidth, 0, btn.frame.size.width, self.frame.size.height);
        [btn setTitleColor:self.titleTextHighlightColor forState:UIControlStateSelected];
        allWidth+=btn.frame.size.width;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemArray addObject:btn];
    }
    self.scrollView.contentSize = CGSizeMake(allWidth, self.frame.size.height);
}

-(void)btnAction:(UIButton *)button{
    for (UIButton * btn in self.itemArray) {
        btn.selected = NO;
    }
    button.selected = YES;
    if ([self.delegate respondsToSelector:@selector(selectedItemWithIndex:)]){
        [self.delegate selectedItemWithIndex:(int)button.tag];
    }
    _index = (int)button.tag;
    [self layoutContentOffset:(int)button.tag];
}

-(void)reloadBarWithTitle:(NSArray<NSString *> *)titles{
    [self.titlesArray removeAllObjects];
    [self.titlesArray addObjectsFromArray:titles];
    [self layoutView];
}

-(void)selectIndex:(int)index{
    if (index<0) {
        index=0;
    }
    _index = index;
    if (index>=self.itemArray.count) {
        return;
    }
    for (UIButton * btn in self.itemArray) {
        btn.selected = NO;
    }
    [self.itemArray[index] setSelected:YES];
    [self layoutContentOffset:index];
}

-(void)layoutContentOffset:(int)index{
    CGFloat offset = index*self.scrollView.contentSize.width/self.titlesArray.count;
    if (offset>self.scrollView.contentSize.width-self.scrollView.frame.size.width) {
        return;
    }
     [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark - layout
-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - setter and getter
-(NSMutableArray *)titlesArray{
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(NSMutableArray<UIButton *> *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

-(void)setTitleTextColor:(UIColor *)titleTextColor{
    _titleTextColor = titleTextColor;
    [self layoutView];
    [self selectIndex:_index];
}

-(void)setTitleTextHighlightColor:(UIColor *)titleTextHighlightColor{
    _titleTextHighlightColor = titleTextHighlightColor;
    [self layoutView];
    [self selectIndex:_index];
}

-(UIColor *)titleTextColor{
    if (!_titleTextColor) {
        _titleTextColor = [UIColor blackColor];
    }
    return _titleTextColor;
}

-(UIColor *)titleTextHighlightColor{
    if (!_titleTextHighlightColor) {
        _titleTextHighlightColor = [UIColor redColor];
    }
    return _titleTextHighlightColor;
}

@end



