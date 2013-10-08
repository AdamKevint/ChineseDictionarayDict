//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  TableViewSearchViewController.h
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-29.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewSearchViewController : UIViewController
@property (copy, nonatomic) NSString *pinyin;
@property (nonatomic) BOOL pinYinNotBuShou;
@property (nonatomic, copy) NSString *selectedIndexStr;
@end
