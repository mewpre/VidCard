//
//  APIRequest.h
//  LivePaperSample
//
//  Created by Yi-Chin Sun on 2/7/15.
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequest : NSObject

+ (void)retrieveAccessTokenWithCompletion:(void(^)(NSString *accessToken))complete;

+ (void) setVideoURL: (NSString *)vidURL
     withAccessToken: (NSString *)accessToken
      withCompletion: (void(^)(NSString *payoffID))complete;

+ (void) generateWatermark: (NSString *)watermarkName
           withAccessToken: (NSString *)accessToken
             withImageData: (NSData *)image
            withCompletion: (void(^)(NSString *triggerID))complete;

+ (void)uploadImage: (NSData *)imageData
    withAccessToken: (NSString *)accessToken
     withCompletion: (void(^)(NSString *imageURL))complete;

+ (void)createWatermarkedImageFromURL: (NSString *)imageURL
                      withAccessToken: (NSString *)accessToken
                      withWatermarkID: (NSString *)triggerID
                       withCompletion: (void(^)(NSData *imageData))complete;

+ (void)createLink: (NSString *)name
   withAccessToken: (NSString *)accessToken
       withTrigger: (NSString *)triggerID
        withPayoff: (NSString *)payoffID
    withCompletion: (void(^)(NSString *linkID))complete;




@end
