//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  PinyinDetailViewController.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-28.
//  Copyright (c) 2013年 majun. All rights reserved.
//
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "URLEncode.h"
#import "IndexButton.h"
#import "PPRevealSideViewController.h"
#import "FFWord.h"
#import "FMDatabase.h"
#import "PinyinDetailViewController.h"
#import "DataFromSql.h"

@interface PinyinDetailViewController ()
@property (strong, nonatomic) MBProgressHUD *Hud;
@property (strong, nonatomic) NSString *pushDetailWord;
@property (assign,nonatomic) NSInteger page;
@property (nonatomic) BOOL refreshing;
@property (strong, nonatomic) NSMutableArray *words;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSMutableData *mp3Data;
@property (nonatomic) float totalLength;
@property (nonatomic) float currentLength;
@property (nonatomic) int pageCount;
@property (nonatomic) int pages;
@property (nonatomic) BOOL isFirstLoading;
@end

@implementation PinyinDetailViewController
- (void)loadData {
    [self removeFooterView];
    [self makeUrlAndGetDataCountInPage:5];
  
}
- (void)doFirstFooterView {
    if (_isFirstLoading) ;else {
        NSLog(@"ssssaaa!");
    [self setFooterView];
        [self finishReloadingData];}

}
-(void)setFooterView{

   
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        NSLog(@"NotfirstCreat!!!");
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        NSLog(@" First Creat!!!");
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
    }
    if (_refreshFooterView) {
       
        [_refreshFooterView refreshLastUpdatedDate:_isFirstLoading];
    }
    _isFirstLoading = NO;
    
}

-(void)removeFooterView{
    NSLog(@"remove FooterView");
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}
#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	NSLog(@"finishReloadingData");
	//  model should call this when its done loading
	_reloading = NO;
    
    
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self setFooterView];
    
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
  
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
	
    
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	NSLog(@"reload!");
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{

	return self.reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.revealSideViewController setTapInteractionsWhenOpened:PPRevealSideInteractionContentView|PPRevealSideInteractionNavigationBar];
    [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:NavCount object:self userInfo:@{NavCount: [NSNumber numberWithInt:(int)self.navigationController.viewControllers.count]}] ];
      _isFirstLoading = YES;
    [self setFooterView];
  
    if (_pinyinNotBuShou)    self.title = self.detailPinyin;
    else   self.title = self.detailBuShou;
    _pageCount = 1;
    [self makeUrlAndGetDataCountInPage:5];
  
    self.words = [NSMutableArray arrayWithCapacity:10];
   
}
- (void) makeUrlAndGetDataCountInPage:(int)page{
    
   
    NSURL *url;
    if (_pinyinNotBuShou) {
        
  
       
        NSString *string = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/%d/%d",self.detailPinyin,_pageCount,page];
      
       url = [NSURL URLWithString:string];}
    else {
        int textID;
        NSArray *bushou = [[DataFromSql data] bushousSeperateByWritingCount];
        for (int i=0;i<bushou.count;i++){
            NSArray *array = [bushou objectAtIndex:i];
            for (Bushou *bushou in array) {
                if ([self.detailBuShou isEqualToString:bushou.text]) textID = bushou.textID;
            }
        }
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.chazidian.com/service/bushou/%d/%d/%d",textID,_pageCount,page]];
       
    }
     
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError ) {
                NSLog(@">>%@>>Error: WordGetter getDataFrom pinyin pageCount!",connectionError);
              
            }
            else {
                
                
                __autoreleasing NSError *error;
                //pinyinDict
                //message data type
                //data --- words page
                NSDictionary *pinyinDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                if (error) {
                    NSLog(@"Error:WordGetter getDataFrom pinyin pageCount------------->getDict");
                    
                }
                
                else{
                    
                    int type = [[pinyinDict objectForKey:@"type"]intValue];
                    if (type == 100) {
                        
                        NSArray *array = [[pinyinDict objectForKey:@"data"] objectForKey:@"words"];
                        
                        
                        
                        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:5];
                        for (NSDictionary *dict in array) {
                            
                            FFWord *word = [FFWord new];
                            word.simp = [dict objectForKey:@"simp"];
                            word.bushou = [dict objectForKey:@"bushou"];
                            word.yin = [dict objectForKey:@"yin"];
                            word.tra = [dict objectForKey:@"tra"];
                            word.frame = [dict objectForKey:@"frame"];
                            word.bsnum = [dict objectForKey:@"bsnum"];
                            word.num = [dict objectForKey:@"num"];
                            word.seq = [dict objectForKey:@"seq"];
                            word.sound = [dict objectForKey:@"sound"];
                            [mArray addObject:word];
                        }
                        FFWord *word = [mArray lastObject];
                        FFWord *word2 = [self.words lastObject];
                        if ([word.simp isEqualToString:word2.simp]) {
                            _Hud = [[MBProgressHUD alloc] initWithView:self.view];
                            [_Hud show:YES];
                            //    _Hud.customView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"023.png"]];
                            _Hud.mode = MBProgressHUDModeCustomView;
                            _Hud.labelText=@"已加载全部！";
                            [self.view addSubview:_Hud];
                            [_Hud hide:YES afterDelay:1];
                           
                        }
                            else
                        {
                        [self.words addObjectsFromArray:mArray];
                        }
                    
                        
                    } else {
                        NSString *messge = [pinyinDict objectForKey:@"message"];
                        NSLog(@"%@",messge);
                        
                        
                    }
                    
                    
                }
            }
    
    
            [self.tableView reloadData];
            [self doFirstFooterView];
        }];
        

    
    _pageCount++;

    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pinyinDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    UILabel *wordLabel = (UILabel *)[cell viewWithTag:5];
    UILabel *pinyinLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *bushouLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *bihuaLabel = (UILabel *)[cell viewWithTag:6];
    
    FFWord *word = [self.words objectAtIndex:indexPath.row];
    wordLabel.text = word.simp;
    if ([word.yin isKindOfClass:[NSDictionary class]])
        pinyinLabel.text = [word.yin valueForKey:@"pinyin"];
    else

    pinyinLabel.text = [[word.yin objectAtIndex:0] valueForKey:@"pinyin"];
    bushouLabel.text = word.bushou;
    bihuaLabel.text = word.num;
    IndexButton *button = (IndexButton *)[cell viewWithTag:3];
    button.indexPath = indexPath;
   // [button addTarget:self action:@selector(doSound:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//点击发音
-(void)doSound:(IndexButton *)btn

{
 
    
    FFWord *word = [self.words objectAtIndex:btn.indexPath.row];
    NSLog(@"%@%@",word.simp,word.sound);
    

    
    
    if (![word.sound isEqual:@""]) {
   

  
        NSString *urlStr=[NSString stringWithFormat:@"http://api.ispeech.org/api/rest?apikey=8d1e2e5d3909929860aede288d6b974e&format=mp3&action=convert&voice=chchinesemale&text=%@",[URLEncode encodeUrlStr:word.simp]];//传所查汉字
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
        
        //异步连接
        [NSURLConnection connectionWithRequest:request delegate:self];

    }
}
#pragma mark- NSURLConnetion Delegate Methods
//1.  请求成功，返回相应对象，只调用一次
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.mp3Data = [NSMutableData dataWithCapacity:100];  //1.1初始化
    self.totalLength = [response expectedContentLength]; //1.2根据响应对象拿到期望的数据大小
    self.currentLength = 0;
}
//2.  来自父协议<NSURLConectionDelegate> 连接发生错误时调用
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"发生了错误，原因为：%@",error);
}
//3.  接收数据，调用多次   data 参数是每次返回的数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mp3Data appendData:data];
    self.currentLength += data.length;
  //  self.progressView.progress = (double) self.currentLength / self.totalLength;
}
//4. 连接请求完成 加载数据完成时调用
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    AVAudioPlayer * player = [[AVAudioPlayer alloc]initWithData:self.mp3Data error:nil];
    self.player = player;
    [self.player play];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"~~~" message:@"《Meaningful Glance》 Finished" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
//    [alert show];
 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FFWord *word = [self.words objectAtIndex:indexPath.row];

    self.pushDetailWord = word.simp;
    [self performSegueWithIdentifier:@"wordDetail" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"wordDetail"]) {
        [segue.destinationViewController setValue:self.pushDetailWord forKey:@"word"];
    }
    
}


@end
