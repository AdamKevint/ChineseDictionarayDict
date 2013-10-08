//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  LeftViewController.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-10-7.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import "LeftViewController.h"
#import "PPRevealSideViewController.h"
@interface LeftViewController ()


@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // Do any additional setup after loading the view from its nib.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (IBAction)pushToPinyin:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UIViewController *pinyinController = [storyboard instantiateViewControllerWithIdentifier:@"pinyinVC"];
    [pinyinController setValue:[NSNumber numberWithBool:YES] forKey:@"pinYinNotBuShou"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    [array addObjectsFromArray:self.nav.viewControllers];
    if (array.count>1)
        [array removeObjectAtIndex:1];
    self.nav.viewControllers = [NSArray arrayWithArray:array];
    [self.nav pushViewController:pinyinController animated:YES];
    [self.revealSideViewController popViewControllerAnimated:YES];
}
- (IBAction)collection {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UIViewController *collectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"collection"];
  
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    [array addObjectsFromArray:self.nav.viewControllers];
    if (array.count>1)
        [array removeObjectAtIndex:1];
    self.nav.viewControllers = [NSArray arrayWithArray:array];
    [self.nav pushViewController:collectionViewController animated:YES];
    [self.revealSideViewController popViewControllerAnimated:YES];
}

- (IBAction)pushtobushou:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UIViewController *pinyinController = [storyboard instantiateViewControllerWithIdentifier:@"pinyinVC"];
    [pinyinController setValue:[NSNumber numberWithBool:NO] forKey:@"pinYinNotBuShou"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    [array addObjectsFromArray:self.nav.viewControllers];
    if (array.count>1)
        [array removeObjectAtIndex:1];
    self.nav.viewControllers = [NSArray arrayWithArray:array];
    [self.nav pushViewController:pinyinController animated:YES];
    [self.revealSideViewController popViewControllerAnimated:YES];
}


- (void)dealloc {
   
}
@end
