//
//  CYJPlayingMusicViewControlierViewController.h
//  MusicDemo
//
//  Created by qingyun on 15/11/28.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYJPlayingViewController : UIViewController
@property (nonatomic,strong) NSArray *models;
//数组的下标
@property (nonatomic) NSInteger index;
//声明block块传值
@property (nonatomic,strong) void(^clickCellAction)(void);

- (void)updateUI;
- (void)playmusic;

@end
