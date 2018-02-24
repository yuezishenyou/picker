//
//  JBMainController.m
//  JBPicker
//
//  Created by maoziyue on 2018/2/24.
//  Copyright © 2018年 maoziyue. All rights reserved.
//

#import "JBMainController.h"
#import "JBPickerView.h"

@interface JBMainController ()

@property (nonatomic, strong) NSNumber *timesp;


@end

@implementation JBMainController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"main";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"pick"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(pickAction)];
    
}


- (void)pickAction
{
    JBPickerView *pick = [[JBPickerView alloc]initWithTimestamp:self.timesp];
    
    [pick setCompletionBlock:^(NSString *date, NSString *hour, NSString *minute, NSString *show, NSNumber *timestamp) {
        
        
        NSLog(@"--date:(%@)--hour:(%@)---minute:(%@)---show:(%@)--timestamp:(%@)-----",date,hour,minute,show,timestamp);
        
        self.title = [NSString stringWithFormat:@"%@ %@:%@",show,hour,minute];
        
        self.timesp = timestamp;
        
    }];
    
    
    [pick show];
}












@end
