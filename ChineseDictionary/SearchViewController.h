//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  SearchViewController.h
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-25.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hanzi.h"

@interface SearchViewController : UIViewController<UITextFieldDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFld;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;





@end
