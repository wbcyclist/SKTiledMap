//
//  SKColor+TMXColorWithHex.m
//  SKTiledMap
//
//  Created by JasioWoo on 15/5/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SKColor+TMXColorWithHex.h"

@implementation SKColor (TMXColorWithHex)

+ (CGFloat) tmxColorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
+ (SKColor*)tmxColorWithHex:(NSString *)hexString {
    if (!hexString) {
        return nil;
    }
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    /*
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [SKColor tmxColorComponentFrom:colorString start:0 length:1];
            green = [SKColor tmxColorComponentFrom: colorString start: 1 length: 1];
            blue  = [SKColor tmxColorComponentFrom: colorString start: 2 length: 1];
            break;
            
        case 4: // #ARGB
            alpha = [SKColor tmxColorComponentFrom: colorString start: 0 length: 1];
            red   = [SKColor tmxColorComponentFrom: colorString start: 1 length: 1];
            green = [SKColor tmxColorComponentFrom: colorString start: 2 length: 1];
            blue  = [SKColor tmxColorComponentFrom: colorString start: 3 length: 1];
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [SKColor tmxColorComponentFrom: colorString start: 0 length: 2];
            green = [SKColor tmxColorComponentFrom: colorString start: 2 length: 2];
            blue  = [SKColor tmxColorComponentFrom: colorString start: 4 length: 2];
            break;
            
        case 8: // #AARRGGBB
            alpha = [SKColor tmxColorComponentFrom: colorString start: 0 length: 2];
            red   = [SKColor tmxColorComponentFrom: colorString start: 2 length: 2];
            green = [SKColor tmxColorComponentFrom: colorString start: 4 length: 2];
            blue  = [SKColor tmxColorComponentFrom: colorString start: 6 length: 2];
            break;
            
        default:
//            NSLog(@"Color value %@ is invalid.", hexString);
            return nil;
    }
     return [SKColor colorWithRed: red green: green blue: blue alpha: alpha];
    */
    
    const char *s = [colorString cStringUsingEncoding:NSASCIIStringEncoding];
    if (*s == '#') {
        ++s;
    }
    unsigned long long value = strtoll(s, nil, 16);
    int r, g, b, a;
    switch (strlen(s)) {
        case 2:
            // xx
            r = g = b = (int)value;
            a = 255;
            break;
        case 3:
            // RGB
            r = ((value & 0xf00) >> 8);
            g = ((value & 0x0f0) >> 4);
            b = ((value & 0x00f) >> 0);
            r = r * 16 + r;
            g = g * 16 + g;
            b = b * 16 + b;
            a = 255;
            break;
        case 6:
            // RRGGBB
            r = (value & 0xff0000) >> 16;
            g = (value & 0x00ff00) >>  8;
            b = (value & 0x0000ff) >>  0;
            a = 255;
            break;
        default:
            // RRGGBBAA
            r = (value & 0xff000000) >> 24;
            g = (value & 0x00ff0000) >> 16;
            b = (value & 0x0000ff00) >>  8;
            a = (value & 0x000000ff) >>  0;
            break;
    }
    return [SKColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}


- (NSString *)hexString {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255),
            lroundf(a * 255)];
}

//- (BOOL)readRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
////    self.colorSpaceName
//}



@end
