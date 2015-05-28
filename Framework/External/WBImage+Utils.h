//
//  WBImage+Utils.h
//
//  Created by JasioWoo on 15/5/21.
//
//
#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define WBImage UIImage
    #define WBColor UIColor
#else
    #import <AppKit/AppKit.h>
    #define WBImage NSImage
    #define WBColor NSColor
#endif

@interface WBImage (Utils)

-(WBImage *)replacingOccurrencesOfPixel:(WBColor *)tagetColor withColor:(WBColor *)replaceColor;




#if TARGET_OS_IPHONE

#else
- (CGImageRef)CGImage;
#endif


@end
