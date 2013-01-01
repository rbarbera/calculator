//
//  CalculatorBrain.m
//  Test
//
//  Created by Rafa Barberá on 03/10/12.
//  Copyright (c) 2012 Rafa Barberá. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (strong,nonatomic) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if(!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program {
    return [self.programStack copy];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

- (void)pushOperation:(NSString *)operation {
    [self.programStack addObject:operation];
}

- (double)undoUsingVariableValues:(NSDictionary *) variableValues
{
    if([self.programStack count]>0)
        [self.programStack removeLastObject];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}


- (void)clear {
    [self.programStack removeAllObjects];
}


+ (double)popTopOfStack:(NSMutableArray *)stack {
    double result=0;
    
    id top = [stack lastObject];
    if(top) [stack removeLastObject];
    
    if ([top isKindOfClass:[NSNumber class]]) {
        result = [top doubleValue];
    }
    
    if ([top isKindOfClass:[NSString class]]) {
        NSString *operation = top;
        
        if([operation isEqualToString:@"+"])
            result = [self popTopOfStack:stack] + [self popTopOfStack:stack];
        else if([operation isEqualToString:@"-"]) {
            double sustraendo = [self popTopOfStack:stack];
            result = [self popTopOfStack:stack] - sustraendo;
        }
        else if([operation isEqualToString:@"*"]) {
            result = [self popTopOfStack:stack] * [self popTopOfStack:stack];
        }
        else if([operation isEqualToString:@"/"]) {
            double divisor = [self popTopOfStack:stack];
            result= [self popTopOfStack:stack] / divisor;
        }
        else if([operation isEqualToString:@"π"]) {
            result = 3.1415926;
        }
        else if([operation isEqualToString:@"e"]) {
            result = 2.71828183;
        }
        else if([operation isEqualToString:@"sin"]) {
            result = sin([self popTopOfStack:stack]);
        }
        else if([operation isEqualToString:@"cos"]) {
            result = cos([self popTopOfStack:stack]);
        }
        else if([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popTopOfStack:stack]);
        }
        else if([operation isEqualToString:@"ln"]) {
            result = log([self popTopOfStack:stack]);
        }
        else if([operation isEqualToString:@"+/-"]) {
            result = -1*[self popTopOfStack:stack];
        }
    }
    
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = program;
    }

    NSSet *operations = [[NSSet alloc] initWithObjects:@"π",@"e",@"sin",@"cos",@"ln",@"sqrt",@"+/-",@"+",@"-",@"*",@"/",nil];
    NSMutableSet *tempSet = [[NSMutableSet alloc] init];
    
    for(id item in stack) {
        if([item isKindOfClass:[NSString class]]) {
            if(![operations containsObject:item]) [tempSet addObject:item];
        }
    }
    if ([tempSet count]>0)
        return [tempSet copy];
    else
        return nil;
}


+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *) variableValue {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSArray *variables = [variableValue allKeys];
    for(int i=0;i<[stack count];i++)
    {
        if([variables containsObject:[stack objectAtIndex:i]]) [stack replaceObjectAtIndex:i withObject:[variableValue objectForKey:[stack objectAtIndex:i]]];
    }
    
    return [self popTopOfStack:stack];
    
}


+ (id)popElement:(NSMutableArray *)stack {
    id val = [stack lastObject];
    if (val) [stack removeLastObject];
    return val;
}

+ (NSString *)parentesis:(id)operand for:(NSString *)operation {
    NSSet *lPrecedence = [[NSSet alloc] initWithObjects:@"+",@"-", nil];
    NSSet *hPrecedence = [[NSSet alloc] initWithObjects:@"/",@"*",@"+/-", nil];
    BOOL needParentesis = NO;
    NSString *op = [NSString stringWithFormat:@"%@",operand];
    
    if ([hPrecedence containsObject:operation]) {
        int protected = 0;
        for(int i=0;i<[op length];i++)
        {
            NSString * ch = [op substringWithRange:NSMakeRange(i,1)];
            if ([ch isEqualToString:@"("]) protected++;
            if ([ch isEqualToString:@")"]) protected--;
            if ([lPrecedence containsObject:ch] && protected<1) {
                needParentesis = YES;
                break;
            }
        }
    }

    if (needParentesis) return [NSString stringWithFormat:@"(%@)",op];
    return op;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSSet *constants =[[NSSet alloc] initWithObjects:@"π",@"e",nil];
    NSSet *func = [[NSSet alloc] initWithObjects:@"sin",@"cos",@"ln",@"sqrt",nil];
    NSSet *unary = [[NSSet alloc] initWithObjects:@"+/-",nil];
    NSSet *binay = [[NSSet alloc] initWithObjects:@"+",@"-",@"*",@"/",nil];
    NSMutableArray *infixStack = [[NSMutableArray alloc] init];

    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }

    for(id item in stack)
    {
        if ([unary containsObject:item]) {
            id next = [self popElement:infixStack];
            if ([next isKindOfClass:[NSNumber class]])
                [infixStack addObject:[NSString stringWithFormat:@"%g",-1*[next doubleValue]]];
            else if ([next isKindOfClass:[NSString class]]) {
                if ([next hasPrefix:@"-"])
                    [infixStack addObject:[next substringFromIndex:1]];
                else [infixStack addObject:[NSString stringWithFormat:@"-%@",
                                            [self parentesis:next for:item]]];
            }
        } else if ([constants containsObject:item]) {
            [infixStack addObject:item];
        } else if ([func containsObject:item]) {
            [infixStack addObject:[NSString stringWithFormat:@"%@(%@)",item,[self popElement:infixStack]]];
        } else if ([binay containsObject:item]) {
            id i1 = [self popElement:infixStack];
            id i2 = [self popElement:infixStack];
            [infixStack addObject:[NSString stringWithFormat:@"%@%@%@",
                                   [self parentesis:i2 for:item]
                                   ,item,
                                   [self parentesis:i1 for:item]]];
        } else [infixStack addObject:item];
    }
    return [infixStack componentsJoinedByString:@","];
}


@end
