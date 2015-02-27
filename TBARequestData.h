//
//  RRRRequestData.h
//  NSURLSessionTest
//
//  Created by Jonathan Fox on 9/9/14.
//  Copyright (c) 2014 Reverb.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBARequestData : NSObject

+(void)listingsTaskWithCompletion:(void (^)(NSData *data, NSError *error))completionBlock;

@end
