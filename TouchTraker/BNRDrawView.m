//
//  BNRDrawView.m
//  TouchTraker
//
//  Created by New on 4/19/14.
//  Copyright (c) 2014 New. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView ()

@property (nonatomic, strong) NSMutableDictionary * linesInProgress;
@property (nonatomic, strong) NSMutableArray * finishedLines;

@end

@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * t in touches)
    {
        CGPoint location = [t locationInView:self];
        
        BNRLine * line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue * key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * t in touches)
    {
        NSValue * key = [NSValue valueWithNonretainedObject:t];
        BNRLine * line = self.linesInProgress[key];
        
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * t in touches)
    {
        NSValue * key = [NSValue valueWithNonretainedObject:t];
        BNRLine * line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch * t in touches)
    {
        NSValue * key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    // add a point where the CGPoint line.begin is located
    [bp moveToPoint:line.begin];
    // add another point at the CGPoint line.end to connect line
    [bp addLineToPoint:line.end];
    // draw that line
    [bp stroke];
}


- (void)drawRect:(CGRect)rect
{
    // Draw finished lines in black
    [[UIColor blackColor] set];
    for (BNRLine * line in self.finishedLines)
    {
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue * key in self.linesInProgress)
    {
        [self strokeLine:self.linesInProgress[key]];
    }
}

@end
