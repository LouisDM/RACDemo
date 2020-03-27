//
//  RACDemoTableView.m
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/27.
//  Copyright © 2020 Louis. All rights reserved.
//

#import "RACDemoTableView.h"
#import "RACDemoModel.h"

@implementation RACDemoTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.page      = 1;
        
        self.delegate  = self;
        self.dataSource = self;
        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.mj_footer.automaticallyHidden = YES;
        
    }
    return self;
}


-(void)refresh{
    self.page = 1;
    
    [self.viewModel.refreshCommand execute:@[self,@(self.page)]];
    
}

-(void)loadMoreData{
    self.page++;
    
    [self.viewModel.refreshCommand execute:@[self,@(self.page)]];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    RACDemoModel *mod = self.dataArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@:  %ld岁",mod.name,mod.age];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [self.viewModel.itemClickCommand execute:@[[NSNumber numberWithInteger:indexPath.row]]];
    
}

@end
