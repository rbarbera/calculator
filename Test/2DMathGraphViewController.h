//
//  2DMathGraphViewController.h
//  Test
//
//  Created by Rafa Barbera on 17/10/12.
//  Copyright (c) 2012 Rafa Barberá. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Math2DGraphView.h"

@interface Math2DGraphViewController : UIViewController <Math2dGraphDataSource>
@property (nonatomic, weak) IBOutlet Math2DGraphView *graphView;
@property (nonatomic, strong) id program;
@end
