//
//  CollectionsVC.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-10-8.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import "CollectionsVC.h"
#import "PPRevealSideViewController.h"
#import "ManagedObjectContext.h"
#import "Collections.h"
@interface CollectionsVC ()
@property (strong, nonatomic) NSArray *collectionWords;
@property (copy, nonatomic) NSString *word;
@end

@implementation CollectionsVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.revealSideViewController setTapInteractionsWhenOpened:PPRevealSideInteractionContentView|PPRevealSideInteractionNavigationBar];
    [self arrayFromSqlite];
}
- (void)arrayFromSqlite {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Collections"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    __autoreleasing NSError *error;
   self.collectionWords = [[ManagedObjectContext sharedManagedObjcContext] executeFetchRequest:fetchRequest error:&error];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.collectionWords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pinyinDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Collections *collectionWord = [self.collectionWords objectAtIndex:indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:12];
    label.text = collectionWord.text;
     UILabel *pinyin = (UILabel *)[cell viewWithTag:13];
    pinyin.text = collectionWord.pinyin;
    UILabel *frame = (UILabel *)[cell viewWithTag:14];
    frame.text = collectionWord.frame;
    UILabel *bushou = (UILabel *)[cell viewWithTag:15];
    bushou.text = collectionWord.bushou;
    UILabel *bihua = (UILabel *)[cell viewWithTag:16];
    bihua.text = collectionWord.bihua;
    
    
    cell.tag = indexPath.row;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Collections *collectionWord = [self.collectionWords objectAtIndex:indexPath.row];
    self.word = collectionWord.text;
    [self performSegueWithIdentifier:@"collectPush" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"collectPush"]) {
        [segue.destinationViewController setValue:self.word forKey:@"word"];
    }
}
- (IBAction)delete:(UIBarButtonItem *)sender {
    if (self.tableView.editing == NO) {
        [self.tableView setEditing:YES];
        [sender setTitle:@"完成"];
    } else {
        [self.tableView setEditing:NO];
        [sender setTitle:@"删除"];

        
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //after delete coredata
    
    Collections *deleteWord = [self.collectionWords objectAtIndex:indexPath.row];
 
    [[ManagedObjectContext sharedManagedObjcContext] deleteObject:deleteWord];
    [[ManagedObjectContext sharedManagedObjcContext] save:nil];

    
    [self arrayFromSqlite];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
