//
//  RACDemoView.m
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/26.
//  Copyright © 2020 Louis. All rights reserved.
//

#import "RACDemoView.h"

@implementation RACDemoView

-(instancetype)initWithFrame:(CGRect)frame{
if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor redColor];
    //创建一个按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"demo3" forState:UIControlStateNormal];
    [self addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //发送信号
        [self.btnClickSingle sendNext:@"按钮点击咯"];
        }];
    }
    return self;
}
-(RACSubject *)btnClickSingle{
    if (!_btnClickSingle) {
        _btnClickSingle = [RACSubject subject];
    }
    return _btnClickSingle;
}
@end
