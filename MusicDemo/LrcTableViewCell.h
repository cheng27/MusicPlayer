//
//  LrcTableViewCell.h
//  MusicDemo
//
//  Created by qingyun on 15/12/10.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYJLrcLine;

@interface LrcTableViewCell : UITableViewCell
@property (nonatomic,strong) CYJLrcLine *lrcLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
