//
//  TBAListing.h
//  TinderBox
//
//  Created by Jonathan Fox on 2/26/15.
//  Copyright (c) 2015 Jon Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBAListing : NSObject

@property (nonatomic) NSMutableArray * makeInfo;
@property (nonatomic) NSMutableArray * modelInfo;
@property (nonatomic) NSMutableArray * photo;

-(void)fetchListingsWithErrorHandler:(void (^)(NSError *error))errorHandler;

@end
