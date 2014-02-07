//
//  twitterTests.m
//  twitterTests
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Tweet.h"
#import "TweetVC.h"


#define MOCKITO_SHORTHAND
#import "OCMockitoIOS/OCMockitoIOS.h"

@interface twitterTests : XCTestCase

@end

@interface twitterTests(){
    TweetVC *sut;
}

@end
@implementation twitterTests

- (void)setUp
{
    [super setUp];
    Tweet *tweet = mock([Tweet class]);
    sut = [[TweetVC alloc]init];
    NSLog(@"hello ");
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
