//
//  Uitilities.h
//  EZYMazeBuilder
//
//  Created by Georgi Karapetrov on 11/1/17.
//  Copyright © 2017 Georgi Karapetrov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSColor;

@interface Uitilities : NSObject

+ (NSArray*) RGBAsFromImage:(NSImage *)image;
+ (void) prettyPrintBitmap:(NSArray<NSArray <NSNumber *> *> *)bitmap;
+ (void) notPrettyPrintBitmap:(NSArray<NSArray <NSColor *> *> *)bitmap;
+ (NSArray<NSArray <NSNumber *> *> *) convertColorToNumberBitmap:(NSArray<NSArray <NSColor *> *> *)bitmap;

@end
