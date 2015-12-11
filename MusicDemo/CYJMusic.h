//
//  CYJMusic.h
//  musicPlayer
//
//  Created by qingyun on 15/11/20.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYJMusic : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *singer;
@property (nonatomic,strong) NSString *filename;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *album;
@property (nonatomic,strong) NSString *lrcname;

+ (instancetype)musicWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
