//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  SearchViewController.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-25.
//  Copyright (c) 2013年 majun. All rights reserved.
//
#import "AppButton.h"
#define Chinese @"[\\u4e00-\\u9fa5]"
#import "DetailViewController.h"
#import "TableViewSearchViewController.h"
#import "FMDatabase.h"
#import "DB.h"
#import "SearchViewController.h"
#import "ManagedObjectContext.h"
#import "PPRevealSideViewController.h"
#import "LeftViewController.h"
#import "ChineseDictRootViewController.h"
#import "TableViewSearchViewController.h"
@interface SearchViewController ()
@property (nonatomic) BOOL isShokeingNow;
@property (nonatomic) BOOL pprForbid;
@property (nonatomic) BOOL isPinyinNotBuShou;
@property (weak, nonatomic) IBOutlet UILabel *isPinyinDisplay;
@property (weak, nonatomic) IBOutlet UIView *serchViewBar;
@property (weak, nonatomic) IBOutlet UIView *buShouBar;
@property (copy, nonatomic) NSString *selectedStr;
@property (copy, nonatomic) NSString *wordForDetail;
@property (copy, nonatomic) NSString *pinyinSelected;
@property (nonatomic) BOOL isDeleltingLatestWord;
@property (nonatomic) NSInteger isDeletingInt;

@property (nonatomic,strong) LeftViewController *leftViewController;


@end

@implementation SearchViewController

#pragma mark viewControllerLifeCycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:NavCount object:self userInfo:@{NavCount: [NSNumber numberWithInt:(int)self.navigationController.viewControllers.count]}] ];
    
    
    [self latestSerch];
    self.txtFld.text = nil;
    [self customizeApperance];
    
    
               if (!self.leftViewController)
            self.leftViewController = [[LeftViewController alloc] init];
        self.leftViewController.nav = self.navigationController;
        [self.revealSideViewController preloadViewController:self.leftViewController forSide:PPRevealSideDirectionRight];
        [self.revealSideViewController changeOffset:230
                                       forDirection:PPRevealSideDirectionRight];
        [self.revealSideViewController setTapInteractionsWhenOpened:PPRevealSideInteractionContentView|PPRevealSideInteractionNavigationBar];
        
        
    [self receiveShokeNoti];
    
}
- (void) receiveShokeNoti {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(continueShoke:) name:@"shoke" object:nil];
}
- (void) continueShoke:(NSNotification *)noti {
    NSLog(@"!!!!!");
    _isShokeingNow = _isDeleltingLatestWord;
    if (_isShokeingNow) [self shokeWithTag:_isDeletingInt];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)loadView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SearchViewController" owner:self options:nil];
    self.view = [views objectAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeApperance];
    if (self.segement.selectedSegmentIndex == 0) _isPinyinNotBuShou = YES;
    [self latestSerch];
    [self buShouPinYinView];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - latestSerch
//可以尝试改成横向tableView
- (void)latestSerch {
    for (UIView *view in self.serchViewBar.subviews) [view removeFromSuperview];
    
    CGFloat x = 0.0;
    NSArray *array = [self haveCoreDataArrayCode];
    for (int i=0; i<6; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 44, 44)];
        if (i< array.count) {
            Hanzi *hanzi = [array objectAtIndex:i];
            label.text = hanzi.text;
        }
        
        label.font = [UIFont fontWithName:@"System" size:25.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = i;
        label.textColor = [[UIColor alloc] initWithRed:0.9 green:0.2 blue:0.2 alpha:1];
        [self.serchViewBar addSubview:label];
        
        //custom button
        CAppButton *appBtn = [CAppButton BtnWithType:UIButtonTypeCustom];
        [appBtn setFrame:CGRectMake(x,0,44,44)];
        [appBtn addTarget:self action:@selector(latestSearchTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        appBtn.tag = i;
        [self.serchViewBar addSubview:appBtn];
        UIImageView *tagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x-3, -3, 20, 20)] ;
        [tagImgView setImage:[UIImage imageNamed:@"deleteTag.png"]];
        tagImgView.tag = i;
        [tagImgView setHidden:YES];
        [self.serchViewBar addSubview:tagImgView];
        
        UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(latestLongpressed:)];
        [appBtn addGestureRecognizer:longPressed];
        
        
        
        x += 44;
    }
}
#pragma mark shoke
- (void)shokeWithTag:(NSInteger)tag {

    _isDeleltingLatestWord = YES;
    _isDeletingInt = tag;
    //refrence
    for (UIView *view in self.serchViewBar.subviews) {
        if (view.tag == tag) {
            
            srand([[NSDate date] timeIntervalSince1970]);
            float rand=(float)random();
            CFTimeInterval t=rand*0.0000000001;
            [UIView animateWithDuration:0.1 delay:t options:0  animations:^
             {
                 
                 view.transform=CGAffineTransformMakeRotation(-0.25);
             } completion:^(BOOL finished)
             {
                                  [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
                  {
                      view.transform=CGAffineTransformMakeRotation(0.25);
                  } completion:^(BOOL finished) {}];
             }];
            
            
        }
        
    }
}
- (void)latestLongpressed:(UILongPressGestureRecognizer *)sender {
    NSArray *array = [self haveCoreDataArrayCode];
    if (sender.view.tag<array.count) {
        
        if (!_isDeleltingLatestWord)  {
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                
                
                for (UIView *view in self.view.subviews)
                {
                    view.userInteractionEnabled = YES;
                    for (UIView *v in self.serchViewBar.subviews)
                    {
                        if ([v isMemberOfClass:[UIImageView class]] && v.tag == sender.view.tag)
                            [v setHidden:NO];
                    }
                }
                
                [self shokeWithTag:sender.view.tag];
            }
            
            
            
            
        }
    }
}
- (void)latestSearchTouchUpInside:(UIButton *)button {
    if (_isDeleltingLatestWord && button.tag == _isDeletingInt ) {
        NSArray *array = [self haveCoreDataArrayCode];
        Hanzi *hanzi = [array objectAtIndex:_isDeletingInt];
        [[ManagedObjectContext sharedManagedObjcContext] deleteObject:hanzi];
        [[ManagedObjectContext sharedManagedObjcContext] save:nil];
        [self latestSerch];
        _isDeleltingLatestWord = NO;
     
    } else if (!_isDeleltingLatestWord){
        NSArray *array = [self haveCoreDataArrayCode];
        
        if (button.tag < array.count){
            Hanzi *hanzi = [array objectAtIndex:button.tag];
            [self gotoDetailVCByString:hanzi.text];
        }
    }
    
}

#pragma mark customizedNavigationBarAppearance
- (void)customizeApperance {
   [[UINavigationBar appearance] setBackgroundColor:[[UIColor alloc] initWithRed:0 green:0.2 blue:0.9 alpha:0.9]];
}
#pragma mark-gotoDetailVC
- (void)gotoDetailVCByString:(NSString *)word {
          self.wordForDetail = word;
        [self performSegueWithIdentifier:@"detail" sender:self];
    
}
#pragma mark- BuShouPinYinBar
- (void)buShouPinYinView {
    for (UIView *view in self.buShouBar.subviews) [view removeFromSuperview];
    CGFloat x = 8.0;
    CGFloat y = 0.0;
    for (int i=0;i<30;i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 44, 44)];
        if (_isPinyinNotBuShou && i<26) {
            label.text = [NSString stringWithFormat:@"%c",'A'+i];
            UITapGestureRecognizer *tapPinyin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPinyin:)];
            [tapPinyin setNumberOfTapsRequired:1];
            [tapPinyin setNumberOfTouchesRequired:1];
            [label addGestureRecognizer:tapPinyin];
            label.userInteractionEnabled = YES;
            label.multipleTouchEnabled = YES;
            
            
        } else if (!_isPinyinNotBuShou && i<17) {
            label.text = [NSString stringWithFormat:@"%d",i+1 ];
            UITapGestureRecognizer *tapBushou = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBushou:)];
            [tapBushou setNumberOfTapsRequired:1];
            [tapBushou setNumberOfTouchesRequired:1];
            [label addGestureRecognizer:tapBushou];
            label.userInteractionEnabled = YES;
            label.multipleTouchEnabled = YES;
        }
        
        
        
        [self.buShouBar addSubview:label];
        if ((i+1)%6 == 0)  {y += 44.0; x = 8.0;}
        else  x += 44.0;
    }
}
- (void)tapPinyin:(UITapGestureRecognizer *)sender {
    UILabel *label = (UILabel *)sender.view;
    self.pinyinSelected = label.text;
    [self pushBuShouTableViewBy:nil];
}
- (void)tapBushou:(UITapGestureRecognizer *)sender {
    UILabel *label = (UILabel *)sender.view;
    [self pushBuShouTableViewBy:label.text];
}
- (void)pushBuShouTableViewBy:(NSString *)indexStr {
    if (indexStr)
        self.selectedStr = indexStr;
    
    [self performSegueWithIdentifier:@"pinyin" sender:self];
    
}
#pragma mark- SegueMethods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetailViewController *detailDisplayViewController = (DetailViewController *)segue.destinationViewController;
        detailDisplayViewController.word = self.wordForDetail;
    } else if ([segue.identifier isEqualToString:@"pinyin"]) {
        TableViewSearchViewController *pinyinViewController = (TableViewSearchViewController *)segue.destinationViewController;
        
        if (_isPinyinNotBuShou) {
            pinyinViewController.pinyin = self.pinyinSelected;
            pinyinViewController.pinYinNotBuShou = YES;
        }
        else {
            pinyinViewController.selectedIndexStr = self.selectedStr;
            pinyinViewController.pinYinNotBuShou = NO;
        }
    }
    
}

- (IBAction)segementChange:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
            _isPinyinNotBuShou = YES;
            self.isPinyinDisplay.text = @"按照拼音字母检索:";
            break;
        case 1:
            _isPinyinNotBuShou = NO;
            self.isPinyinDisplay.text = @"按照部首笔画检索:";
            break;
        default:
            break;
    }
    [self buShouPinYinView];

}



- (IBAction)more:(id)sender {
    [self.revealSideViewController pushViewController:self.leftViewController onDirection:PPRevealSideDirectionRight withOffset:230 animated:YES];
}



#pragma mark txtFld methods
- (IBAction)textfldSearch:(id)sender {
    //创建正则对象
    NSPredicate  *preChinese=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Chinese];
    if ([preChinese evaluateWithObject:self.txtFld.text]) {

    [self saveAndSearch];
    } else {
        self.txtFld.text = nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) [textField endEditing:YES];
    return YES;
}
#pragma mark SaveAndSearch
- (void)saveAndSearch {
    
    
    BOOL inputIsExist = NO;
    NSArray *array = [self haveCoreDataArrayCode];
    Hanzi *existHanzi;
    
    for (Hanzi *hanzi in array)
        if ([self.txtFld.text isEqualToString:hanzi.text])
        {
            NSLog(@"fld:%@ hanzi:%@",self.txtFld.text,hanzi);
            inputIsExist = YES;
            existHanzi = hanzi;
            break;
            
        }
    if (inputIsExist) {
     
        existHanzi.time = [NSDate date];
        [[ManagedObjectContext sharedManagedObjcContext] save:nil];
    } else {
    Hanzi *hanzi = [NSEntityDescription insertNewObjectForEntityForName:@"Hanzi" inManagedObjectContext:[ManagedObjectContext sharedManagedObjcContext]];
    hanzi.text = self.txtFld.text;
    hanzi.time = [NSDate date];
    [[ManagedObjectContext sharedManagedObjcContext] save:nil];
    
    
    }
    [self latestSerch];
  
    [self gotoDetailVCByString:self.txtFld.text];
}
#pragma mark TouchDownScreen
- (IBAction)touchDownScreen:(id)sender {
    [self closeKeyboard];
}
- (void)closeKeyboard {
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}
#pragma mark Array From Coredata
- (NSArray *)haveCoreDataArrayCode {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hanzi"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    __autoreleasing NSError *error;
    NSArray *array = [[ManagedObjectContext sharedManagedObjcContext] executeFetchRequest:fetchRequest error:&error];
    return array;
}




    
    


@end
