//
//  ComposeTweetVC.h
//  twitter
//
//  Created by Upkar Lidder on 2014-01-28.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeTweetVC : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;

@property (nonatomic, retain) UIView *inputAccessoryView;
@property (nonatomic, retain) UIButton *btnDone;
@property (nonatomic, retain) UILabel *charCount;

@property (weak, nonatomic) IBOutlet UIImageView *tweetUserImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserName;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserFullName;


@property (nonatomic, strong) NSString *replyStatusId;
@property (nonatomic, strong) NSString *initialText;

@end
