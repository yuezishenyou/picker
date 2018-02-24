//
//  JBPickerView.h
//  JBPicker
//
//  Created by maoziyue on 2018/2/24.
//  Copyright © 2018年 maoziyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBPickerView : UIView

@property (nonatomic, copy) void(^completionBlock)(NSString *date, NSString *hour, NSString *minute,NSString *show, NSNumber *timestamp);

- (instancetype)initWithTimestamp:(NSNumber *)timestamp;//13位时间戳

- (void)show;

- (void)dismiss;





@end
