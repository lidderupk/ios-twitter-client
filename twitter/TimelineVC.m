//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "UIImageview+AFNetworking.h"
#import "ComposeTweetVC.h"
#import "TweetVC.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, retain) NSNumber* currentSinceId;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, strong) TweetCell *prototypeCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetViewHeight;

- (void)onSignOutButton;
- (void)reload;
-(void) configureCell:(TweetCell*)cell forIndexPath:(NSIndexPath*)indexPath isForOffscreenUse:(BOOL)isForOffscreenUse;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Twitter";
        self.currentSinceId = [[NSNumber alloc]init];
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    UINib *uiNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:uiNib forCellReuseIdentifier:@"TweetCell"];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposePressed:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tweetPosted:)
                                                 name:@"tweetDone"
                                               object:nil];
    
    self.retweetViewHeight.constant = 0;
    
}

- (void)tweetPosted:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    Tweet *newTweet = [userInfo objectForKey:@"tweetDone"];
    [self.tweets insertObject:newTweet atIndex:0];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath isForOffscreenUse:NO];
    
    //if at bottom, get the next set of tweets
    if (indexPath.row == [self.tweets count] - 1){
        NSLog(@"reloading data ... ");
        [self reloadNext];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //get the height for each item and add to get final size
    
    CGFloat topMargin = 10.0;
    CGFloat userNameLabelHeight = 16;
    CGFloat imageHeight = 42;
    CGFloat buttonHeight = 24;
    
    Tweet *tweet = self.tweets[indexPath.row];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0], NSFontAttributeName, nil];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tweet.text attributes:attributes];
    
    CGSize constraint = CGSizeMake(234.0f - 8.0f, CGFLOAT_MAX);
    CGSize size = [attributedString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;

    
    CGFloat totalHeight = topMargin *3 + buttonHeight + userNameLabelHeight + size.height;
    return MAX(totalHeight, imageHeight);
}

-(void) configureCell:(TweetCell*)cell forIndexPath:(NSIndexPath*)indexPath isForOffscreenUse:(BOOL)isForOffscreenUse{
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweetText.text = tweet.text;
    NSURL *url = [NSURL URLWithString:[tweet imageURLFromTweet]];
    [cell.tweetImageView setImageWithURL:url];
    cell.tweetImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.tweetUserName.text = [tweet usernameFromTweet];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelectRowAtIndexPath");
    TweetVC* tweetViewController = [[TweetVC alloc] initWithNibName:@"TweetVC" bundle:[NSBundle mainBundle]];
    tweetViewController.tweet = self.tweets[indexPath.row];
    [self setSelfBackButtonWithString:@"Home"];
    [self.navigationController pushViewController:tweetViewController animated:YES];

}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        self.tweets = [Tweet tweetsWithArray:response];
        Tweet *lastTweet = self.tweets[self.tweets.count - 1];
        
        NSLog(@"reload last tweet: %@", lastTweet.text);

        self.currentSinceId = [NSNumber numberWithInt:[lastTweet.tweetId integerValue]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"unable to fetch tweets: %@", error);
    }];
    [self.refreshControl endRefreshing];
}

- (void)reloadNext {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:[self.currentSinceId intValue] maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *moreTweets = [Tweet tweetsWithArray:response];
        [self.tweets addObjectsFromArray:moreTweets];
        Tweet *lastTweet = self.tweets[self.tweets.count - 1];
        NSLog(@"reloadNext last tweet: %@", lastTweet.text);
        self.currentSinceId = [NSNumber numberWithInt:[lastTweet.tweetId integerValue]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

- (IBAction)onComposePressed:(id)sender {
    ComposeTweetVC* composeViewController = [[ComposeTweetVC alloc] initWithNibName:@"ComposeTweetVC" bundle:[NSBundle mainBundle]];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    
    composeViewController.initialText = @"";
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(backPressed:)];
    
    composeViewController.navigationItem.leftBarButtonItem = newBackButton;
    
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)setSelfBackButtonWithString:(NSString*)title{
    
    if(title){
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:title
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
    }
}

-(void)backPressed: (id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
