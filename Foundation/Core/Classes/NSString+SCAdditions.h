//
//  NSString+SCAdditions.h
//  SCKit
//
//  Created by Sebastian Celis on 5/16/11.
//  Copyright 2011 Sebastian Celis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCAdditions)

- (BOOL)sc_startsWithString:(NSString *)string;
- (BOOL)sc_endsWithString:(NSString *)string;

@end
