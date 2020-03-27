//
//  ViewController.m
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/26.
//  Copyright © 2020 Louis. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RACDemoView.h"
#import "RACDemoView2.h"
#import "RACDemoViewController.h"
@interface ViewController ()

@property (nonatomic,assign)int time;
@property (nonatomic,strong)RACDisposable *disposable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //按钮点击事件省略写点击方法
    [self demo1];
    
    //KVO监听省略写KVO的方法
    [self demo2];
    
    //替换无返回值的代理，省略写代理
    [self demo3];
    
    //监听指定的某个方法传参，省略写代理
    [self demo4];
    
    //监听某个通知，省去注册通知
    [self demo5];
    
    //监听testfeild文本变化，省去注册通知
    [self demo6];
    
    //监听self.view点击,省去写view的手势事件
    [[self.view rac_signalForSelector:@selector(hitTest:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        
        [[UIApplication sharedApplication].windows.firstObject endEditing:YES];
    }];
    
    //定时器，省略声明定时器
    [self demo7];
    
    //实现验证码倒计时功能，省去写定时器方法、省去在delloc处理定时器的销毁
    [self demo8];
    
    //网络请求时的依赖关系 用信号量控制
    [self demo9];
    
    //MVVC
    [self MVVMEnter];
}

-(void)demo1{
    //创建一个按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 70, 70)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"demo1" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.tag = 1001;
    //监听点击事件
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"按钮点击了%@",x);
    }];
}

-(void)demo2{
    //创建一个按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 140, 70, 70)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"demo2" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    //监听点击事件
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //改变btn的Frame
        x.frame = CGRectMake(100,110,200, 200);
    }];
    [[btn rac_valuesAndChangesForKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        //RACTwoTuple是一个集合类型，可以用数组的方式获取到里面的内容。
        NSLog(@"frame改变了%@",x.second);
    }];
    //这样的KVO你可以觉得好像并没有多了不起，那你看看demo3。
}

//只能代替没有返回值的代理
-(void)demo3{
    RACDemoView *racView = [[RACDemoView alloc]initWithFrame:CGRectMake(100, 220, 100, 100)];
    [self.view addSubview:racView];
    //替代了代理把值从racView中传了过来。
    [racView.btnClickSingle subscribeNext:^(id  _Nullable x) {
        //要传多个值，，可以传一个集合
        NSLog(@"%@",x);
    }];
}

-(void)demo4{
    //监听指定的某个方法传参
    RACDemoView2 *racView = [[RACDemoView2 alloc]initWithFrame:CGRectMake(100, 340, 100, 100)];
    [self.view addSubview:racView];
    [[racView rac_signalForSelector:@selector(sendValue:andDic:)] subscribeNext:^(RACTuple * _Nullable x) {
        //当有多个参数传递时，传递过来的是集合，假如要取集合中某个元素的内容，可以用一下方式
        NSLog(@"按钮点击了第一个参数：%@",x.first);
        NSLog(@"按钮点击了最后一个参数：%@",x.last);
    }];
}

-(void)demo5{
    //创建一个文本输入框
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(100, 450, 200, 50)];
    field.backgroundColor = [UIColor grayColor];
    [self.view addSubview:field];
    field.text = @"demo5";
    // 监听键盘弹出事件
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
}

-(void)demo6{
    //创建一个文本输入框
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(100, 510, 200, 50)];
    field.backgroundColor = [UIColor grayColor];
    [self.view addSubview:field];
    field.text = @"demo6";
    [field.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"文字改变了%@",x);
    }];
}

-(void)demo7{
    [[RACSignal interval:1.0 onScheduler:[RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
//        NSLog(@"demo7:%@",x);
    }];
}

-(void)demo8{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 570, 200, 50)];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"demo8:发送验证码" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
    __weak typeof(self) weakSelf = self;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        weakSelf.time = 10;
        btn.enabled = NO;
        [btn setTitle:[NSString stringWithFormat:@"请稍等%d秒",weakSelf.time] forState:UIControlStateDisabled];
        weakSelf.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            //减去时间
            weakSelf.time --;
            //设置文本
            NSString *text = (weakSelf.time > 0) ? [NSString stringWithFormat:@"请稍等%d秒",weakSelf.time] : @"重新发送";
            if (weakSelf.time > 0) {
                btn.enabled = NO;
                [btn setTitle:text forState:UIControlStateDisabled];
            }else{
                btn.enabled = YES;
                [btn setTitle:text forState:UIControlStateNormal];
                //关掉信号
                [weakSelf.disposable dispose];
            }
            
        }];
    }];
    
}

-(void)demo9{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 630, 200, 50)];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"demo9" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];

    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       
        // 处理多个请求，都返回结果的时候，统一做处理.
        RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送请求1
            NSLog(@"demo9发送请求1");
            
            //loading...
            sleep(1);
            
            [subscriber sendNext:@"请求1完成Data"];
            return nil;
        }];
        
        RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送请求2
            NSLog(@"demo9发送请求2");
            
            sleep(1.5);
            
            [subscriber sendNext:@"请求2完成Data"];
            return nil;
        }];
        
        // 使用注意：几个信号，selector的方法就几个参数，每个参数对应信号发出的数据。
        // 不需要订阅:不需要主动订阅,内部会主动订阅
        [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request2,request1]];
        
    }];
    
    
    
}
// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"demo9更新UI%@ %@",data,data1);
}

#pragma mark - RAC常用宏

-(void)demo10{
    // 监听self.view的center属性,当center发生改变的时候就会触发NSLog方法
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

//（1）RACObserve(就是一个宏定义):快速的监听某个对象的某个属性改变
-(void)demo11{
    //创建一个文本输入框
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(50, 120, 200, 50)];
    field.backgroundColor = [UIColor grayColor];
    [self.view addSubview:field];
    //创建一个label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 200, 50)];
    [self.view addSubview:label];
    //将输入框内容给label
    RAC(label,text) = field.rac_textSignal;
}

//（2）用来给某个对象的某个属性绑定信号，只要产生信号内容，就会把内容给属性赋值
-(void)demo12{
    //创建一个文本输入框
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(50, 120, 200, 50)];
    field.backgroundColor = [UIColor grayColor];
    [self.view addSubview:field];
    //创建一个label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 200, 50)];
    [self.view addSubview:label];
    //将输入框内容给label
    RAC(label,text) = field.rac_textSignal;
}
//（3）登录按钮的状态根据账号和密码输入框内容的长度来改变
-(void)demo13{
    UITextField *userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(40, 70, 200, 50)];
    UITextField *passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(40, 130, 200, 50)];
    userNameTF.placeholder = @"请输入用户名";
    passwordTF.placeholder = @"请输入密码";
    [self.view addSubview:userNameTF];
    [self.view addSubview:passwordTF];
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 180, 200, 50)];
    [loginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    //根据textfield的内容来改变登录按钮的点击可否
    RAC(loginBtn, enabled) = [RACSignal combineLatest:@[userNameTF.rac_textSignal, passwordTF.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * password){
        return @(username.length >= 11 && password.length >= 6);
    }];
    //根据textfield的内容来改变登录按钮的背景色
    RAC(loginBtn, backgroundColor) = [RACSignal combineLatest:@[userNameTF.rac_textSignal, passwordTF.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * password){
        return (username.length >= 11 && password.length >= 6) ? [UIColor redColor] : [UIColor grayColor];
    }];
    
}

//（4）避免循环引用，外部@weakify(self)，内部@strongify(self)
-(void)demo14{
    // @weakify() 宏定义
    @weakify(self) //相当于__weak typeof(self) weakSelf = self;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)  //相当于__strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@",self.view);
        return nil;
    }];
    signal;
}

- (void)MVVMEnter{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 630, 200, 50)];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"MVVCEnter" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UINavigationController *navVc = [[UINavigationController alloc]initWithRootViewController:[RACDemoViewController new]];
        [UIApplication sharedApplication].windows.firstObject.rootViewController = navVc;
    }];
    
    
}

/*
 三、总结：
 RAC的操作类似于iOS中系统的通知，整个流程就三个步骤，初始化信号，订阅信号，发送信号。只是框架本身许多方法隐藏了其中的一步或者两步，在框架内部实现了，所以我们用起来会很顺手。RAC为事件提供了很多处理方法，而且利用RAC处理事件很方便，可以把要处理的事情，和监听的事情的代码放在一起——以Block的方式，这样非常方便我们管理，就不需要跳到对应的方法里。

 作者：奇怪的她的他
 链接：https://www.jianshu.com/p/6af75a449d90
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
@end
