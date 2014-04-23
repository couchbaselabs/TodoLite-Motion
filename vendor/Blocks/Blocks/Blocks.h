//
//  Blocks.h
//  Blocks
//
//  Created by Philipp Fehre on 13/05/14.
//  Copyright (c) 2014 couchbase. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBLView;

@interface Blocks : NSObject

+(void)setupListsMapBlockForView:(CBLView*)view;
+(void)setupProfilesMapBlockForView:(CBLView*)view;
+(void)setupTasksMapBlockForView:(CBLView*)view;

@end
