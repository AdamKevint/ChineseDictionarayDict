//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  DetailViewController.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-27.
//  Copyright (c) 2013年 majun. All rights reserved.
//
//bishun  丶一丿丶一丿丶一丿丶一丿丶一丿
//http://www.lbx777.com/ywfj/ywcs/wz/wz02.htm
#import "DetailViewController.h"
#import "URLEncode.h"
#import "Hanzi.h"
#import "PPRevealSideViewController.h"
#import "ManagedObjectContext.h"
#import "MBProgressHUD.h"
#import "Collections.h"
@interface DetailViewController ()
@property (strong, nonatomic) MBProgressHUD *Hud;
@property (weak, nonatomic) IBOutlet UILabel *segmentStr;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textControl;

//UI
@property (weak, nonatomic) IBOutlet UILabel *pinyinDisplay;
@property (weak, nonatomic) IBOutlet UILabel *zhuyinDisplay;
@property (weak, nonatomic) IBOutlet UILabel *traDisplay;
@property (weak, nonatomic) IBOutlet UILabel *frameDisplay;
@property (weak, nonatomic) IBOutlet UILabel *numDisplay;
@property (weak, nonatomic) IBOutlet UILabel *notBushounumDisplay;
@property (weak, nonatomic) IBOutlet UILabel *seqDisplay;
@property (weak, nonatomic) IBOutlet UITextView *textDisplay;



@property (strong, nonatomic) NSDictionary *baseInfo;
@property (strong, nonatomic) NSString *base;
@property (strong, nonatomic) NSString *english;
@property (strong, nonatomic) NSString *hanyu;
@property (strong, nonatomic) NSString *idiom;

@property ( nonatomic) int num;
@property (strong, nonatomic) NSString  *seq;
@property (strong, nonatomic) NSString *sound;
@property (strong, nonatomic) NSString *tra;
@property (strong, nonatomic) NSString *pinyin;
@property (strong, nonatomic) NSString  *zhuyin;
@property (strong, nonatomic) NSString *frame;
@property (strong, nonatomic) NSString *create;
@property (strong, nonatomic) NSString *bushou;
@property ( nonatomic) int bsnum;



@end

@implementation DetailViewController

#pragma mark getDataFrom Internet 
- (void)getDataFromInternet {

   NSString *urlStr = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",[URLEncode encodeUrlStr:self.word]];
    NSURL *url = [NSURL URLWithString:urlStr];
  
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError ) {
            NSLog(@">>>>Error: WordGetter getDataFromInternet!%@",connectionError);
            
        }
        else {
            
            
            __autoreleasing NSError *error;
            //wordDict
            //message data type
            //data --- words page
            NSDictionary *ddddd = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            if (error) {
                NSLog(@"Error:------------->getDict");
                
            }
            
            else{
                NSDictionary *wordDict = [ddddd objectForKey:@"data"];
               
                self.baseInfo = [wordDict objectForKey:@"baseinfo"];
                self.base = [wordDict objectForKey:@"base"];
                self.english = [wordDict objectForKey:@"english"];
                self.hanyu = [wordDict objectForKey:@"hanyu"];
                self.idiom = [wordDict objectForKey:@"idiom"];
                //NSLog(@"%@",self.base);
                 //  NSLog(@"%@",self.english);
                 // NSLog(@"%@",self.hanyu);
                 //  NSLog(@"%@",self.idiom);
                
            
                self.tra = [self.baseInfo objectForKey:@"tra"];
              
                self.bsnum = [[self.baseInfo objectForKey:@"bsnum"] intValue];
//                NSLog(@"bsnum%d",self.bsnum);
             
                self.bushou = [self.baseInfo objectForKey:@"bushou"];
//                NSLog(@"bushou:%@",self.bushou);
                self.create = [self.baseInfo objectForKey:@"create"];
//                NSLog(@"create:%@",self.create);
                self.frame = [self.baseInfo objectForKey:@"frame"];
                self.num = [[self.baseInfo objectForKey:@"num"] intValue];
                self.seq = [self.baseInfo objectForKey:@"seq"];
                self.sound = [self.baseInfo objectForKey:@"sound"];
//                NSLog(@"frame:%@,num:%d,seq%@ sound:%@",self.frame,self.num,self.seq,self.sound);
                self.pinyin = [[self.baseInfo objectForKey:@"yin"] objectForKey:@"pinyin"];
                self.zhuyin = [[self.baseInfo objectForKey:@"yin"] objectForKey:@"zhuyin"];
//                NSLog(@"%@%@",self.pinyin,self.zhuyin);
                
                
                [self finishToRefreshUI];
            }
        }
    }];
}
- (void)finishToRefreshUI {
    
    self.pinyinDisplay.text = self.pinyin;
    self.zhuyinDisplay.text = self.zhuyin;
    if (![self.tra isEqual:[NSNull null]])
    self.traDisplay.text = self.tra;
    
    NSLog(@"tra:%@",self.tra);
    self.frameDisplay.text = self.frame;
    self.numDisplay.text =[NSString stringWithFormat:@"%d",self.bsnum];
    self.notBushounumDisplay.text = [NSString stringWithFormat:@"%d",self.num];
    self.seqDisplay.text = self.seq;
    [self doText];
}
- (void)doText {
    if (self.textControl.selectedSegmentIndex == 0) {
        self.textDisplay.text = self.base;
      
    } else if (self.textControl.selectedSegmentIndex == 1) {
        self.textDisplay.text = self.hanyu;
    } else if (self.textControl.selectedSegmentIndex == 2) {
        self.textDisplay.text = self.idiom;
    } else if (self.textControl.selectedSegmentIndex == 3) {
        self.textDisplay.text = self.english;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.revealSideViewController setTapInteractionsWhenOpened:PPRevealSideInteractionContentView|PPRevealSideInteractionNavigationBar];
    [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:NavCount object:self userInfo:@{NavCount: [NSNumber numberWithInt:(int)self.navigationController.viewControllers.count]}] ];
    self.title = self.word;
    [self getDataFromInternet];
    [self saveCoreData];
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


- (void)saveCoreData {
    BOOL inputIsExist = NO;
    NSArray *array = [self haveCoreDataArrayCode];
    Hanzi *existHanzi;
    
    for (Hanzi *hanzi in array)
        if ([self.word isEqualToString:hanzi.text])
        {
           
            inputIsExist = YES;
            existHanzi = hanzi;
            break;
            
        }
    if (inputIsExist) {
        NSLog(@"exist!");
        existHanzi.time = [NSDate date];
        [[ManagedObjectContext sharedManagedObjcContext] save:nil];
    } else {
        Hanzi *hanzi = [NSEntityDescription insertNewObjectForEntityForName:@"Hanzi" inManagedObjectContext:[ManagedObjectContext sharedManagedObjcContext]];
        hanzi.text = self.word;
        hanzi.time = [NSDate date];
        [[ManagedObjectContext sharedManagedObjcContext] save:nil];
        
        
    }
  
    //正则
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.word;
    self.myTestLabel.text = self.word;

}
#pragma mark-segmentControl methods
- (IBAction)segmentControll:(UISegmentedControl *)sender {
    self.segmentStr.text = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    [self doText];
}

#pragma mark-homePressed
- (IBAction)homePressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma toolBar - methods 
- (IBAction)copyButtonPressed:(id)sender {
    UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
    pasteboard.string=self.textDisplay.text;
    _Hud = [[MBProgressHUD alloc] initWithView:self.view];
    [_Hud show:YES];
//    _Hud.customView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"023.png"]];
    _Hud.mode = MBProgressHUDModeCustomView;
    _Hud.labelText=@"已复制到剪贴板";
    [self.view addSubview:_Hud];
    [_Hud hide:YES afterDelay:1];

    
    

}
- (IBAction)colletionButtonPressed:(id)sender {
    /*@dynamic text;
     @dynamic time;
     @dynamic pinyin;
     @dynamic bushou;
     @dynamic bihua;
     @dynamic frame;*/
    BOOL inputIsExist = NO;
    NSArray *array = [self haveCoreDataArrayCodeCollections];
    Collections *existHanzi;
    for (Collections *hanzi in array)
        if ([self.word isEqualToString:hanzi.text])
        {   inputIsExist = YES;
            existHanzi = hanzi;
            break;
            
        }
    if (inputIsExist) {
   
        existHanzi.time = [NSDate date];
        [[ManagedObjectContext sharedManagedObjcContext] save:nil];
    } else {
        Collections *hanzi = [NSEntityDescription insertNewObjectForEntityForName:@"Collections" inManagedObjectContext:[ManagedObjectContext sharedManagedObjcContext]];
        hanzi.text = self.word;
        hanzi.time = [NSDate date];
        hanzi.pinyin = self.pinyin;
        hanzi.bushou = self.bushou;
        hanzi.bihua = [NSString stringWithFormat:@"%d",self.num];
        hanzi.frame = self.frame;
        
        
        [[ManagedObjectContext sharedManagedObjcContext] save:nil];
        
    }

    
    _Hud = [[MBProgressHUD alloc] initWithView:self.view];
    [_Hud show:YES];
    //    _Hud.customView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"023.png"]];
    _Hud.mode = MBProgressHUDModeCustomView;
    _Hud.labelText=@"已成功收藏！";
    [self.view addSubview:_Hud];
    [_Hud hide:YES afterDelay:1];
}
- (NSArray *)haveCoreDataArrayCodeCollections {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Collections"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    __autoreleasing NSError *error;
    NSArray *array = [[ManagedObjectContext sharedManagedObjcContext] executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (IBAction)shareButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"aboutme"];
    NSLog(@"%@",vc);
    [self presentViewController:vc animated:YES completion:nil];
}


@end
