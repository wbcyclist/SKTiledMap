//
//  SKZipUtils.h
//  SKZipUtils is from the ZipUtils
//
//  Created by JasioWoo on 15/5/13.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

/*
 * Need to include the libz.dylib
 *
 * Based on https://github.com/nicklockwood/GZIP
 */


#import <Foundation/Foundation.h>

@interface SKZipUtils : NSObject

+ (NSData *)compress:(NSData *)data withDataFormat:(NSUInteger)format;
+ (NSData *)decompress:(NSData *)data;

@end


