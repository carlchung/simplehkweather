//
//  DayRow.h
//  simplehkweather
//
//  Created by carl on 27/5/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface DayRow : NSObject


@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelDay;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelTemperature;



@property (weak, nonatomic) IBOutlet WKInterfaceImage *imageIcon;

@property (weak, nonatomic) IBOutlet WKInterfaceGroup *groupInRow;

@end
