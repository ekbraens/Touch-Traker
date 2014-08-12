//
//  BNRDrawViewController.m
//  TouchTraker
//
//  Created by New on 4/19/14.
//  Copyright (c) 2014 New. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@implementation BNRDrawViewController

- (void)loadView
{
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

@end
