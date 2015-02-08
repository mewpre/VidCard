//
//  APIRequest.m
//  LivePaperSample
//
//  Created by Yi-Chin Sun on 2/7/15.
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import "APIRequest.h"

@implementation APIRequest

//Gets access token
+ (void)retrieveAccessTokenWithCompletion:(void(^)(NSString *accessToken))complete
{
    //Making API Call to get authorization key
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    //Set URL for API request
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.livepaperapi.com/auth/v1/token"]]];
    [request setHTTPMethod:@"POST"];

    //Set HTTP Headers
    [request setValue:@"Basic cWRqMjB6dXRqcjZ0Yzc2dzh0dHIzZm05OGZxczR3ajQ6N1g3cGdKS1VlaXc0Zzl2RmJacWZnY1JCUm4wN2tUU2M=" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    //Set HTTP Body
    //Must encode string to NSData using NSASCIIString encoding
    NSData *postData = [@"grant_type=client_credentials&scope=default" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];

    //Make NSURLConnection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"%@", connectionError);
         NSDictionary *authJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         if (authJSON)
         {
             NSString *accessToken = authJSON[@"accessToken"];
             NSLog(@"%@", accessToken);
             complete(accessToken);
         }
     }];
}

+ (void) setVideoURL: (NSString *)vidURL
     withAccessToken: (NSString *)accessToken
      withCompletion: (void(^)(NSString *payoffID))complete
{
    //Making API Call to create payoff with video URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    //Set URL for API request
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.livepaperapi.com/api/v1/payoffs"]]];

    [request setHTTPMethod:@"POST"];

    //Set HTTP Headers
    NSString *authCode = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [request setValue:authCode forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    //Set HTTP Body
    NSDictionary *richPayoffDictionary = @{
                                       @"type": @"content action layout",
                                       @"version": @1,
                                       @"data" : @{
                                               @"analyticId": @"UA-38834658-3",
                                               @"content": @{
                                                       @"type": @"video",
                                                       @"data": @{
                                                               @"URL": vidURL,
                                                               @"fullscreen": @true,
                                                               @"autoplay": @true
                                                               }
                                                       }
                                               },
                                               @"actions": @[@{
                                                                 @"type":@"share",
                                                                 @"label":@"Share!",
                                                                 @"icon":@{@"id":@"527"},
                                                                 @"data":@{@"URL":[NSString stringWithFormat:@"Look at this cool thing! %@", vidURL]}
                                                                 }
                                                              ]
                                       };

    NSData *richJSONData = [NSJSONSerialization dataWithJSONObject:richPayoffDictionary options:0 error:nil];
    NSString *richJSONString = [richJSONData base64EncodedStringWithOptions:0];
    NSDictionary *dictionary = @{
                                 @"payoff":@{
                                         @"name":@"myFirstPayoff",
                                         @"richPayoff":@{
                                                 @"version":@"1.0",
                                                 @"private":@{
                                                         @"content-type":@"custom-base64",
                                                         @"data":richJSONString
                                                         },
                                                 @"public":@{
                                                         @"url":vidURL
                                                         }
                                                 }
                                         }
                                 };
    NSData *finalJSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    [request setHTTPBody:finalJSONData];

    //Make NSURLConnection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSLog(@"%@", connectionError);
//        NSError *error = [NSError new];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        if (error) {
//            NSLog(@"The error: %@", error);
//        }
        if (json)
        {
            NSString *payoffID = json[@"payoff"][@"id"];
            NSLog(@"%@", payoffID);
            complete (payoffID);
        }
    }];
}

//Creates watermark trigger
+ (void) generateWatermark: (NSString *)watermarkName
           withAccessToken: (NSString *)accessToken
             withImageData: (NSData *)image
            withCompletion: (void(^)(NSString *triggerID))complete
{
    //Making API Call to create watermark trigger
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    //Set URL for API request
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.livepaperapi.com/api/v1/triggers"]]];

    [request setHTTPMethod:@"POST"];

    //Set HTTP Headers
    NSString *authCode = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [request setValue:authCode forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    //Set HTTP Body

    NSDictionary *triggerDictionary = @{
                                       @"trigger":@{
                                               @"name":watermarkName,
                                               @"type":@"watermark"
                                               }
                                       };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:triggerDictionary options:0 error:nil];

    [request setHTTPBody:jsonData];

    //Make NSURLConnection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"%@", connectionError);
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         if (json)
         {
             NSString *triggerID = json[@"trigger"][@"id"];
             NSLog(@"%@", triggerID);
             complete (triggerID);
         }
     }];
}

// Uploads image
+ (void)uploadImage: (NSData *)imageData
    withAccessToken: (NSString *)accessToken
     withCompletion: (void(^)(NSString *imageURL))complete
{
    //Making API Call to upload image
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    //Set URL for API request
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://storage.livepaperapi.com/objects/v1/files"]]];

    [request setHTTPMethod:@"POST"];

    //Set HTTP Headers
    NSString *authCode = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [request setValue:authCode forHTTPHeaderField:@"Authorization"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    //Set HTTP Body
    [request setHTTPBody:imageData];

    //Make NSURLConnection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"%@", connectionError);
         NSLog(@"%@", response);
         NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
         NSString *url = headers[@"Location"];
         complete(url);
     }];
}

//Creates the watermarked image
+ (void)createWatermarkedImageFromURL: (NSString *)imageURL
                      withAccessToken: (NSString *)accessToken
                      withWatermarkID: (NSString *)triggerID
                       withCompletion: (void(^)(NSData *imageData))complete
{
    //Making API Call to generate watermarked image
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    //Set URL for API request
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://watermark.livepaperapi.com/watermark/v1/triggers/%@/image?imageUrl=%@", triggerID, imageURL]]];

    [request setHTTPMethod:@"GET"];

    //Set HTTP Headers
    NSString *authCode = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [request setValue:authCode forHTTPHeaderField:@"Authorization"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];

    //Make NSURLConnection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"%@", connectionError);
         NSLog(@"%@", response);
         NSLog(@"%@", data);

         complete (data);
     }];
}

+ (void)createLink: (NSString *)name
   withAccessToken: (NSString *)accessToken
       withTrigger: (NSString *)triggerID
        withPayoff: (NSString *)payoffID
    withCompletion: (void(^)(NSString *linkID))complete

{
    //Making API Call to create payoff with video URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    //Set URL for API request
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.livepaperapi.com/api/v1/links"]]];

    [request setHTTPMethod:@"POST"];

    //Set HTTP Headers
    NSString *authCode = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [request setValue:authCode forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    //Set HTTP Body
    NSDictionary *body = @{
        @"link": @{
            @"name":name,
            @"payoffId":payoffID,
            @"triggerId":triggerID
        }
        };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];

    [request setHTTPBody:jsonData];

    //Make NSURLConnection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"%@", connectionError);
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         if (json)
         {
             NSString *linkID = json[@"link"][@"id"];
             NSLog(@"%@", linkID);
             complete (linkID);
         }
     }];
}

//Dictionary Helper Methods
+ (NSDictionary *)videoPayoffDictionary: (NSString *)videoURL
{
    NSDictionary *dictionary = @{
                                 @"type": @"video",
                                 @"data": @{
                                         @"URL": videoURL,
                                         @"fullscreen": @true,
                                         @"autoplay": @true
                                         }
                                 };
    return dictionary;
}

+ (NSDictionary *)shareActionDictionaryWithMessage: (NSString *)urlString
                                          andLabel: (NSString *)labelString
{
    NSDictionary *dictionary = @{
                                 @"type":@"share",
                                 @"label":labelString,
                                 @"icon":@{@"id":@"527"},
                                 @"data":@{@"URL":urlString}
                                 };
    return dictionary;
}
@end
