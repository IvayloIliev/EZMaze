//
//  Test.m
//  FindPath
//
//  Created by VCS Team on 11/2/17.
//  Copyright © 2017 test. All rights reserved.
//

#import "Test.h"
#import "Pair.h"

#define row 10
#define column 10

#define COMMAND_LEFT @"left"
#define COMMAND_RIGHT @"right"
#define COMMAND_MOVE @"move"

#define POSITION_TOP 0
#define POSITION_RIGHT 1
#define POSITION_BOT 2
#define POSITION_LEFT 3


@interface Test() <HSAIPathFindingDelegate>
@property (strong, nonatomic) NSArray *maze;
@property (strong, nonatomic) NSMutableArray *result;
@property (strong, nonatomic) NSMutableArray *commands;
@property CGPoint startPoint;
@property int facingPosition;
@end


@implementation Test

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.maze = @[
                          @[ @1, @1, @1, @1, @1, @1, @1, @1, @1, @1],
                          @[ @1, @0, @1, @1, @1, @1, @1, @1, @0, @1],
                          @[ @1, @0, @0, @1, @1, @1, @1, @1, @1, @1],
                          @[ @1, @0, @1, @1, @0, @0, @0, @0, @0, @1],
                          @[ @1, @1, @1, @1, @0, @1, @1, @0, @0, @1],
                          @[ @1, @0, @0, @1, @2, @1, @0, @1, @0, @1],
                          @[ @1, @1, @1, @1, @0, @0, @1, @0, @0, @1],
                          @[ @1, @0, @0, @0, @0, @1, @1, @1, @1, @1],
                          @[ @1, @3, @0, @0, @0, @0, @0, @0, @0, @1],
                          @[ @1, @1, @1, @1, @1, @1, @1, @1, @1, @1],
                          ];
        self.facingPosition = POSITION_TOP;
    }
    
    return self;
}

- (void) findPathFrom:(CGPoint)start to:(CGPoint)end
{
    self.startPoint = start;
    self.result = [[NSMutableArray alloc] init];
    self.commands = [[NSMutableArray alloc] init];
    
    HSAIPathFinding *pathFinder = [[HSAIPathFinding alloc] init];
    pathFinder.delegate = self;
    pathFinder.heuristic = [HSAIPathFindingHeuristic diagonalHeuristic];
    
    [pathFinder findPathFrom: start to: end]; // returns an array of HSAIPathFindingNodes
}

- (BOOL) nodeIsPassable: (HSAIPathFindingNode *) node
{
    NSArray *curentRow = [self.maze objectAtIndex:node.point.y];
    NSNumber *value = [curentRow objectAtIndex:node.point.x];
    
    return value.integerValue != 1;
}

- (NSArray *) neighborsFor: (HSAIPathFindingNode *) node
{
    NSMutableArray *neighbors = [[NSMutableArray alloc] init];
    // The logic you use to figure out neighbors
    if (node.point.x < row -1)
    {
        CGPoint neighborPoint = CGPointMake(node.point.x+1, node.point.y);
        [neighbors addObject:[[HSAIPathFindingNode alloc] initWithPosition:neighborPoint]];
    }
    if (node.point.x > 0)
    {
        CGPoint neighborPoint = CGPointMake(node.point.x-1, node.point.y);
        [neighbors addObject:[[HSAIPathFindingNode alloc] initWithPosition:neighborPoint]];
    }
    if (node.point.y > 0)
    {
        CGPoint neighborPoint = CGPointMake(node.point.x, node.point.y-1);
        [neighbors addObject:[[HSAIPathFindingNode alloc] initWithPosition:neighborPoint]];
    }
    if (node.point.y < column -1)
    {
        CGPoint neighborPoint = CGPointMake(node.point.x, node.point.y+1);
        [neighbors addObject:[[HSAIPathFindingNode alloc] initWithPosition:neighborPoint]];
    }
    
    return neighbors;
}

-(void)nodeWasAddedToPath:(HSAIPathFindingNode *)node {
    [self.result addObject:node];
}

-(NSArray*)getCommands {
    self.commands = [[NSMutableArray alloc] init];
    CGPoint currentPoint = self.startPoint;
    
    for (int i = (int)self.result.count - 1; i >= 0; i--) {
        HSAIPathFindingNode *node = [self.result objectAtIndex:i];
        CGPoint nodePoint = node.point;
        [self rotate:nodePoint andCurrentPoint:currentPoint];
        currentPoint = nodePoint;
        [self.commands addObject:COMMAND_MOVE];
    }
    return [self getMergedCommands:self.commands];
}

-(NSArray*) getMergedCommands:(NSArray*)commands {
    NSMutableArray<Pair *> *mergedCommands = [[NSMutableArray alloc] init];
    
    Pair *pair;
    for (NSString *command in commands) {
        Pair *lastPair = [mergedCommands lastObject];
        if(![command isEqual:lastPair.second]) {
            pair = [[Pair alloc] init];
            pair.first = 1;
            pair.second = command;
            [mergedCommands addObject:pair];
            continue;
        } else {
            lastPair.first++;
        }
    }
    return mergedCommands;
}

-(void) rotate:(CGPoint) nodePoint andCurrentPoint:(CGPoint) currentPoint {

    while(currentPoint.x < nodePoint.x && self.facingPosition != POSITION_RIGHT) {
        [self rotateRight];
        [self.commands addObject:COMMAND_RIGHT];
    }
    
    while(currentPoint.x > nodePoint.x && self.facingPosition != POSITION_LEFT) {
        [self rotateRight];
        [self.commands addObject:COMMAND_RIGHT];
    }
    
    while(currentPoint.y > nodePoint.y && self.facingPosition != POSITION_TOP) {
        [self rotateLeft];
        [self.commands addObject:COMMAND_LEFT];
    }
    
    while(currentPoint.y < nodePoint.y && self.facingPosition != POSITION_BOT) {
        [self rotateLeft];
        [self.commands addObject:COMMAND_LEFT];
    }
}

-(void) rotateRight {
    self.facingPosition++;
    if(self.facingPosition > 3) {
        self.facingPosition = 0;
    }
}

-(void) rotateLeft {
    self.facingPosition--;
    if(self.facingPosition < 0) {
        self.facingPosition = 3;
    }
}

-(void)printMaze {
            for (int i = 0; i < row; i++) {
                for (int k = 0; k < column; k++) {
                    printf("%d ",[(NSNumber*)self.maze[i][k] intValue]);
                }
                printf("\n");
            }
}

@end
