//
//  main.m
//  FindPath
//
//  Created by VCS Team on 11/2/17.
//  Copyright © 2017 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Test.h"

int main(int argc, const char * argv[]) {
    Test *test = [[Test alloc] init];
    [test findPathFrom:CGPointMake(1, 8) to:CGPointMake(4, 5)];
    
    NSArray *array = [test getCommands];
    NSLog(@"%@",array);
    NSLog(@"--------------------");
    
    
    [test findPathFrom:CGPointMake(4, 5) to:CGPointMake(1,8)];
    array = [test getCommands];
    NSLog(@"%@",array);
    
    return 0;
}

