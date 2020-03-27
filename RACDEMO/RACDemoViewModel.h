//
//  RACDemoViewModel.h
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/27.
//  Copyright © 2020 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "RACDemoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACDemoViewModel : NSObject

@property(nonatomic,strong)NSMutableArray *data;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)RACDemoModel   *model;

/**
 cell 点击事件
 */
@property(nonatomic,strong)RACCommand *itemClickCommand;

/**
刷新数据
*/
@property(nonatomic,strong)RACCommand *refreshCommand;

@end

NS_ASSUME_NONNULL_END
