//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  PinyinDetailViewController.h
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-28.
//  Copyright (c) 2013年 majun. All rights reserved.
//
#import "EGORefreshTableFooterView.h"

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface PinyinDetailViewController : UITableViewController<NSURLConnectionDataDelegate,EGORefreshTableDelegate,UIScrollViewDelegate>
{
   
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
  BOOL _reloading;
}
@property (nonatomic) BOOL reloading;

@property (copy, nonatomic) NSString *detailPinyin;
@property (nonatomic) BOOL pinyinNotBuShou;
@property NSString *detailBuShou;




@end
