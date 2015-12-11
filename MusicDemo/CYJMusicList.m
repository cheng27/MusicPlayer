//
//  CYJMusicList.m
//  MusicDemo
//
//  Created by qingyun on 15/12/8.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import "CYJMusicList.h"
#import "CYJPlayingViewController.h"
#import "CYJMusic.h"
#import "MusicListTableViewCell.h"


@interface CYJMusicList ()
@property (nonatomic,strong) NSArray *musics;

@end

@implementation CYJMusicList
static NSString *identifier = @"musics";

//懒加载数据
- (NSArray *)musics
{
    if (_musics==nil) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"Music" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mtarr=[NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            CYJMusic *music=[CYJMusic musicWithDict:dict];
            [mtarr addObject:music];
        }
        _musics=mtarr;
    }
    return _musics;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[MusicListTableViewCell class] forCellReuseIdentifier:identifier];
    //设置行高
    self.tableView.rowHeight = 80;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.musics.count;
}

//设置行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier  forIndexPath:indexPath];
    
    CYJMusic *music = self.musics[indexPath.row];
    cell.musics = music;
    
    return cell;
}
//点击每一行执行的具体操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    __weak CYJPlayingViewController *playVC = [story instantiateViewControllerWithIdentifier:@"music"];
    //把获取到的数据赋值给playVC的数组
    playVC.models = _musics;
   //利用代码块把点击的row传给playVC的歌曲下标index,并更新界面
    playVC.clickCellAction = ^{
        playVC.index = indexPath.row;
        [playVC updateUI] ;
        [playVC playmusic];
    };
    [self presentViewController:playVC animated:YES completion:^{}];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
