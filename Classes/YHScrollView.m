//
//  YHScrollView.m
//  YHCombinViewController
//
//  Created by jaki on 2017/7/28.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import "YHScrollView.h"

@implementation YHScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end
