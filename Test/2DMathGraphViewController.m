//
//  2DMathGraphViewController.m
//  Test
//
//  Created by Rafa Barbera on 17/10/12.
//  Copyright (c) 2012 Rafa Barberá. All rights reserved.
//

#import "2DMathGraphViewController.h"
#import "CalculatorBrain.h"

@interface Math2DGraphViewController ()

@end

@implementation Math2DGraphViewController

@synthesize graphView = _graphView;
@synthesize program = _program;

- (void) setProgram:(id)program {
    _program = program;
    self.title = [CalculatorBrain descriptionOfProgram:self.program];
    [self.graphView setNeedsDisplay];
}

- (void) setGraphView:(Math2DGraphView *)graphView {
    _graphView = graphView;
    self.graphView.pointsPerUnit = 30.0f;
    self.graphView.centro = CGPointMake(self.graphView.bounds.origin.x+self.graphView.bounds.size.width/2.0,
                                        self.graphView.bounds.origin.y+self.graphView.bounds.size.height/2.0);

    self.graphView.dataSource = self;
    UIPanGestureRecognizer *panr = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)];
    UIPinchGestureRecognizer *pinchr = [[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)];
    UITapGestureRecognizer *tapr = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    tapr.numberOfTapsRequired = 3;
    UITapGestureRecognizer *autozoomr = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(autoZoom:)];
    autozoomr.numberOfTapsRequired = 2;
    [self.graphView addGestureRecognizer:tapr];
    [self.graphView addGestureRecognizer:panr];
    [self.graphView addGestureRecognizer:pinchr];
    [self.graphView addGestureRecognizer:autozoomr];
}

-(double) yValueForX:(double) x {
    NSNumber * xVal = [[NSNumber alloc] initWithDouble:x];
    return [CalculatorBrain runProgram:self.program usingVariableValues:@{@"x": xVal}];
}

@end
