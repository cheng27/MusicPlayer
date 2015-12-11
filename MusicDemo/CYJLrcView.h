//
//  CYJLrcView.h
//  MusicDemo
//
//  Created by qingyun on 15/12/10.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYJLrcView : UIView
//歌词的文件名
@property (nonatomic,copy) NSString *lrcname;
@property (nonatomic,assign) NSTimeInterval *currentTime;

@end
