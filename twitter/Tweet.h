//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : RestObject

@property (nonatomic, strong) NSString *text;
//@property (nonatomic, assign) NSNumber* sinceID;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;
- (NSString*)imageURLFromTweet;
- (NSString*)usernameFromTweet;
//- (NSNumber*)idFromTweet;
- (NSString*)screenNameFromTweet;

//additional properties
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) NSNumber* isRetweeted;
@property (nonatomic, assign) NSNumber* isFavorite;
@property (nonatomic, strong) NSNumber *numRetweet;
@property (nonatomic, strong) NSNumber *numFavorite;
@property (nonatomic, strong) NSString *tweetId;
    
@end
