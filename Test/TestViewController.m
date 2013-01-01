//
//  TestViewController.m
//  Test
//
//  Created by Rafa Barberá on 02/10/12.
//  Copyright (c) 2012 Rafa Barberá. All rights reserved.
//

#import "TestViewController.h"
#import "CalculatorBrain.h"
#import "2DMathGraphViewController.h"

@interface TestViewController ()
@property (nonatomic) BOOL isUserEnteringNumber;
@property (strong,nonatomic) CalculatorBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *programDescription;
@property (strong,nonatomic) NSDictionary *variableValues;
@end

@implementation TestViewController
@synthesize display = _display;
@synthesize isUserEnteringNumber = _isUserEnteringNumber;
@synthesize brain = _brain;
@synthesize programDescription = _programDescription;
@synthesize variableValues = _variableValues;

- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void) updateDescriptions {
    self.programDescription.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.isUserEnteringNumber) [self returnPressed];
    [self.brain pushVariable:sender.currentTitle];    
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.variableValues];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    [self updateDescriptions];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;

    if ([digit isEqualToString:@"+/-"]) {
        if(self.isUserEnteringNumber) {
            if ([self.display.text hasPrefix:@"-"]) {
                self.display.text = [self.display.text substringFromIndex:1];
            }
            else self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
        return;
    }

    if ([digit isEqualToString:@"."]) {
        if(self.isUserEnteringNumber) {
            if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
                self.display.text = [self.display.text stringByAppendingString:digit];
            }
        }
        else {
            self.isUserEnteringNumber = YES;
            self.display.text = @"0.";
        }
        return;
    }
    
    if(self.isUserEnteringNumber) self.display.text = [self.display.text stringByAppendingString:digit];
    else {
        self.isUserEnteringNumber = YES;
        self.display.text = digit;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)returnPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateDescriptions];
    self.isUserEnteringNumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    NSString *operator = sender.currentTitle;
    double result = 0;
    
    if ([operator isEqualToString:@"+/-"] && self.isUserEnteringNumber) return;
    if (self.isUserEnteringNumber) [self returnPressed];
    [self.brain pushOperation:operator];
    result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.variableValues];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    [self updateDescriptions];
}
- (IBAction)clear {
    [self.brain clear];
    self.display.text=@"0";
    self.programDescription.text=@"";
    self.isUserEnteringNumber = NO;
}

- (IBAction)undo {
    if (self.isUserEnteringNumber) {
        int oldDisplayTextLength = [self.display.text length];
        self.display.text = [self.display.text substringToIndex:oldDisplayTextLength-1];
        if (oldDisplayTextLength==1) {
            self.display.text = @"0";
            self.isUserEnteringNumber = NO;
        }
    } else {
        double result =[self.brain undoUsingVariableValues:self.variableValues];
        self.display.text = [NSString stringWithFormat:@"%g",result];
    }
    [self updateDescriptions];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        [segue.destinationViewController setProgram:self.brain.program];
    }
}

- (IBAction)ShowGraph {
    NSArray *vc = self.splitViewController.viewControllers;
    [[vc lastObject] setProgram:self.brain.program];
}



- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
