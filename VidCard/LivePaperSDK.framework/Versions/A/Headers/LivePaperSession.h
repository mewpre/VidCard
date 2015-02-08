//
//  LivePaperService.h
//  LinkSampleApp
//
//  Created by Steven Say on 2/5/15.
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LivePaperSession : NSObject

+ (instancetype)createSessionWithClientID:(NSString *) clientID secret:(NSString *) secret;

- (void) createShortUrl:(NSString *) name destination:(NSURL *) url completionHandler:(void (^)(NSURL *shortUrl, NSError *error)) handler;

- (void) createQrCode:(NSString *) name destination:(NSURL *) url completionHandler:(void (^)(UIImage *qrCodeImage, NSError *error)) handler;

- (void) createWatermark:(NSString *) name destination:(NSURL *) url image:(UIImage*) image completionHandler:(void (^)(UIImage *watermarkedImage, NSError *error)) handler;

- (void) createWatermark:(NSString *) name destination:(NSURL *) url imageURL:(NSURL *) imageURL completionHandler:(void (^)(UIImage *watermarkedImage, NSError *error)) handler;

@end
