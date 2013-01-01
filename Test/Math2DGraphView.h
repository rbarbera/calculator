//
//  Math2DGraphView.h
//  Test
//
//  Created by Rafa Barbera on 17/10/12.
//  Copyright (c) 2012 Rafa Barberá. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Math2dGraphDataSource <NSObject>

- (double) yValueForX:(double) x;

@end

@interface Math2DGraphView : UIView

@property (nonatomic) CGPoint centro;
@property (nonatomic) CGFloat pointsPerUnit;
@property (nonatomic, weak) id <Math2dGraphDataSource> dataSource;
@end
