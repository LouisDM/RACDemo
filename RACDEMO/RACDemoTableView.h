//
//  RACDemoTableView.h
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/27.
//  Copyright © 2020 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACDemoViewModel.h"
#import "MJRefresh.h"
NS_ASSUME_NONNULL_BEGIN

@interface RACDemoTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)RACDemoViewModel *viewModel;

@property(nonatomic,strong)NSMutableArray   *dataArray;

@property(nonatomic,assign)NSInteger page;

@end

NS_ASSUME_NONNULL_END
