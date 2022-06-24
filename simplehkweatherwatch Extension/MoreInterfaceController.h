//
//  MoreInterfaceController.h
//  simplehkweather
//
//  Created by carl on 26/4/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface MoreInterfaceController : WKInterfaceController
{
    NSArray *arrayContent;
    
}

@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableDays;
@end
