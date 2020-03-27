//
//  RACDemoModel.h
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/27.
//  Copyright © 2020 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACDemoModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger age;


-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
