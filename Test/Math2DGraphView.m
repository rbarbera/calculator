//
//  Math2DGraphView.m
//  Test
//
//  Created by Rafa Barbera on 17/10/12.
//  Copyright (c) 2012 Rafa Barberá. All rights reserved.
//

#import "Math2DGraphView.h"
#import "AxesDrawer.h"

@implementation Math2DGraphView

@synthesize dataSource = _dataSource;
@synthesize centro = _centro;
@synthesize pointsPerUnit = _pointsPerUnit;

- (CGPoint)centro {
    if((_centro.x==0)&&(_centro.y==0)) {
        _centro = CGPointMake(self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y+self.bounds.size.height/2);
    }
    return _centro;
}

- (void)setCentro:(CGPoint)centro {
    _centro = centro;
    [self setNeedsDisplay];
}

- (void)setPointsPerUnit:(CGFloat)pointsPerUnit {
    _pointsPerUnit = pointsPerUnit;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.centro scale:self.pointsPerUnit];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blueColor] setStroke];
    BOOL firstPoint=YES;
    CGContextBeginPath(ctx);
    for(int wx=0;wx<=self.bounds.size.width*self.contentScaleFactor;wx++) {
        CGFloat x = (wx/self.contentScaleFactor-self.centro.x)/self.pointsPerUnit;
        CGFloat y = [self.dataSource yValueForX:x];
        CGFloat wy = self.centro.y-y*self.pointsPerUnit;
        if (firstPoint) {
            firstPoint = NO;
            CGContextMoveToPoint(ctx, wx/self.contentScaleFactor, wy);
        } else {
            CGContextAddLineToPoint(ctx, wx/self.contentScaleFactor,wy);
        }
    }
    CGContextStrokePath(ctx);

    [[UIColor redColor] setStroke];
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height/2);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height/2);
    CGContextStrokePath(ctx);

    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.bounds.size.width/2, 0);
    CGContextAddLineToPoint(ctx, self.bounds.size.width/2, self.bounds.size.height);
    CGContextStrokePath(ctx);
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint trans = [gesture translationInView:self];
        self.centro = CGPointMake(self.centro.x+trans.x, self.centro.y+trans.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGFloat scale = [gesture scale];
        self.pointsPerUnit = self.pointsPerUnit*scale;
        [gesture setScale:1.0];
    }
}

- (void)tripleTap:(UITapGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint tap = [gesture locationOfTouch:0 inView:self];
        self.centro = tap;
    }
}

- (void)autoZoom:(UITapGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint tap = [gesture locationOfTouch:0 inView:self];
        CGPoint tapReal = CGPointMake((tap.x-self.centro.x)/self.pointsPerUnit, (self.centro.y-tap.y)/self.pointsPerUnit);
        self.pointsPerUnit = 2*self.pointsPerUnit;
        tapReal.x = tapReal.x*self.pointsPerUnit+self.centro.x;
        tapReal.y = tapReal.y*self.pointsPerUnit+self.centro.y;
        CGPoint mid = CGPointMake(self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y+self.bounds.size.height/2);
        self.centro = CGPointMake(-tapReal.x, tapReal.y);
        NSLog(@"%f,%f",tapReal.x,tapReal.y);
    }
}


@end
