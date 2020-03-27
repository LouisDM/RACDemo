//
//  RACDemoView.h
//  RACDEMO
//
//  Created by 辜东明 on 2020/3/26.
//  Copyright © 2020 Louis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface RACDemoView : UIView
@property (nonatomic,strong)RACSubject *btnClickSingle;
@end

NS_ASSUME_NONNULL_END
