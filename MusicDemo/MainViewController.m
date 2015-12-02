//
//  MainViewController.m
//  musicPlayer
//
//  Created by qingyun on 15/11/26.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import "MainViewController.h"
#import "GuideViewController.h"

@interface MainViewController ()


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *mainImgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    [mainImgView setImage:[UIImage imageNamed:@"背景.jpg"]];
    
    [self.view addSubview:mainImgView];
    
    [self performSelector:@selector(createScrollview) withObject:self afterDelay:1];
    
    [self.view setUserInteractionEnabled:YES];
    // Do any additional setup after loading the view.
}

- (void)createScrollview
{
    GuideViewController *guideVC = [[GuideViewController alloc]init];
    
    [self presentViewController:guideVC animated:YES completion:^{}];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
