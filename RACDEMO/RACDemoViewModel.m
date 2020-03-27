//
//  RACDemoViewModel.m
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/27.
//  Copyright © 2020 Louis. All rights reserved.
//

#import "RACDemoViewModel.h"
#import "RACDemoTableView.h"
@implementation RACDemoViewModel


-(instancetype)init{
    self = [super init];
    if (self) {
        _data = [NSMutableArray array];
        
        [self initViewModel];
        
    }
    return self;
}

-(void)initViewModel{
    
    @weakify(self);
    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        
        self.page = [input[1] integerValue];
        
        if (self.page == 1) {
            [self.data removeAllObjects];
        }
        
        for (NSInteger i = 0; i< 5; i++) {
            
            NSDictionary *dic = @{@"name":[NSString stringWithFormat:@"第%ld页怪兽",self.page],@"age":@(self.data.count)};
            RACDemoModel  *mod = [[RACDemoModel alloc] initWithDictionary:dic];
            
            [self.data addObject:mod];
        }
        
        RACDemoTableView *tableView = input[0];
        [tableView reloadData];
        
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        
        return [RACSignal empty];
    }];
    
    
    self.itemClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        
        NSInteger index  =  [input[0] integerValue];
        RACDemoModel *mod = self.data[index];
        
        NSLog(@"%@",[NSString stringWithFormat:@"--%@:  %ld岁--",mod.name,mod.age]);
        
        return [RACSignal empty];
    }];
    
    
    
}

@end
