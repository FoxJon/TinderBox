//
//  RRRRequestData.m
//  NSURLSessionTest
//
//  Created by Jonathan Fox on 9/9/14.
//  Copyright (c) 2014 Reverb.com. All rights reserved.
//

#import "TBARequestData.h"

@implementation TBARequestData

+(void)listingsTaskWithCompletion:(void (^)(NSData *data, NSError *error))completionBlock{
    __block NSURLSessionTask *task = nil;
    NSURLSession *session = [NSURLSession sharedSession];
    task = [session dataTaskWithURL:[NSURL URLWithString:@"https://reverb.com/api/listings"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        completionBlock(data, error);
    }];
    [task resume];
}

@end
