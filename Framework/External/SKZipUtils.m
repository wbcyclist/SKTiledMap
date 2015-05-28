//
//  SKZipUtils.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/13.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKZipUtils.h"
#import <zlib.h>


static const NSUInteger ChunkSize = 16384;

@implementation SKZipUtils

+ (NSData *)compress:(NSData *)data withDataFormat:(NSUInteger)format {
    if ([data length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[data length];
        stream.next_in = (Bytef *)[data bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        // LayerDataFormat_Base64Gzip = 3
        int windowBits = (format == 3) ? 15 + 16 : 15;
        if (deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, windowBits, 8, Z_DEFAULT_STRATEGY) == Z_OK)
        {
            NSMutableData *data = [NSMutableData dataWithLength:ChunkSize];
            while (stream.avail_out == 0)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += ChunkSize;
                }
                stream.next_out = (uint8_t *)[data mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    return nil;
}

+ (NSData *)decompress:(NSData *)zipData {
    if ([zipData length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[zipData length];
        stream.next_in = (Bytef *)[zipData bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *deData = [NSMutableData dataWithLength:(NSUInteger)([zipData length] * 1.5)];
        if (inflateInit2(&stream, 47) == Z_OK)
        {
            int status = Z_OK;
            while (status == Z_OK)
            {
                if (stream.total_out >= [deData length])
                {
                    deData.length += [zipData length] / 2;
                }
                stream.next_out = (uint8_t *)[deData mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([deData length] - stream.total_out);
                status = inflate (&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK)
            {
                if (status == Z_STREAM_END)
                {
                    deData.length = stream.total_out;
                    return deData;
                }
            }
        }
    }
    return nil;
}


@end





