//
//  CalculatorBrain.h
//  Test
//
//  Created by Rafa Barberá on 03/10/12.
//  Copyright (c) 2012 Rafa Barberá. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable;
- (void)pushOperation:(NSString *)variable;
- (double)undoUsingVariableValues:(NSDictionary *) variableValues;
- (void)clear;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *) variableValue;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
@end
