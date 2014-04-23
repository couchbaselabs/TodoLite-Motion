//
//  Blocks.m
//  Blocks
//
//  Created by Philipp Fehre on 13/05/14.
//  Copyright (c) 2014 couchbase. All rights reserved.
//

#import "Blocks.h"
#import <CouchbaseLite/CouchbaseLite.h>

@implementation Blocks

+(void)setupListsMapBlockForView:(CBLView*)view
{
  if (!view.mapBlock) {
    [view setMapBlock: MAPBLOCK({
      if ([doc[@"type"] isEqualToString:@"list"])
        emit(doc[@"title"], nil);
    }) reduceBlock: nil version: @"1"];
  }
}

+(void)setupProfilesMapBlockForView:(CBLView*)view
{
  if (!view.mapBlock) {
    [view setMapBlock: MAPBLOCK({
      if ([doc[@"type"] isEqualToString:@"profile"])
        emit(doc[@"title"], nil);
    }) reduceBlock: nil version: @"1"];
  }
}

+(void)setupTasksMapBlockForView:(CBLView*)view
{
  if (!view.mapBlock) {
    [view setMapBlock: MAPBLOCK({
      if ([doc[@"type"] isEqualToString:@"task"]) {
        id date = doc[@"created_at"];
        NSString* listID = doc[@"list_id"];
        emit(@[listID, date], nil);
      }
    }) reduceBlock: nil version: @"1"];
  }
}

@end
