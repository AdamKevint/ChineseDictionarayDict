//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  TableViewSearchViewController.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-9-29.
//  Copyright (c) 2013年 majun. All rights reserved.
//
#import "PPRevealSideViewController.h"
#import "MJNIndexView.h"
#import "DataFromSql.h"
#import <QuartzCore/QuartzCore.h>

#define CRAYON_NAME(CRAYON)	[[CRAYON componentsSeparatedByString:@"#"] objectAtIndex:0]

#import "FMDatabase.h"

#import "FMDatabase.h"
#import "PinyinDetailViewController.h"
#import "TableViewSearchViewController.h"

@interface TableViewSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,
MJNIndexViewDataSource>


@property (copy, nonatomic) NSString *selectedBushou;
@property (copy, nonatomic) NSString *detailLabel;


// properties for section array
@property (nonatomic, strong) NSString *pathname;
@property (nonatomic, strong) NSArray *crayons;
@property (nonatomic, strong) NSString *alphaString;
@property (nonatomic, strong) NSMutableArray *sectionArray;
// properties for tableView
@property (nonatomic, strong) UITableView *tableView;

// MJNIndexView
@property (nonatomic, strong) MJNIndexView *indexView;

// properties for exampleView delegate
@property (nonatomic, strong) NSArray * allExamples;

#pragma mark all properties from MJNIndexView
// set this to NO if you want to get selected items during the pan (default is YES)
@property (nonatomic, assign) BOOL getSelectedItemsAfterPanGestureIsFinished;


@end

@implementation TableViewSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self dataSourceInit];
    
    self.pathname = [[NSBundle mainBundle]  pathForResource:@"crayons" ofType:@"txt"];
    
    [self refreshTable];
    
    
    // initialise tableView
    CGRect frame = self.view.bounds;
    if (!self.navigationController.navigationBar.hidden) {
        frame.origin.y += 66;
        frame.size.height -= 66;
    }
    
	self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
   
    [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    // initialise MJNIndexView
    self.indexView = [[MJNIndexView alloc]initWithFrame:self.tableView.frame];
    self.indexView.dataSource = self;
    
    
    [self.view addSubview:self.indexView];
    
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.revealSideViewController setTapInteractionsWhenOpened:PPRevealSideInteractionContentView|PPRevealSideInteractionNavigationBar];
    [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:NavCount object:self userInfo:@{NavCount: [NSNumber numberWithInt:(int)self.navigationController.viewControllers.count]}] ];    [self dataSourceInit];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // self.detailLabel = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    self.detailLabel = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"pinyinDetail" sender:self];
    
}
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pinyinDetail"]) {
        PinyinDetailViewController *vc = (PinyinDetailViewController *)segue.destinationViewController;
        if (_pinYinNotBuShou) {
            vc.detailPinyin = self.detailLabel;
            vc.pinyinNotBuShou = YES; }
        else {
            
            
            vc.detailBuShou = self.detailLabel;
            vc.pinyinNotBuShou = NO;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}






// refreshing table with a contents of file stored in self.pathname
- (void)refreshTable
{
    
	NSArray *rawCrayons = [[NSString stringWithContentsOfFile:self.pathname encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
	NSMutableArray *crayonColors = [NSMutableArray new];
	
    for (NSString *string in rawCrayons) [crayonColors addObject:CRAYON_NAME(string)];
    
    self.alphaString = @"";
    self.crayons = crayonColors;
   
    
    [self countFirstLettersInArray:self.crayons];
    //   int numberOfFirstLetters = [self countFirstLettersInArray:self.crayons]; //25
    
    /**********/
   
    /**********/
    // [self.tableView setSeparatorColor:self.tableSeparatorColor];
    [self.tableView reloadData];
    [self.tableView reloadSectionIndexTitles];
    [self.indexView refreshIndexItems];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:[self.sectionArray count] -1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_pinYinNotBuShou) return [NSString stringWithFormat:@"%c",'A'+(int)section];
    return [NSString stringWithFormat:@"%d",(int)section+1];
}

// refreshing MJNIndexView
- (void)refresh
{
    [self.indexView refreshIndexItems];
}




# pragma mark TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionArray[section]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:self.indexView.font.fontName size:20.0];
    cell.textLabel.text = [NSString stringWithFormat:@"     %@",[self categoryNameAtIndexPath:indexPath]];
       cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}





#pragma mark building sectionArray for the tableView
- (NSString *)categoryNameAtIndexPath: (NSIndexPath *)path
{
    NSArray *currentItems = self.sectionArray[path.section];
    NSString *category = currentItems[path.row];
    return category;
}


- (int) countFirstLettersInArray:(NSArray *)categoryArray
{

    NSMutableArray *existingLetters = [NSMutableArray array];
    for (NSString *name in categoryArray){
        NSString *firstLetterInName = [name substringToIndex:1];
        NSCharacterSet *notAllowed = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        NSRange range = [firstLetterInName rangeOfCharacterFromSet:notAllowed];
        
        if (![existingLetters containsObject:firstLetterInName] && range.location == NSNotFound ) {
            [existingLetters addObject:firstLetterInName];
            self.alphaString = [self.alphaString stringByAppendingString:firstLetterInName];
        }
    }
    int babala = (int)[existingLetters count];
    return babala;
}



- (NSString *) firstLetter: (NSInteger) section
{
    return [[self.alphaString substringFromIndex:section] substringToIndex:1];
}


#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    // in example 3 we want to show different index titles
    NSString *alpabeth = @"Ằdele Boss Cat Dog Egg Fog George Harry Idle Joke Key Luke Marry New Open Pot Rocket String Table Umbrella Violin Wind Xena Yellow Zyrro";
    
    NSMutableArray *results = [NSMutableArray array];
    
    for (int i = 0; i < [self.alphaString length]; i++)
    {
        NSString *substr = [self.alphaString substringWithRange:NSMakeRange(i,1)];
        [results addObject:substr];
    }
    
    if ([self.allExamples[2] boolValue]) return [alpabeth componentsSeparatedByString:@" "];
    else {
        if ([self.allExamples[3] boolValue]) {
            NSMutableArray *lowerCaseResults = [NSMutableArray new];
            for (NSString *letter in results) {
                [lowerCaseResults addObject:[letter lowercaseString]];
            }
            results = lowerCaseResults;
        }
        //return results;
    }
    if (_pinYinNotBuShou ) {
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:26];
        for (int i=0; i<26; i++) {
            NSString *title = [NSString stringWithFormat:@"%c",'A'+i];
            [mArray addObject:title];
        }
        return mArray;
    }
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:26];
    for (int i=0;i<17;i++)
    {
        NSString *title = [NSString stringWithFormat:@"%d",i+1];
        [mArray addObject:title];
    }
    return mArray;
}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
  
      
    if (self.sectionArray.count >=index)
        if ([[self.sectionArray objectAtIndex:index] count])
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (self.sectionArray.count>=index && [[self.sectionArray objectAtIndex:index] count]==0) {
        [self sectionForSectionMJNIndexTitle:Nil atIndex:index-1];
    }
    
}




#pragma mark above MJNView
- (void)scrollBySelectedIndexCapital:(NSString *)capital {
 
    int index;
    for (int i=0;i<26;i++)
    {
        if ([capital isEqualToString:[NSString stringWithFormat:@"%c",'A'+i]]) index = i;
    }
   
    while ( [[self.sectionArray objectAtIndex:index] count] == 0) {
        index--;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark dataSourceInit
- (void)dataSourceInit {
    self.sectionArray = nil;
    self.sectionArray = [NSMutableArray arrayWithCapacity:16];
    if (_pinYinNotBuShou) {
     
        self.title = @"拼音检索";
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ol_bushou.sqlite"];
        FMDatabase *db = [[FMDatabase alloc]initWithPath:path];
        [db open];
        
       
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
            [self.sectionArray addObject:array];
                   }
        [db close];
        if (self.pinyin)
        [self scrollBySelectedIndexCapital:self.pinyin];
    } else {
   
        self.title = @"部首检索";
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ol_bushou.sqlite"];
        FMDatabase *db = [[FMDatabase alloc]initWithPath:path];
        [db open];
        
            for (int i=1;i<=17;i++) {
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
            NSString *bihua = [NSString stringWithFormat:@"%d",i];
            FMResultSet *set=[db executeQuery:@"select * from ol_bushou where bihua=? order by title",bihua];
            while ([set next]) {
                NSDictionary *result = [set resultDictionary];
                NSString *title=[result valueForKey:@"title"];
                [mArray addObject:title];
            }
            NSArray *array = [NSArray arrayWithArray:mArray];
            [self.sectionArray addObject:array];
        }
        
        [db close];
                if(self.selectedIndexStr)
            [self scrollBySelectedIndexStr:self.selectedIndexStr];
        
    }
}
- (void)scrollBySelectedIndexStr:(NSString *)index {

    if (!_pinYinNotBuShou) {
        [self sectionForSectionMJNIndexTitle:index atIndex:[index intValue]-1];
    }
}



@end
