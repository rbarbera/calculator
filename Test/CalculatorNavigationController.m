//
//  CalculatorNavigationController.m
//  Calculator
//
//  Created by Rafa Barberá Córdoba on 19/10/12.
//  Copyright (c) 2012 Rafa Barberá. All rights reserved.
//

#import "CalculatorNavigationController.h"

@interface CalculatorNavigationController ()

@end

@implementation CalculatorNavigationController

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

@end
