//
//  Test.h
//  FindPath
//
//  Created by VCS Team on 11/2/17.
//  Copyright © 2017 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSAIPathFinding.h"

@interface Test : NSObject

- (void) findPathFrom:(CGPoint)start to:(CGPoint)end;
-(NSArray*)getCommands;
@end
