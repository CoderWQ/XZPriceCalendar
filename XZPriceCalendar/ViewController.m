//
//  ViewController.m
//  XZPriceCalendar
//
//  Created by coderXu on 16/12/19.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "ViewController.h"
#import "XZCalendarVc.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)clickTypeSingle:(id)sender {
    
    XZCalendarVc *vc  = [[XZCalendarVc alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
