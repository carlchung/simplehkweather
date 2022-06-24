//
//  ComplicationController.h
//  simplehkweatherwatch Extension
//
//  Created by carl on 18/3/2016.
//  Copyright © 2016 carl. All rights reserved.
//

#import <ClockKit/ClockKit.h>
//#import "ExtensionDelegate.h"

@interface ComplicationController : NSObject <CLKComplicationDataSource>

@property (strong,nonatomic) NSString *tempDegree;
@property (strong,nonatomic) NSString *weatherDesc;


@end
