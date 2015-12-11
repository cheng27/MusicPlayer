//
//  MusicListTableViewCell.m
//  MusicDemo
//
//  Created by qingyun on 15/12/8.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "CYJMusic.h"

@implementation MusicListTableViewCell

- (void)setMusics:(CYJMusic *)musics
{
    _musics = musics;
    self.textLabel.text = musics.name;
    self.imageView.image = [UIImage imageNamed:musics.album];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
