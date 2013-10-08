//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  FFWord.h
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-30.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFWord : NSObject
@property (nonatomic,strong) NSString *simp;
@property (nonatomic,strong) NSArray *yin;
@property (nonatomic,strong) NSString *tra;
@property (nonatomic,strong) NSString *frame;
@property (nonatomic,strong) NSString *creat;
@property (nonatomic,strong) NSString *bushou;
@property (nonatomic,strong) NSString *bsnum;   //display words have same bushou
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSString *seq;
@property (nonatomic,strong) NSString *sound;

@end
