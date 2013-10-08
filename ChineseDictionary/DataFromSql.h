//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  DataFromSql.h
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-30.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Bushou.h"
@interface DataFromSql : NSObject
//Object NSString like  :@"chuang"
@property (nonatomic, strong) NSArray *pinyinsSeperateByCapital;
//Object Bushou--->bushou.text,bushou.textID
@property (nonatomic, strong) NSArray *bushousSeperateByWritingCount;

+ (DataFromSql *)data ;
@end
