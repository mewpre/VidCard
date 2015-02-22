//
//  LPSession.h
//  LivePaperSDK
//
//  Created by Steven Say on 2/5/15.
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LPSession : NSObject

+ (instancetype)createSessionWithClientID:(NSString *) clientID secret:(NSString *) secret;

@property (readonly, retain) NSString *accessToken;

- (void) retrieveAccessToken:(void (^)(NSString *accessToken, NSError *error)) handler;

// Quick Start
- (void) createShortUrl:(NSString *) name destination:(NSURL *) url completionHandler:(void (^)(NSURL *shortUrl, NSError *error)) handler;

- (void) createQrCode:(NSString *) name destination:(NSURL *) url completionHandler:(void (^)(UIImage *qrCodeImage, NSError *error)) handler;

- (void) createWatermark:(NSString *) name destination:(NSURL *) url image:(UIImage*) image completionHandler:(void (^)(UIImage *watermarkedImage, NSError *error)) handler;

- (void) createWatermark:(NSString *) name destination:(NSURL *) url imageURL:(NSURL *) imageURL completionHandler:(void (^)(UIImage *watermarkedImage, NSError *error)) handler;

- (void) createWatermark:(NSString *) name richPayoffData:(NSDictionary *) richPayoffData publicURL:(NSURL *) publicURL image:(UIImage *) image completionHandler:(void (^)(UIImage *watermarkedImage, NSError *error)) handler;

- (void) createWatermark:(NSString *) name richPayoffData:(NSDictionary *) richPayoffData publicURL:(NSURL *) publicURL imageURL:(NSURL *) imageURL completionHandler:(void (^)(UIImage *watermarkedImage, NSError *error)) handler;

// Image Store
- (void) getImage:(NSURL *)url completionHandler:(void (^)(UIImage *image, NSError *error))handler;

- (void) uploadImage:(UIImage *)image completionHandler:(void (^)(NSURL *url, NSError *error))handler;

@end
