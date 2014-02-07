//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

NSString * const TWEET_FAVORITE_EVENT = @"TWEET_FAVORITE_EVENT";
NSString * const TWEET_UNFAVORITE_EVENT = @"TWEET_UNFAVORITE_EVENT";

@interface Tweet()
//declare private methods
+(void)printDictionaryForTweet:(NSDictionary*)tweet;

@end


@implementation Tweet


+(void)printDictionaryForTweet:(NSDictionary*)tweet{
    NSArray *keys = [tweet allKeys];
    for(NSString *key in keys){
        id tmp = [tweet objectForKey:key];
        NSLog(@"key: %@; class: %s",key, object_getClassName([tmp class]));
    }
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    //    [self printDictionaryForTweet:array[0]];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

- (NSString*)imageURLFromTweet{
    NSString *result = nil;
    User *user = self.user;
    result = [user valueOrNilForKeyPath:@"profile_image_url"];
    return result;
}

- (NSString*)usernameFromTweet{
    NSString *result = nil;
    User *user = self.user;
    result = [user objectForKey:@"name"];
    return result;
}

- (NSString*)screenNameFromTweet{
    NSString *result = nil;
    User *user = self.user;
    result = [user objectForKey:@"screen_name"];
    return result;
}

//- (NSNumber*)idFromTweet{
//    return [self objectForKey:@"id"];
//}

//overwrite getters and setters for @properties

- (User *)user
{
    return [[User alloc] initWithDictionary:[self.data valueOrNilForKeyPath:@"user"]];
}

- (void)setUser:(User *)user
{
    [self.data setValue:user.data forKey:@"user"];
}

- (NSString *)text
{
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (void)setText:(NSString *)text
{
    [self.data setValue:text forKey:@"text"];
}

- (NSNumber *)numRetweet
{
    return [self.data valueForKey:@"retweet_count"];
}

- (void)setNumRetweet:(NSNumber *)num
{
    [self.data setValue:num forKey:@"retweet_count"];
}

- (NSNumber *)isRetweeted
{
    return [self.data valueForKey:@"retweeted"];
}

- (void)setIsRetweeted:(NSNumber *)isRetweeted
{
    [self.data setValue:[NSNumber numberWithBool:[isRetweeted boolValue]] forKey:@"retweeted"];
}

- (NSNumber *)numFavorite
{
    return [self.data valueForKey:@"favorite_count"];
}

- (void)setNumFavorite:(NSNumber *)numFavorite
{
    NSLog(@"%s", object_getClassName([self.data class]));
    [self.data setValue:numFavorite forKey:@"favorite_count"];
    
}

- (NSNumber *)isFavorite
{
    return [self.data valueForKey:@"favorited"];
}

- (void)setIsFavorite:(NSNumber *)isFav
{
    NSString *eventName = TWEET_FAVORITE_EVENT;
    [self.data setValue:[NSNumber numberWithBool:[isFav boolValue]] forKey:@"favorited"];
    
    if([isFav isEqual:@(0)]){
        
        eventName = TWEET_UNFAVORITE_EVENT;
    }
    
    NSLog(@"Sending %@ event", eventName);
    NSDictionary *dict = @{@"tweet": self};
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName
                                                        object:nil
                                                        userInfo:dict];
}

- (NSString *)tweetId
{
    return [self.data valueOrNilForKeyPath:@"id_str"];
}

- (void)setTweetId:(NSString *)tweetId
{
    [self.data setValue:tweetId forKey:@"id_str"];
}



@end
