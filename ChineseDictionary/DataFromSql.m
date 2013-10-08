//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  DataFromSql.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-30.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import "DataFromSql.h"

@implementation DataFromSql

+ (DataFromSql *)data  {
    static DataFromSql *dataModelClass = nil;
    if (!dataModelClass) {
        NSLog(@"单例创建!");
        
    dataModelClass = [[DataFromSql alloc] init];
  
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ol_bushou.sqlite"];
    FMDatabase *db = [[FMDatabase alloc]initWithPath:path];
    [db open];
    
      //pinyin
    
    NSMutableArray *mArrayInstance = [NSMutableArray arrayWithCapacity:26];
    for (int i=0;i<26;i++) {
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
        NSString *capital = [NSString stringWithFormat:@"%c",'a'+i];
        
        FMResultSet *set=[db executeQuery:@"select * from ol_pinyins where type=? order by pinyin",capital];
        
        
        while ([set next]) {
            
            NSDictionary *result = [set resultDictionary];
            
            NSString *title=[result valueForKey:@"pinyin"];
            
            [mArray addObject:title];
        }
        NSArray *array = [NSArray arrayWithArray:mArray];
        [mArrayInstance addObject:array];
    }
    dataModelClass.pinyinsSeperateByCapital = [NSArray arrayWithArray:mArrayInstance];
    
    
    //bushou
        mArrayInstance = [NSMutableArray arrayWithCapacity:17];
        for (int i=1;i<=17;i++) {
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
            NSString *bihua = [NSString stringWithFormat:@"%d",i];
            FMResultSet *set=[db executeQuery:@"select * from ol_bushou where bihua=? order by title",bihua];
            while ([set next]) {
                NSDictionary *result = [set resultDictionary];
                Bushou *bushou = [[Bushou alloc] init];
                NSString *title=[result valueForKey:@"title"];
                bushou.text = title;
                bushou.textID = [[result valueForKey:@"id"] intValue];
                
                [mArray addObject:bushou];
            }
            NSArray *array = [NSArray arrayWithArray:mArray];
            [mArrayInstance addObject:array];
        }
        dataModelClass.bushousSeperateByWritingCount = [NSArray arrayWithArray:mArrayInstance];
    
    
    
    
    
    
    
    
    
    [db close];

    
    }
    return dataModelClass;
}

@end
