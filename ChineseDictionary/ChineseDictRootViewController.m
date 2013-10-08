//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  ChineseDictRootViewController.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-25.
//  Copyright (c) 2013年 majun. All rights reserved.
//
#import "PPRevealSideViewController.h"
#import "AppButton.h"
#import "SearchViewController.h"
#import "ChineseDictRootViewController.h"
#import "DDProgressView.h"

@interface ChineseDictRootViewController ()<PPRevealSideViewControllerDelegate>
@property (weak, nonatomic) IBOutlet DDProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *lblProgresss;

@end

@implementation ChineseDictRootViewController


- (void)loadView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ChineseDictRootViewController" owner:self options:nil];
    self.view = [views objectAtIndex:0];
}
         
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.progress setOuterColor:[UIColor grayColor]];
    [self.progress setInnerColor:[UIColor greenColor]];
    [self.progress setEmptyColor:[UIColor clearColor]];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 0.007f target: self selector: @selector(updateProgress:) userInfo: nil repeats: YES] ;
	[timer fire] ;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self performSelector:@selector(startViewDismiss) withObject:self afterDelay:0.8];
}
- (void)updateProgress:(NSTimer *)timer {
    
    self.lblProgresss.text = [NSString stringWithFormat:@"%%%.0f",self.progress.progress*100];
    float progress = self.progress.progress + 0.01f;
    [self.progress setProgress:progress];
    if (self.progress.progress>=1) {
        [timer invalidate];
        
        [self performSelector:@selector(startViewDismiss) withObject:self afterDelay:0.5];
    }
    
}
- (void)startViewDismiss {

    if ([PPRevealSideViewController forbidPPR]) {
        [self performSegueWithIdentifier:@"search" sender:self];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
        
//        SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"Storyboard" bundle:[NSBundle mainBundle]];
        SearchViewController *searchViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    PPRevealSideViewController *ppr = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    [ppr setDirectionsToShowBounce:PPRevealSideDirectionNone];
    [ppr setPanInteractionsWhenClosed:PPRevealSideInteractionContentView | PPRevealSideInteractionNavigationBar];
    
    [self presentViewController:ppr animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
