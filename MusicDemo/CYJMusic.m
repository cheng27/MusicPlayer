//
//  CYJMusic.m
//  musicPlayer
//
//  Created by qingyun on 15/11/20.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import "CYJMusic.h"

@implementation CYJMusic

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
//        _name=dict[@"name"];
//        _singer=dict[@"singer"];
//        _filename=dict[@"filename"];
//        _image=dict[@"image"];
        [self setValuesForKeysWithDictionary:dict];
        
        
    }
    return self;
}

+ (instancetype)musicWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
