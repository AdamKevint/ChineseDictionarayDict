//
//  AboutMe.m
//  ChineseDictionary
//
//  Created by AdamKevint on 13-10-8.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import "AboutMe.h"

@interface AboutMe ()
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation AboutMe
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://about.me/adam_kevint"]]];
    
}
@end
