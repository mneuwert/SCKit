//
//  NSString+SCAdditions.m
//  SCKit
//
//  Created by Sebastian Celis on 5/16/11.
//  Copyright 2011 Sebastian Celis. All rights reserved.
//

#import "NSString+SCAdditions.h"

@implementation NSString (SCAdditions)

- (BOOL)sc_startsWithString:(NSString *)string
{
    NSRange range = [self rangeOfString:string options:NSAnchoredSearch];
    return (range.location != NSNotFound);
}

- (BOOL)sc_endsWithString:(NSString *)string
{
    NSRange range = [self rangeOfString:string options:NSAnchoredSearch | NSBackwardsSearch];
    return (range.location != NSNotFound);
}

@end
