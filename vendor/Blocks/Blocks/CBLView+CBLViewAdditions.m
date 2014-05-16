//
//  CBLView+CBLViewAdditions.m
//  Blocks
//
//  Created by Philipp Fehre on 16/05/14.
//  Copyright (c) 2014 couchbase. All rights reserved.
//

#import "CBLView+CBLViewAdditions.h"

@implementation CBLView (CBLViewAdditions)

-(BOOL)hasMapBlock
{
  return !!self.mapBlock;
}

@end
