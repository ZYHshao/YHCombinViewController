//
//  YHCombinViewController.m
//  YHCombinViewController
//
//  Created by jaki on 2017/7/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import "YHCombinViewController.h"

#import "YHScrollView.h"



@interface YHCombinViewController ()<YHMenuBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat _menuHeight;
    CGFloat _headerHeight;
}
@property(nonatomic,strong)YHScrollView * mainScrollView;

@property(nonatomic,assign)int currentIndex;

@property(nonatomic,strong)UIViewController * currentController, *previousController,*nextController;

@property(nonatomic,strong)UIPanGestureRecognizer * panGestureRecognizer;

@property(nonatomic,assign)BOOL isAotuTransitoning;



@property(nonatomic,assign,readonly)CGFloat viewHeight;

@property(nonatomic,assign)CGFloat currentVelocity;

@property(nonatomic,assign)CGPoint currentViewScrollContentOffset;

@property(nonatomic,assign)BOOL mainScrollisTop;

@property(nonatomic,assign)BOOL scrollToTop;


@end

@implementation YHCombinViewController

#pragma mark -- constructor

-(instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers{
    self = [super init];
    if (self) {
        _controllerArrays = controllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMenu];
    [self loadGesture];
    [self layoutInitalController];
}


-(void)initialMenu{
    [self.mainScrollView addSubview:self.menuBar];
    NSMutableArray * titles = [NSMutableArray array];
    for (int i=0; i<self.controllerArrays.count; i++) {
        [titles addObject:self.controllerArrays[i].title?self.controllerArrays[i].title:@""];
    }
    [self.menuBar reloadBarWithTitle:titles];
    [self.menuBar selectIndex:self.currentIndex];
}

-(void)loadGesture{
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

-(void)layoutInitalController{
    _currentController = self.controllerArrays[self.currentIndex];
    _currentController.view.frame = CGRectMake(0, [self contentViewOffsetY],self.view.frame.size.width , self.viewHeight);
    [self.mainScrollView addSubview:_currentController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - function method
-(void)panHandler:(UIPanGestureRecognizer *)pan{
    if (self.isAotuTransitoning) {
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self perpareTransitionController];
    }else if(pan.state == UIGestureRecognizerStateChanged){
        CGPoint point = [pan translationInView:self.view];
        [self didTransitionController:point];
    }else if(pan.state == UIGestureRecognizerStateEnded){
        [self endTransitionController];
    }
}

-(void)selectControllerIndex:(int)index{
    if (index == self.currentIndex || index<0 || index>=self.controllerArrays.count) {
        return;
    }
    [self perpareTransitionControllerWithIndex:index];
    self.isAotuTransitoning = YES;
    if (index<self.currentIndex) {
        [self beginTransitionPrevious:index];
    }else{
        [self beginTransitionNext:index];
    }
}

-(void)beginTransitionPrevious:(int)index{
    UIView * currentView = self.currentController.view;
    UIView * preView = self.previousController.view;
    [UIView animateWithDuration:0.3 animations:^{
        currentView.frame = CGRectMake(currentView.frame.size.width, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
        preView.frame = CGRectMake(0, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height);
    }completion:^(BOOL finished) {
        self.isAotuTransitoning = NO;
        [currentView removeFromSuperview];
        self.currentIndex = index;
        self.currentController = self.controllerArrays[self.currentIndex];
        self.previousController = nil;
        self.nextController = nil;
        [self.menuBar selectIndex:self.currentIndex];
    }];
  
}

-(void)beginTransitionNext:(int)index{
    UIView * nextView = self.nextController.view;
    UIView * currentView = self.currentController.view;
    [UIView animateWithDuration:0.3 animations:^{
        currentView.frame = CGRectMake(-currentView.frame.size.width, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
        nextView.frame = CGRectMake(0, nextView.frame.origin.y, nextView.frame.size.width, nextView.frame.size.height);
    }completion:^(BOOL finished) {
        self.isAotuTransitoning = NO;
        [currentView removeFromSuperview];
        self.currentIndex = index;
        self.currentController = self.controllerArrays[self.currentIndex];
        self.previousController = nil;
        self.nextController = nil;
        [self.menuBar selectIndex:self.currentIndex];
    }];
}



-(void)perpareTransitionControllerWithIndex:(int)index{
    CGRect currentRect = self.currentController.view.frame;
    if (index<self.currentIndex) {
        self.previousController = self.controllerArrays[index];
        self.previousController.view.frame = CGRectMake(currentRect.origin.x-currentRect.size.width, currentRect.origin.y, self.view.frame.size.width, self.viewHeight);
        [self.mainScrollView addSubview:self.previousController.view];
    }else{
        self.nextController = self.controllerArrays[index];
        self.nextController.view.frame = CGRectMake(currentRect.size.width, currentRect.origin.y, self.view.frame.size.width, self.viewHeight);
        [self.mainScrollView addSubview:self.nextController.view];
    }
}


#pragma mark - custom Animation
-(void)perpareTransitionController{
    self.currentVelocity = 0;
    CGRect currentRect = self.currentController.view.frame;
    if (self.currentIndex>0) {
        self.previousController = self.controllerArrays[self.currentIndex-1];
        self.previousController.view.frame = CGRectMake(currentRect.origin.x-currentRect.size.width, currentRect.origin.y, self.view.frame.size.width, self.viewHeight);
        [self.mainScrollView addSubview:self.previousController.view];
    }
    if (self.currentIndex<self.controllerArrays.count-1) {
        self.nextController = self.controllerArrays[self.currentIndex+1];
        self.nextController.view.frame = CGRectMake(currentRect.size.width, currentRect.origin.y, self.view.frame.size.width, self.viewHeight);
        [self.mainScrollView addSubview:self.nextController.view];
    }
}

-(void)didTransitionController:(CGPoint)point{
    self.currentVelocity = [self.panGestureRecognizer velocityInView:self.view].x;
    UIView * preView = self.previousController.view;
    UIView * nextView = self.nextController.view;
    UIView * currentView = self.currentController.view;
    CGRect cR = CGRectMake(0, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
    CGRect pR = CGRectMake(-preView.frame.size.width, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height);
    CGRect nR = CGRectMake(currentView.frame.size.width, nextView.frame.origin.y, nextView.frame.size.width, nextView.frame.size.height);
    if(point.x>0){
        if (cR.origin.x+point.x<0) {
            currentView.frame = CGRectMake(cR.origin.x+point.x, cR.origin.y, cR.size.width, cR.size.height);
            if (preView) {
                preView.frame = CGRectMake(pR.origin.x+point.x, pR.origin.y, pR.size.width, pR.size.height);
            }
            if (nextView) {
                nextView.frame = CGRectMake(nR.origin.x+point.x, nR.origin.y, nR.size.width, nR.size.height);
            }
        }else{
            if (preView) {
                currentView.frame = CGRectMake(cR.origin.x+point.x, cR.origin.y, cR.size.width, cR.size.height);
                preView.frame = CGRectMake(pR.origin.x+point.x, pR.origin.y, pR.size.width, pR.size.height);
            }else{
                currentView.frame = CGRectMake(0, cR.origin.y, cR.size.width, cR.size.height);
            }
            if (nextView) {
                nextView.frame = CGRectMake(cR.size.width, nR.origin.y, nR.size.width, nR.size.height);
            }
        }
    }else{
        if (cR.origin.x+point.x>0) {
            currentView.frame = CGRectMake(cR.origin.x+point.x, cR.origin.y, cR.size.width, cR.size.height);
            if (nextView) {
                nextView.frame = CGRectMake(nR.origin.x+point.x, nR.origin.y, nR.size.width, nR.size.height);
            }
            if (preView) {
                preView.frame = CGRectMake(pR.origin.x+point.x, pR.origin.y, pR.size.width, pR.size.height);
            }
        }else{
            if (nextView) {
                nextView.frame = CGRectMake(nR.origin.x+point.x, nR.origin.y, nR.size.width, nR.size.height);
                currentView.frame = CGRectMake(cR.origin.x+point.x, cR.origin.y, cR.size.width, cR.size.height);
            }else{
                currentView.frame = CGRectMake(0, cR.origin.y, cR.size.width, cR.size.height);
            }
            if (preView) {
                preView.frame = CGRectMake(-pR.size.width, pR.origin.y, pR.size.width, pR.size.height);
            }
        }
    }
    
}

-(void)endTransitionController{
    UIView * currentView = self.currentController.view;
    UIView * nextView = self.nextController.view;
    UIView * preView = self.previousController.view;
    self.isAotuTransitoning = YES;
    if (self.currentVelocity<-300) {
        if (nextView) {
            [UIView animateWithDuration:0.3 animations:^{
                currentView.frame = CGRectMake(-currentView.frame.size.width, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
                nextView.frame = CGRectMake(0, nextView.frame.origin.y, nextView.frame.size.width, nextView.frame.size.height);
            }completion:^(BOOL finished) {
                self.isAotuTransitoning = NO;
                [preView removeFromSuperview];
                [currentView removeFromSuperview];
                self.currentIndex++;
                self.currentController = self.controllerArrays[self.currentIndex];
                self.previousController = nil;
                self.nextController = nil;
                [self.menuBar selectIndex:self.currentIndex];
            }];
        }else{
            self.isAotuTransitoning = NO;
        }
    }else if(self.currentVelocity>300){
        if (preView) {
            [UIView animateWithDuration:0.3 animations:^{
                currentView.frame = CGRectMake(currentView.frame.size.width, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
                preView.frame = CGRectMake(0, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height);
            }completion:^(BOOL finished) {
                self.isAotuTransitoning = NO;
                [nextView removeFromSuperview];
                [currentView removeFromSuperview];
                self.currentIndex--;
                self.currentController = self.controllerArrays[self.currentIndex];
                self.previousController = nil;
                self.nextController = nil;
                [self.menuBar selectIndex:self.currentIndex];
            }];
        }else{
            self.isAotuTransitoning = NO;
        }
    }else if (currentView.frame.origin.x<=-currentView.frame.size.width/2) {
        [UIView animateWithDuration:0.3 animations:^{
            currentView.frame = CGRectMake(-currentView.frame.size.width, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
            nextView.frame = CGRectMake(0, nextView.frame.origin.y, nextView.frame.size.width, nextView.frame.size.height);
        }completion:^(BOOL finished) {
            self.isAotuTransitoning = NO;
            [preView removeFromSuperview];
            [currentView removeFromSuperview];
            self.currentIndex++;
            self.currentController = self.controllerArrays[self.currentIndex];
            self.previousController = nil;
            self.nextController = nil;
            [self.menuBar selectIndex:self.currentIndex];
        }];
    }else if (currentView.frame.origin.x<=currentView.frame.size.width/2) {
        [UIView animateWithDuration:0.3 animations:^{
            currentView.frame = CGRectMake(0, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
            preView.frame = CGRectMake(-preView.frame.size.width, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height);
            nextView.frame = CGRectMake(currentView.frame.size.width, nextView.frame.origin.y, nextView.frame.size.width, nextView.frame.size.height);
        }completion:^(BOOL finished) {
            self.isAotuTransitoning = NO;
            [preView removeFromSuperview];
            [nextView removeFromSuperview];
            self.previousController = nil;
            self.nextController = nil;
            [self.menuBar selectIndex:self.currentIndex];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            currentView.frame = CGRectMake(currentView.frame.size.width, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
            preView.frame = CGRectMake(0, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height);
        }completion:^(BOOL finished) {
            self.isAotuTransitoning = NO;
            [nextView removeFromSuperview];
            [currentView removeFromSuperview];
            self.currentIndex--;
            self.currentController = self.controllerArrays[self.currentIndex];
            self.previousController = nil;
            self.nextController = nil;
            [self.menuBar selectIndex:self.currentIndex];
        }];
    }
}




#pragma mark - layout

-(void)reloadView{
    self.mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.menuBar.frame = CGRectMake(0, _headerHeight, self.view.frame.size.width, self.menuHeight);
    [self.mainScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+_headerHeight)];
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self reloadView];
}

#pragma mark - getter and setter

-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[YHScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _mainScrollView.delegate = self;
        [self.view addSubview:_mainScrollView];
        _mainScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mainScrollView;
}

-(int)currentIndex{
    if (_currentIndex>=self.controllerArrays.count) {
        return (int)self.controllerArrays.count-1;
    }
    if (_currentIndex<0) {
        return 0;
    }
    return _currentIndex;
}

-(UIPanGestureRecognizer *)panGestureRecognizer{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

-(YHMenuBar *)menuBar{
    if (!_menuBar) {
        _menuBar = [[YHMenuBar alloc]initWithTitles:nil];
        _menuBar.frame = CGRectMake(0, 0, self.view.frame.size.width, self.menuHeight);
        _menuBar.delegate = self;
    }
    return _menuBar;
}

-(CGFloat)menuHeight{
    if (_menuHeight<30) {
        return 30;
    }
    if (_menuHeight>70) {
        return 70;
    }
    return _menuHeight;
}

-(void)setMenuHeight:(CGFloat)menuHeight{
    _menuHeight = menuHeight;
    [self reloadView];
}

-(CGFloat)viewHeight{
    return self.view.frame.size.height-self.menuHeight;
}

-(CGFloat)contentViewOffsetY{
    return self.menuHeight+_headerHeight;
}

-(void)setHeaderView:(UIView *)headerView{
    _headerView = headerView;
    if (!headerView) {
        _headerHeight = 0;
    }else{
        _headerHeight = headerView.frame.size.height;
        _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, _headerHeight);
        [self.mainScrollView addSubview:self.headerView];
    }
    [self reloadView];
}

#pragma mark - menuBar delegate
-(void)selectedItemWithIndex:(int)index{
    [self selectControllerIndex:index];
}

#pragma mark - scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollToTop) {
        return;
    }
    if (scrollView==self.mainScrollView) {
        UIScrollView * tmpScroll = [self getCurrentScrollView];
        if (self.mainScrollView.contentOffset.y>_headerHeight) {
            self.mainScrollisTop = YES;
            [self.mainScrollView setContentOffset:CGPointMake(0, _headerHeight)];
        }
        if (self.mainScrollisTop) {
            self.currentViewScrollContentOffset = tmpScroll.contentOffset;
            if (tmpScroll.contentOffset.y>0) {
                 [self.mainScrollView setContentOffset:CGPointMake(0, _headerHeight)];
            }else{
                self.mainScrollisTop = NO;
            }
        }else{
            [tmpScroll setContentOffset:self.currentViewScrollContentOffset];
        }
    }
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    self.scrollToTop = YES;
    self.mainScrollisTop = NO;
    [[self getCurrentScrollView] scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:YES];
    return YES;
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    self.scrollToTop = NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    UIScrollView * tmpScroll = [self getCurrentScrollView];
    if (tmpScroll) {
        self.currentViewScrollContentOffset = tmpScroll.contentOffset;
    }else{
        self.currentViewScrollContentOffset = CGPointZero;
    }
  
}


-(UIScrollView *)getCurrentScrollView{
    UIView * currentView = self.currentController.view;
    NSArray * tmpScrolls = currentView.subviews;
    UIScrollView * tmpScroll = nil;
    if ([currentView isKindOfClass:[UIScrollView class]]) {
        tmpScroll = (UIScrollView *)currentView;
    }else{
        for (UIView * v in tmpScrolls) {
            if ([v isKindOfClass:[UIScrollView class]]) {
                tmpScroll = (UIScrollView *)v;
            }
        }
    }
    tmpScroll.bounces = NO;
    tmpScroll.scrollsToTop = NO;
    return tmpScroll;
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (ABS([_panGestureRecognizer velocityInView:self.view].y)>50) {
        return NO;
    }else{
        return YES;
    }
}


@end
