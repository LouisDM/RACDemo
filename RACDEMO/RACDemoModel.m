//
//  RACDemoModel.m
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/27.
//  Copyright © 2020 Louis. All rights reserved.
//

#import "RACDemoModel.h"

@implementation RACDemoModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
     self =  [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


@end
