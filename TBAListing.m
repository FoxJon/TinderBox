//
//  TBAListing.m
//  TinderBox
//
//  Created by Jonathan Fox on 2/26/15.
//  Copyright (c) 2015 Jon Fox. All rights reserved.
//

#import "TBAListing.h"
#import "TBARequestData.h"
#import "TBAConstants.h"

@interface TBAListing()

@end

@implementation TBAListing

-(void)fetchListingsWithErrorHandler:(void (^)(NSError *error))errorHandler{
    self.makeInfo = [@[]mutableCopy];
    self.modelInfo = [@[]mutableCopy];
    self.photo = [@[]mutableCopy];
    
    [TBARequestData listingsTaskWithCompletion:^(NSData *data, NSError *error) {
        if (error) {
            errorHandler(error);
        }else{
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray * info = json[@"listings"];
            for (NSDictionary *listing in info) {
                NSString *make = listing[@"make"];
                NSString *model = listing[@"model"];
                NSString *photo = listing[@"photos"][0][@"_links"][@"large_crop"][@"href"];
                [self.makeInfo addObject:make];
                [self.modelInfo addObject:model];
                [self.photo addObject:photo];
            }
            dispatch_async(dispatch_get_main_queue(),^{
                [[NSNotificationCenter defaultCenter]postNotificationName:TBAListingDidFinishLoading object:self userInfo:nil];
            });
        }
    }];
}

@end
