//
//  Collections.h
//  ChineseDictionary
//
//  Created by AdamKevint on 13-10-8.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Collections : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * pinyin;
@property (nonatomic, retain) NSString * bushou;
@property (nonatomic, retain) NSString * bihua;
@property (nonatomic, retain) NSString * frame;

@end
