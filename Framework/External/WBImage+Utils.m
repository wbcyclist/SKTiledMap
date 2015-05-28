//
//  WBImage+Utils.m
//
//  Created by JasioWoo on 15/5/21.
//
//

#import "WBImage+Utils.h"

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

@implementation WBImage (Utils)

- (WBImage *)replacingOccurrencesOfPixel:(WBColor *)tagetColor withColor:(WBColor *)replaceColor {
    
    if (!tagetColor || !replaceColor) {
        return nil;
    }
    CGFloat tr, tg, tb, ta, rr, rg, rb, ra;
    [tagetColor getRed:&tr green:&tg blue:&tb alpha:&ta];
    [replaceColor getRed:&rr green:&rg blue:&rb alpha:&ra];
    
    uint8_t tcr = lroundf(tr * 255);
    uint8_t tcg = lroundf(tg * 255);
    uint8_t tcb = lroundf(tb * 255);
    uint8_t tca = lroundf(ta * 255);
    
    uint8_t rcr = lroundf(rr * 255);
    uint8_t rcg = lroundf(rg * 255);
    uint8_t rcb = lroundf(rb * 255);
    uint8_t rca = lroundf(ra * 255);
    
    uint32_t width = self.size.width;
    uint32_t height = self.size.height;
    //    NSLog(@"convertToColor b: %hhu, g: %hhu, r: %hhu", b, g, r);
    //    NSLog(@"width %d, height %d", width, height);
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t),
                                                 colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    //allocate pixels array
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            //uint32_t color = r * rgbaPixel[RED] + g * rgbaPixel[GREEN] + b * rgbaPixel[BLUE];
            
//            uint8_t rr = rgbaPixel[RED];
//            uint8_t gg = rgbaPixel[GREEN];
//            uint8_t bb = rgbaPixel[BLUE];
//            uint8_t aa = rgbaPixel[ALPHA];
//            NSLog(@"rr: %d, gg: %d, bb: %d, aa: %d",rr, gg, bb, aa);
            
            // set the pixels to the color
            if (rgbaPixel[RED]==tcr && rgbaPixel[GREEN]==tcg && rgbaPixel[BLUE]==tcb && rgbaPixel[ALPHA]==tca) {
                rgbaPixel[RED] = rcr;
                rgbaPixel[GREEN] = rcg;
                rgbaPixel[BLUE] = rcb;
                rgbaPixel[ALPHA] = rca;
            }
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
#if TARGET_OS_IPHONE
    WBImage *resultUIImage = [WBImage imageWithCGImage:imageRef];
#else
    WBImage *resultUIImage = [[WBImage alloc] initWithCGImage:imageRef size:self.size];
#endif
    
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}

#if TARGET_OS_IPHONE

#else

- (CGImageRef)CGImage {
    NSData *imageData = self.TIFFRepresentation;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    return maskRef;
}

#endif


@end
