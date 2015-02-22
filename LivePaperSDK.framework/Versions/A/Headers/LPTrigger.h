//
//  LPTrigger.h
//  LivePaperSDK
//
//  Created by Steven Say on 2/7/15.
//  Copyright (c) 2015 Hewlett-Packard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPSession.h"

NSString *const LPTriggerErrorDomain;

enum LPTriggerErrorCode {
    Not_Supported = 1
};

@interface LPTrigger : NSObject

+ (void) create:(LPSession *) session json:(NSDictionary *) json completionHandler:(void (^)(LPTrigger *trigger, NSError *error)) handler;

+ (void) createShortUrl:(LPSession *) session name:(NSString *) name startDate:(NSDate *) startDate endDate:(NSDate *) endDate completionHandler:(void (^)(LPTrigger *trigger, NSError *error)) handler;

+ (void) createShortUrl:(LPSession *) session name:(NSString *) name completionHandler:(void (^)(LPTrigger *trigger, NSError *error)) handler;

+ (void) createQrCode:(LPSession *) session name:(NSString *) name startDate:(NSDate *) startDate endDate:(NSDate *) endDate completionHandler:(void (^)(LPTrigger *trigger, NSError *error)) handler;

+ (void) createQrCode:(LPSession *) session name:(NSString *) name completionHandler:(void (^)(LPTrigger *trigger, NSError *error)) handler;

+ (void) createWatermark:(LPSession *) session name:(NSString *) name startDate:(NSDate *) startDate endDate:(NSDate *) endDate image:(UIImage *) image completionHandler:(void (^)(LPTrigger *trigger, NSError *error)) handler;

+ (void) createWatermark:(LPSession *) session name:(NSString *) name image:(UIImage *) image completionHandler:(void (^)(LPTrigger *trigger, NSError *error)) handler;

+ (void) get:(LPSession *) session triggerId:(NSString *) triggerId completionHandler:(void (^)(LPTrigger *trigger, NSError *error)) handler;

+ (void) list:(LPSession *) session completionHandler:(void (^)(NSArray *triggers, NSError *error)) handler;

@property(nonatomic, readonly) NSString *triggerId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, readonly) NSString *type;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSDate *startDate;
@property(nonatomic, retain) NSDate *endDate;
@property(nonatomic, readonly) NSArray *link;
@property(nonatomic, readonly) NSURL *shortURL;
@property(nonatomic, readonly) NSURL *qrCodeImageURL;
@property(nonatomic, readonly) NSURL *watermarkImageURL;

- (BOOL) isShortURL;
- (BOOL) isQrCode;
- (BOOL) isWatermark;
- (BOOL) isActive;

- (void) getQrCodeImage:(void (^)(UIImage *image, NSError *error)) handler;

- (void) getWatermarkImage:(void (^)(UIImage *image, NSError *error)) handler;

- (void) getWatermarkImageWithStrength:(int) strength resolution:(float) resolution completionHandler:(void (^)(UIImage *image, NSError *error)) handler;

- (void) getWatermarkForImageURL:(NSURL *) imageURL strength:(int) strength resolution:(float) resolution completionHandler:(void (^)(UIImage *image, NSError *error)) handler;

- (void) getWatermarkForImage:(UIImage *)image strength:(int) strength resolution:(float) resolution completionHandler:(void (^)(UIImage *image, NSError *error)) handler;

- (void) update:(void (^)(NSError *error)) handler;

- (void) delete:(void (^)(NSError *error)) handler;

@end
