//
//  YHCombinViewController.m
//  YHCombinViewController
//
//  Created by jaki on 2017/7/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import "YHCombinViewController.h"

@interface YHCombinViewController ()

@property(nonatomic,strong)UIScrollView * mainScrollView;

@property(nonatomic,assign)int currentIndex;

@property(nonatomic,strong)UIViewController * currentController, *previousController,*nextController;

@property(nonatomic,strong)UIPanGestureRecognizer * panGestureRecognizer;

@property(nonatomic,assign)BOOL isAotuTransitoning;

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
    [self loadGesture];
    [self layoutInitalController];
}

-(void)loadGesture{
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

-(void)layoutInitalController{
    _currentController = self.controllerArrays[self.currentIndex];
    [self.view addSubview:_currentController.view];
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



#pragma mark - custom Animation
-(void)perpareTransitionController{
    CGRect currentRect = self.view.frame;
    if (self.currentIndex>0) {
        self.previousController = self.controllerArrays[self.currentIndex-1];
        CGRect preRect = self.previousController.view.frame;
        self.previousController.view.frame = CGRectMake(currentRect.origin.x-preRect.size.width, currentRect.origin.y, preRect.size.width, preRect.size.height);
        [self.view addSubview:self.previousController.view];
    }
    if (self.currentIndex<self.controllerArrays.count-1) {
        self.nextController = self.controllerArrays[self.currentIndex+1];
        CGRect nextRect = self.nextController.view.frame;
        self.nextController.view.frame = CGRectMake(currentRect.size.width, currentRect.origin.y, nextRect.size.width, nextRect.size.height);
        [self.view addSubview:self.nextController.view];
    }
}

-(void)didTransitionController:(CGPoint)point{
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
    if (currentView.frame.origin.x<=-currentView.frame.size.width/2) {
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
        }];
    }
}

#pragma mark - getter and setter

-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_mainScrollView];
        NSArray * constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mainScrollView]-0|" options:0 metrics:nil views:@{@"mainScrollView":_mainScrollView}];
        NSArray * constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mainScrollView]-0|" options:0 metrics:nil views:@{@"mainScrollView":_mainScrollView}];
        [_mainScrollView addConstraints:constraintH];
        [_mainScrollView addConstraints:constraintV];
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
    }
    return _panGestureRecognizer;
}





@end
