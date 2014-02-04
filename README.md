# Twitter clone !

This is a twitter client app built in Objective-C as part of the [Ios CodePath iOS Mobile Bootcamp](http://thecodepath.com/iosbootcamp). The user is able to
* User can sign in using OAuth login flow
* User can view last 20 tweets from their home timeline
* The current signed in user will be persisted across restarts
* In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
* User can compose a new tweet by tapping on a compose button.
* User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
* Retweeting and favoriting increments the favorite and retweet counters.
* After creating a new tweet, a user is able to view it in the timeline immediately without refetching the timeline from the network.
* User can load more tweets once they reach the bottom of the feed using infinite loading.
* User can pull to refresh
* Used icons from [IconFinder](https://www.iconfinder.com/) and [NounProject](http://thenounproject.com/)


<img src="http://i.imgur.com/pZpGrzA.png" height="545" width="320" /> <span>  </span>
<img src="http://i.imgur.com/GtapQ4n.png" height="545" width="320" />
<img src="http://i.imgur.com/oBKxDcZ.png" height="545" width="320" />
<img src="http://i.imgur.com/2NgdQdW.png" height="545" width="320" />

## Tools used
* XCode 5
* XCTest Framework to test various controllers and views
* Twitter API
* AFINetworking and other cocoapods Libraries

##Concepts Learned
* UITableView
* UITableViewDataSource and UITableViewDelegate
* Show error on network error using Toast

## Possible Improvements
* User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
* Show network errors and success as toasts.
* Let the user tweet pictures.

## License

* [Apache Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

## Contributing

Please fork this repository and contribute back using
[pull requests](https://github.com/8indaas/ios-todo/pulls).

Any contributions, large or small, major features, bug fixes, additional
language translations, unit/integration tests are welcomed and appreciated
but will be thoroughly reviewed and discussed.
