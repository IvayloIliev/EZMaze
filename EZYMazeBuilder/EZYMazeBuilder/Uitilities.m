//
//  Uitilities.m
//  EZYMazeBuilder
//
//  Created by Georgi Karapetrov on 11/1/17.
//  Copyright © 2017 Georgi Karapetrov. All rights reserved.
//

#import "Uitilities.h"
#import <AppKit/AppKit.h>
#import <CoreImage/CoreImage.h>

@interface NSImage (WithCGImage)

-(CGImageRef)CGImage;

@end

@implementation NSImage (WithCGImage)

-(CGImageRef)CGImage
{
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    return [self CGImageForProposedRect:&imageRect context:nil hints:nil];
}
@end

@implementation Uitilities

+ (NSArray *)RGBAsFromImage:(NSImage *)image
{
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:height];
    
    NSBitmapImageRep *bitmapRep = [Uitilities bitmapImageRepresentationForImage:image];
    for (int i = 0 ; i < height ; ++i)
    {
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:width];
        for (int j = 0 ; j < width ; ++j)
        {
            NSColor *acolor = [bitmapRep colorAtX:j y:i];
            if (acolor)
            {
                [row addObject:acolor];
            }
        }
        
        [result addObject:row];
    }
    
    return result;
}

+ (NSArray<NSArray <NSNumber *> *> *) convertColorToNumberBitmap:(NSArray<NSArray <NSColor *> *> *)bitmap
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:bitmap.count];
    for (NSArray * row in bitmap)
    {
        NSMutableArray *rowWithNumbers = [NSMutableArray arrayWithCapacity:row.count];
        for (NSColor *color in row)
        {
            [rowWithNumbers addObject:[Uitilities getColorComponentsAsNumber:color]];
        }
        [result addObject:rowWithNumbers];
    }
    
    return result;
}

+ (void) prettyPrintBitmap:(NSArray<NSArray <NSNumber *> *> *)bitmap
{
    for (NSArray * row in bitmap)
    {
        for (NSNumber *number in row)
        {
            NSInteger value = number.integerValue;
//            if (value == 0)
//            {
//                printf(" ");
//            }
//            else
            {
                printf("%ld", (long)value);
            }
        }
        printf("\n");
    }
}

+ (void) notPrettyPrintBitmap:(NSArray<NSArray <NSColor *> *> *)bitmap
{
    for (NSArray * row in bitmap)
    {
        for (NSColor *color in row)
        {
            printf("%s", [[Uitilities getColorComponentsAsString:color] cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        printf("\n");
    }
}

+(const CGFloat *)getColorComponents:(NSColor*)color
{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4)
    {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [NSColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    return CGColorGetComponents(color.CGColor);
}

+(NSString*)getColorComponentsAsString:(NSColor*)color
{
    const CGFloat *components = [Uitilities getColorComponents:color];
    NSString *colorAsString;
    if (components[0] > 0)
    {
        colorAsString = @"2";
    }
    if (components[1] > 0)
    {
        colorAsString = @"3";
    }
    if (components[2] > 0)
    {
        colorAsString = @"4";
    }
    if (components[0] == 0
        && components[1] == 0
        && components[2] == 0)
    {
        colorAsString = @"1";
    }
    if (components[0] == 1
        && components[1] == 1
        && components[2] == 1)
    {
        colorAsString = @" ";
//        colorAsString = @"0";
    }
    
    return colorAsString;
}

+(NSNumber*)getColorComponentsAsNumber:(NSColor*)color
{
    const CGFloat *components = [Uitilities getColorComponents:color];
    NSNumber *colorAsNumber;
    if (components[0] > 0)
    {
        colorAsNumber = @2;
    }
    if (components[1] > 0)
    {
        colorAsNumber = @3;
    }
    if (components[2] > 0)
    {
        colorAsNumber = @4;
    }
    if (components[0] == 0
        && components[1] == 0
        && components[2] == 0)
    {
        colorAsNumber = @1;
    }
    if (components[0] == 1
        && components[1] == 1
        && components[2] == 1)
    {
        colorAsNumber = @0;
    }
    
    return colorAsNumber;
}

+ (NSBitmapImageRep *)bitmapImageRepresentationForImage:(NSImage*)image
{
    int width = image.size.width;
    int height = image.size.height;
    
    if(width < 1 || height < 1)
        return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes: NULL
                             pixelsWide: width
                             pixelsHigh: height
                             bitsPerSample: 8
                             samplesPerPixel: 4
                             hasAlpha: YES
                             isPlanar: NO
                             colorSpaceName: NSDeviceRGBColorSpace
                             bytesPerRow: width * 4
                             bitsPerPixel: 32];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: ctx];
    [image drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositingOperationCopy fraction: 1.0];
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return rep;
}

@end
