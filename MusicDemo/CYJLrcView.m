//
//  CYJLrcView.m
//  MusicDemo
//
//  Created by qingyun on 15/12/10.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import "CYJLrcView.h"
#import "CYJLrcLine.h"
#import "LrcTableViewCell.h"

@interface CYJLrcView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *lrcLines;
@property (nonatomic,assign) int currentIndex;
@end

@implementation CYJLrcView

- (NSMutableArray *)lrcLines
{
    if (_lrcLines == nil) {
        self.lrcLines = [NSMutableArray array];
    }
    return _lrcLines;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    //1.添加表格控件
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    _tableView = tableView;
}
//布局子视图
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.frame.size.height *0.5, 0, self.tableView.frame.size.height * 0.5, 0);
}

#pragma mark - 公共方法
- (void) setLrcname:(NSString *)lrcname
{
    _lrcname = [lrcname copy];
    
    //1.清空之前的歌词数据
    [self.lrcLines removeAllObjects];
    //2.加载歌词文件
//    NSURL *url = [[NSBundle mainBundle] URLForResource:_lrcname withExtension:nil];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"一次就好.lrc" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
    NSString *lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcArray = [lrcStr componentsSeparatedByString:@"\n"];
    //3.输出每一行歌词
    for (NSString *lrc in lrcArray) {
        CYJLrcLine *line = [[CYJLrcLine alloc] init];
        [self.lrcLines addObject:line];
        if (![lrc hasPrefix:@"[" ]) {
            continue;
        }
        //如果是歌词的头部信息(歌名、歌手、专辑)
        if ([lrc hasPrefix:@"[ti:]"] || [lrc hasPrefix:@"[ar:]"] || [lrc hasPrefix:@"[al:]"]) {
            NSString *word = [[lrc componentsSeparatedByString:@":"] lastObject];
            line.word = [word substringToIndex:word.length - 1];
        }else//不是头部信息
        {
            NSArray *array = [lrc componentsSeparatedByString:@"]"];
            line.time = [[array firstObject] substringFromIndex:1];
            line.word = [array lastObject];
        }
    }
    //刷新表格
    [self.tableView reloadData];
}

- (void)setCurrentTime:(NSTimeInterval *)currentTime
{
    if (currentTime < _currentTime) {
        self.currentIndex = -1;
    }
    _currentTime = currentTime;
    
    int min = (int)currentTime / 60;
    int second = (int)currentTime % 60;
    int msecond = (int)(currentTime - currentTime) * 100;
    //当前时间的字符串
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d",min,second,msecond];

    for (int indexs = self.currentIndex + 1; indexs < self.lrcLines.count; indexs++) {
        CYJLrcLine *currentLine = self.lrcLines[indexs];
        //当前模型的时间
        NSString *currentLineTime = currentLine.time;
        //下一个模型的时间
        NSString *nextLineTime = nil;
        NSUInteger nextIndex = indexs + 1;
        if (nextIndex < self.lrcLines.count) {
            CYJLrcLine *nextLine = self.lrcLines[nextIndex];
            nextLineTime = nextLine.time;
        }
        //判断是否是正在播放的歌词
        if (([currentTimeStr compare:currentLineTime] != NSOrderedAscending)
            && ([currentTimeStr compare:nextLineTime] == NSOrderedAscending)
                && self.currentIndex !=indexs) {
            //刷新tableView
            NSArray *reloadRows = @[[NSIndexPath indexPathForRow:self.currentIndex inSection:0],
                                    [NSIndexPath indexPathForRow:indexs inSection:0]
                                    ];
            self.currentIndex = indexs;
            [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
            
            //滚动到对应的行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexs inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLines.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LrcTableViewCell *cell = [LrcTableViewCell cellWithTableView:tableView];
    cell.lrcLine = self.lrcLines[indexPath.row];
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.textLabel.textColor = [UIColor redColor];
    }else
    {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor cyanColor];
    }
    return cell;
}


@end
