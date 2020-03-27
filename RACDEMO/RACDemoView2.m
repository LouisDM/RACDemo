//
//  RACDemoView2.m
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/26.
//  Copyright © 2020 Louis. All rights reserved.
//

#import "RACDemoView2.h"

@implementation RACDemoView2

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        //创建一个按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"demo4" forState:UIControlStateNormal];
        [self addSubview:btn];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            //发送信号
            [self sendValue:@"1234" andDic:@{@"key":@"value"}];//这句是demo4的
            
        }];
    }
    return self;
}

-(void)sendValue:(NSString *)str andDic:(NSDictionary *)dic{
    NSLog(@"sendValueFUN");
}

@end
