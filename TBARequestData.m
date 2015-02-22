//
//  RRRRequestData.m
//  NSURLSessionTest
//
//  Created by Jonathan Fox on 9/9/14.
//  Copyright (c) 2014 Reverb.com. All rights reserved.
//

#import "TBARequestData.h"

@implementation TBARequestData

+(NSArray *)requestData {
    NSArray * info = @[];
    
    NSString *locationURL = [NSString stringWithFormat:@"http://reverb.com/api/listings"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationURL]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:nil];
    NSDictionary * data = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    info = data[@"listings"];

    return info;
}

@end
