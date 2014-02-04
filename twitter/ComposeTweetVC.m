//
//  ComposeTweetVC.m
//  twitter
//
//  Created by Upkar Lidder on 2014-01-28.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeTweetVC.h"
#import "UIImageview+AFNetworking.h"

const int maxTweet = 140;
const int warnLimit = 100;
const int dangerLimit = 130;

@interface ComposeTweetVC ()

@end

@implementation ComposeTweetVC
NSString *tweetDone = @"tweetDone";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addTweetButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [self initWithCoder:aDecoder];
    if(self){
        [self addTweetButton];
        //        [self setBackButton];
    }
    return self;
}

- (void)addTweetButton{
    UIBarButtonItem *tweetBtn = [[UIBarButtonItem alloc]initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(tweetWithString)];
    self.navigationItem.rightBarButtonItem = tweetBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createInputAccessoryView];
    [self.composeTextView setInputAccessoryView:self.inputAccessoryView];
    User *user = [User currentUser];
    //    self.tweetUserFullName
    NSString *url = [user valueOrNilForKeyPath:@"profile_image_url"];
    NSString *userName = [user valueOrNilForKeyPath:@"screen_name"];    NSString *userFullName = [user valueOrNilForKeyPath:@"name"];
    self.tweetUserFullName.text = userFullName;
    self.tweetUserName.text = userName;
    NSURL *urlString = [[NSURL alloc]initWithString:url];
    [self.tweetUserImage setImageWithURL:urlString];
    
    if(self.initialText)
        self.composeTextView.text = self.initialText;

    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self updateComposeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma textview delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    //    [self updateComposeView];
}

- (void)textViewDidChange:(UITextView *)textView{
    [self updateComposeView];
}

#pragma util methods
-(void)createInputAccessoryView{
    self.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 20.0)];
    
    //configure inputaccessory
    //    [self.inputAccessoryView setBackgroundColor:[UIColor colorWithRed:121.0/255.0 green:222.0/255.0 blue:237.0/255.0 alpha:1]];
    self.inputAccessoryView.layer.borderColor = [UIColor blueColor].CGColor;
    self.inputAccessoryView.layer.borderWidth = 1.0f;
    
    
    self.charCount = [[UILabel alloc]init];
    //set autolayout to off, will do this manually in the code
    self.charCount.translatesAutoresizingMaskIntoConstraints = NO;
    [self.charCount setFrame:CGRectMake(270.0, 0.0f, 80.0f, 20.0f)];
    [self.charCount setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    
    [self.inputAccessoryView addSubview:self.charCount];
    
    //auto layout the label so that it is -10 from the right edge of the screen
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:self.charCount
                                       attribute:NSLayoutAttributeTrailing
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.inputAccessoryView
                                       attribute:NSLayoutAttributeTrailing
                                       multiplier:1.0
                                       constant:-10];
    
    [self.inputAccessoryView addConstraint:myConstraint];
    
}

-(void)updateTweetCount{
    NSString *tweet = self.composeTextView.text;
    if(tweet){
        
        
        if(tweet.length >= dangerLimit)
            self.charCount.textColor = [UIColor redColor];
        else
            self.charCount.textColor = [UIColor blueColor];
        
        self.charCount.text = [NSString stringWithFormat:@"%d", maxTweet - tweet.length];
    }
    else
        self.charCount.text = @("0");
}

-(void)updateComposeView{
    [self updateTweetCount];
    self.navigationItem.rightBarButtonItem.enabled = TRUE;
    if(self.composeTextView && (self.composeTextView.text.length <= 0 || self.composeTextView.text.length > 140))
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
}

-(void)tweetWithString{
    NSString *content = self.composeTextView.text;
    if(content){
        
        Tweet *newTweet = [[Tweet alloc] initWithDictionary:[[NSMutableDictionary alloc] init]];
        newTweet.text = content;
        newTweet.user = [User currentUser];
        newTweet.createdAt = [NSDate date];
        newTweet.numRetweet = [NSNumber numberWithInt:0];
        newTweet.isFavorite = NO;
        newTweet.numFavorite = [NSNumber numberWithInt:0];
        newTweet.isFavorite = NO;
        
//        [[TwitterClient instance] updateStatusWithString:content replyStatusId:self.replyStatusId success:^(AFHTTPRequestOperation *operation, id response) {
//            //create a new Tweet model and send back with notification to anybody listening
//            NSLog(@"tweet posted successfully");
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"fail ! %@", error);
//        }];
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setObject:newTweet forKey:tweetDone];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:tweetDone
         object:nil
         userInfo:userInfo];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
