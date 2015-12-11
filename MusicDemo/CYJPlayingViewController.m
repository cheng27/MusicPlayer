//
//  CYJPlayingMusicViewControlierViewController.m
//  MusicDemo
//
//  Created by qingyun on 15/11/28.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import "CYJPlayingViewController.h"
#import "CYJMusic.h"
#import <AVFoundation/AVFoundation.h>
#import "CYJMusicList.h"
#import "CYJLrcView.h"


@interface CYJPlayingViewController ()<AVAudioPlayerDelegate>
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
//播放进度的定时器
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong) CYJMusic *playMusic;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
//歌手
@property (weak, nonatomic) IBOutlet UILabel *singer;
//歌曲名字
@property (weak, nonatomic) IBOutlet UILabel *songName;
//歌曲的总时长
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;

//播放或暂停
@property (weak, nonatomic) IBOutlet UIButton *playOrPause;
//上一首
@property (weak, nonatomic) IBOutlet UIButton *latestBtn;
//下一首
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
//显示歌词的view
@property (weak, nonatomic) IBOutlet CYJLrcView *lrcView;
//歌词显示的定时器
@property (nonatomic,strong) CADisplayLink *lrcTime;



//@property (nonatomic,strong) NSArray *models;
//声明一个变量来判断是在播放还是暂停的状态
@property (nonatomic)int flag;
//数组的下标
//@property (nonatomic) NSInteger index;

@end

@implementation CYJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    _flag = 1;
    _slider.value=0;
    [self updateUI];
    [self.audioPlayer pause];
    self.clickCellAction();
    
}


- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100://上一首
            [self latest];
            break;
        case 101://播放或暂停
            if (_flag==1) {
                [self playmusic];
            }else
            {
                [self pausemusic];
            }
            break;
        case 102://下一首
            [self next];
            break;
            
        default:
            break;
    }
}
//上一首
- (void)latest
{
    //下标值减1
    _index--;
    [self updateUI];
    //判断数组是否越界
    if (_index<0) {
        _index=self.models.count-1;
    }
    //判断当前是在播放还是暂停
    if (_flag==-1) {
        [self playmusic];
    }else
    {
        [self pausemusic];
    }
}
//下一首
- (void)next
{
    //下标值加1
    _index++;
    [self updateUI];
    //判断数组是否越界
    if (_index>self.models.count-1) {
        _index=0;
    }
    
    //判断当前是在播放还是暂停
    if (_flag==-1) {
        [self playmusic];
    }else
    {
        [self pausemusic];
    }
}
//当歌曲播放完成时，会自动播放下一首
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        //_audioPlayer = nil;
        [self next];
    }
}
#pragma mark - 更新界面
//更新界面
- (void)updateUI
{
    [self addLrcTime];
    //循环播放歌曲
    if (_index>self.models.count-1) {
        _index=0;
    }
    
    CYJMusic *music=self.models[_index];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:music.filename ofType:nil];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    
    //设置播放次数
    _audioPlayer.numberOfLoops=0;
    //设置代理
    _audioPlayer.delegate=self;
    //加载音频文件
    [_audioPlayer prepareToPlay];
    
    //更改backImage的图片
    _imgView.image=[UIImage imageNamed:music.image];
    //更改songName的文本
    _songName.text=music.name;
    //更改singer的文本
    _singer.text=music.singer;
    //切换歌词
    self.lrcView.lrcname = self.playMusic.lrcname;
    
    //监听slider的值
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    //监听当前的时间
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    //更改歌曲的总时长
    _totalTime.text=[self stringWithTime:self.audioPlayer.duration];
    NSLog(@"🍎%ld,%@",(long)self.index,_totalTime.text);
    
    [self.slider addTarget:self action:@selector(changeSliderValue:) forControlEvents:UIControlEventTouchDragInside];
    [self.slider addTarget:self action:@selector(didChangeSlider:) forControlEvents:UIControlEventTouchUpInside];
    
}
//把时间变为字符串格式
- (NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min=time/60;
    NSInteger second=(NSInteger)time%60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,second];
}
- (IBAction)lrcOrPic:(UIButton *)sender {
    if (self.lrcView.isHidden) {//显示歌词，覆盖图片
        self.lrcView.hidden = NO;
        sender.selected = YES;
    }else
    {//隐藏歌词，显示图片
        self.lrcView.hidden = YES;
        sender.selected = NO;
        
        [self removeLrcTime];
    }
}

#pragma mark - 1.音乐播放器的创建  2.播放音乐  3.暂停音乐
#if 0
- (AVAudioPlayer *)audioPlayer
{
    //创建播放器
    if (_audioPlayer==nil) {
        CYJMusic *music=self.models[_index];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:music.filename ofType:nil];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
        //设置属性
        _audioPlayer.numberOfLoops=0;
        _audioPlayer.delegate=self;
        //加载音频文件
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}
#endif
//播放音乐
- (void)playmusic
{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        [_playOrPause setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_playOrPause setImage:[UIImage imageNamed:@"暂停高亮"] forState:UIControlStateHighlighted];
        _flag = -1;
        //恢复定时器
        self.timer.fireDate=[NSDate distantPast];
    }
}
//暂停音乐
- (void)pausemusic
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        [_playOrPause setImage:[UIImage imageNamed:@"播放1"] forState:UIControlStateNormal];
        [_playOrPause setImage:[UIImage imageNamed:@"播放高亮"] forState:UIControlStateHighlighted];
        _flag = 1;
        //暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
        self.timer.fireDate=[NSDate distantPast];
    }
}
#pragma mark - 1.播放进度定时器的创建 2.进度条的更新 3.当前时间的更新
- (NSTimer *)timer
{
    if (_timer==nil) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)updateSlider
{
    //1.计算出来播放的比例
    float values=self.audioPlayer.currentTime/self.audioPlayer.duration;
    [_slider setValue:values animated:YES];
}
//拖动滑块，更改播放的进度
- (void)changeSliderValue:(UISlider *)slider
{
    //在拖动滑块的时候，歌曲是要暂停的，要更改_playOrPause的图片
    [_playOrPause setImage:[UIImage imageNamed:@"播放1"] forState:UIControlStateNormal];
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.audioPlayer pause];
}
//拖动滑块完成，开始播放
- (void)didChangeSlider:(UISlider *)slider
{
    if (_flag==-1) {
        //当前的时间就是歌曲的总时长和滑块的比例值的乘积
        self.audioPlayer.currentTime=self.audioPlayer.duration*self.slider.value;
        //当松开滑块的时候歌曲是要播放歌曲，要更改_playOrPause的图片
        [_playOrPause setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [self.timer setFireDate:[NSDate distantPast]];
        [self playmusic];
    }else
    {
        //当前的时间就是歌曲的总时长和滑块的比例值的乘积
        self.audioPlayer.currentTime=self.audioPlayer.duration*self.slider.value;
        //当松开滑块的时候歌曲是要播放歌曲，要更改_playOrPause的图片
        [_playOrPause setImage:[UIImage imageNamed:@"播放1"] forState:UIControlStateNormal];
        [self.timer setFireDate:[NSDate distantPast]];
        [self pausemusic];
    }
    
}
//更新当前的时间
- (void)updateTime
{
    CGFloat currentTime = self.audioPlayer.currentTime;
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime/60,(int)currentTime%60];
    self.slider.value = currentTime/self.audioPlayer.duration;
    
}
#pragma mark - 1.歌词定时器的创建 2.移除定时器 3.更新歌词
- (void)addLrcTime
{
    if (self.audioPlayer.isPlaying == NO || self.lrcView.hidden) {
        return;
    }
    [self removeLrcTime];
    //保证定时器的工作是及时的
    [self updateLrc];
    
    self.lrcTime = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTime addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)removeLrcTime
{
    [self.lrcTime invalidate];
    self.lrcTime = nil;
}

- (void)updateLrc
{
    self.lrcView.currentTime = (int)self.audioPlayer.currentTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

