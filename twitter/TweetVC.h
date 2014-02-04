//
//  TweetVC.h
//  twitter
//
//  Created by Upkar Lidder on 2014-02-01.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *isRetweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *isRetweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserFullNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *numRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFavLabel;

@property (weak, nonatomic) IBOutlet UIButton *tweetReplyButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetRetweetButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetFavButton;

@property (nonatomic, strong) Tweet* tweet;

@property (nonatomic, strong) NSString *initialText;

@end
