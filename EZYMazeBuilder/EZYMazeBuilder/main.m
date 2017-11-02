//
//  main.m
//  EZYMazeBuilder
//
//  Created by Georgi Karapetrov on 11/1/17.
//  Copyright © 2017 Georgi Karapetrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "Uitilities.h"



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:@"/Users/iiliev/Downloads/floor3.png"];
        NSArray *bitmap = [Uitilities RGBAsFromImage:image];
        
//        [Uitilities notPrettyPrintBitmap:bitmap];
        
        NSArray<NSArray <NSNumber *> *> *numberBitmap = [Uitilities convertColorToNumberBitmap:bitmap];
        [Uitilities prettyPrintBitmap:numberBitmap];
    }
    return 0;
}
