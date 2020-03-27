//
//  RACDemoViewController.m
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/26.
//  Copyright © 2020 Louis. All rights reserved.
//

#import "RACDemoViewController.h"
#import "RACDemoTableView.h"
#import "RACDemoViewModel.h"
@interface RACDemoViewController ()

@property(nonatomic,strong) RACDemoTableView *tableView;
@property(nonatomic,strong) RACDemoViewModel *viewModel;

@end

@implementation RACDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MVVM";
    
    self.viewModel = [RACDemoViewModel new];
    
    [self bindViewModel];
    
    [self.view addSubview:self.tableView];
    
}


-(void)bindViewModel{
    
    //KVO 形式  动态监测 数组和 页数
    RAC(self.tableView,dataArray) = RACObserve(self.viewModel, self.data);
    RAC(self.tableView,page)      = RACObserve(self.viewModel, self.page);
    
    [self.viewModel.refreshCommand execute:@[self.tableView,@(1)]];
}

-(RACDemoTableView*)tableView{

    if (!_tableView) {
        _tableView = [[RACDemoTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _tableView.viewModel = self.viewModel;
        
    }
    return _tableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
