//
//  TweetVC.m
//  twitter
//
//  Created by Upkar Lidder on 2014-02-01.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetVC.h"
#import "UIImageview+AFNetworking.h"
#import "ComposeTweetVC.h"

@interface TweetVC ()
-(void)configureTweetView;
-(NSDate*)dateFromTweetAttribute:(NSString*)attr;

- (IBAction)onFavPressed:(id)sender;
- (IBAction)onRetweetPressed:(id)sender;
- (IBAction)onReplyPressed:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetUserNameHeight;


@end

@implementation TweetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //load data into fields
    [self configureTweetView];
    
    //hide the retweet view for now. 
    self.retweetViewHeight.constant = 0;
    self.retweetImageHeight.constant = 0;
    self.retweetUserNameHeight.constant = 0;
}

-(void)configureTweetView{
    self.tweetUserNameLabel.text = [NSString stringWithFormat:@"@ %@", [self.tweet screenNameFromTweet]];
    self.tweetUserFullNameLabel.text = [self.tweet usernameFromTweet];
    self.tweetTextLabel.text = [self.tweet valueOrNilForKeyPath:@"text"];
    self.numRetweetsLabel.text = [[self.tweet valueOrNilForKeyPath:@"retweet_count"] stringValue];
    
    NSURL *url = [NSURL URLWithString:[self.tweet imageURLFromTweet]];
    [self.tweetUserImageView setImageWithURL:url];
    self.numFavLabel.text = [[self.tweet valueOrNilForKeyPath:@"favorite_count"] stringValue];
    }

-(NSDate*)dateFromTweetAttribute:(NSString*)attr {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //Wed Dec 01 17:08:03 +0000 2010
    [df setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    NSDate *date = [df dateFromString:attr];
    [df setDateFormat:@"eee MMM dd yyyy"];
    //    NSString *dateStr = [df stringFromDate:date];
    return date;
}

- (IBAction)onFavPressed:(id)sender {
    
    //if already fav, remove it, else fav it
    if(self.tweet.isFavorite == [NSNumber numberWithBool:NO]){
        self.tweet.numFavorite = [NSNumber numberWithInt:[self.tweet.numFavorite intValue]+1];
        self.tweet.isFavorite = [NSNumber numberWithBool:YES];
        [[TwitterClient instance] markFavWithStatus:self.tweet.tweetId success:nil failure:nil];
        [self.tweetFavButton setImage:[UIImage imageNamed:@"Favorite-yellow.png"] forState:UIControlStateNormal];
        
    }
    else{
        self.tweet.numFavorite = [NSNumber numberWithInt:[self.tweet.numFavorite intValue]+1];
        self.tweet.isFavorite = [NSNumber numberWithBool:NO];
        [[TwitterClient instance] markUnFavWithStatus:self.tweet.tweetId success:nil failure:nil];
        [self.tweetFavButton setImage:[UIImage imageNamed:@"Favorite-black.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)onRetweetPressed:(id)sender {
    //if not retweeted, retweet. If already retweeted, do nothing
    if(self.tweet.isRetweeted == [NSNumber numberWithBool:NO]){
        self.tweet.numRetweet = [NSNumber numberWithInt:[self.tweet.numRetweet intValue]+1];
        self.tweet.isRetweeted = [NSNumber numberWithBool:YES];
        [[TwitterClient instance] retweetWithStatus:self.tweet.tweetId success:nil failure:nil];
    }
}

- (IBAction)onReplyPressed:(id)sender {
    
    //compose a new reply using the composeviewcontroller
    
    ComposeTweetVC *composeTweetVC = [[ComposeTweetVC alloc] init];
    composeTweetVC.initialText = [NSString stringWithFormat:@"@%@ ", [self.tweet.user objectForKey:@"screen_name"]];
    composeTweetVC.replyStatusId = self.tweet.tweetId;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:composeTweetVC];
    
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(backPressed:)];
    
    composeTweetVC.navigationItem.leftBarButtonItem = newBackButton;
    
    
    [self presentViewController:navC animated:YES completion:nil];
}

-(void)backPressed: (id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
