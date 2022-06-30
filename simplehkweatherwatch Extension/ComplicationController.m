//
//  ComplicationController.m
//  simplehkweatherwatch Extension
//
//  Created by carl on 18/3/2016.
//  Copyright © 2016 carl. All rights reserved.
//

#import "ComplicationController.h"

#define kRSS_URL_CurrentWeather @"http://rss.weather.gov.hk/rss/CurrentWeather.xml"
#define kRSS_URL_LocalWeatherForecast @"http://rss.weather.gov.hk/rss/LocalWeatherForecast.xml"

@interface ComplicationController ()

@end

@implementation ComplicationController
//
//-(void)callAPI {
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_CurrentWeather]
//            completionHandler:^(NSData *data,
//                                NSURLResponse *response,
//                                NSError *error) {
//                // handle response
//                //
//                NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
//
//                //NSLog(@"requestedUpdateDidBegin Complication:\n%@",dataString);
//                //NSLog(@"error %@", [error description]);
//
//                NSRange rangeAirTemp = [dataString rangeOfString:@"Air temperature : "];
//
//                if ( rangeAirTemp.location == NSNotFound ) {
//                    return;
//                } else {
//                    NSRange rangeAirTempNum = { rangeAirTemp.location + rangeAirTemp.length, 2};
//                    self.tempDegree = [dataString substringWithRange: rangeAirTempNum];
//                    self.tempDegree = [self.tempDegree stringByAppendingString:@"°C"];
//                }
//
//                NSLog(@"requestedUpdateDidBegin Complication:\n%@",self.tempDegree);
//
//                //
//                [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_LocalWeatherForecast]
//                        completionHandler:^(NSData *data,
//                                            NSURLResponse *response,
//                                            NSError *error) {
//                            
//                            NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
//                            
//                            NSLog(@"requestedUpdateDidBegin Complication 2 :\n%@",dataString);
//                            
//                            //
//                            NSRange rangeForecast = [dataString rangeOfString:@"Weather forecast for this afternoon and tonight:<br/>"];
//                            
//                            if ( rangeForecast.location == NSNotFound ) {
//                                rangeForecast = [dataString rangeOfString:@"Weather forecast for tonight and tomorrow:<br/>"];
//                                
//                                if ( rangeForecast.location == NSNotFound ) {
//                                    rangeForecast = [dataString rangeOfString:@":<br/>"];
//                                    if ( rangeForecast.location == NSNotFound ) {
//                                        NSLog(@"FORCAST NOT FOUND");
//                                        return;
//                                    }
//                                }
//                            }
//                            
//                            long rangeLength = dataString.length - (rangeForecast.location + rangeForecast.length) - 5;
//                            
//                            NSRange rangeForecastText = { rangeForecast.location + rangeForecast.length, rangeLength};
//                            NSString *strForecast = [dataString substringWithRange: rangeForecastText];
//                            self.weatherDesc = [[NSBundle mainBundle] localizedStringForKey:[self detectWeatherType:strForecast] value:@"" table:nil];
//                            
//                            
//                        }] resume];
//
//            }] resume];
//
//
//    
//}

//- (void)requestedUpdateDidBegin {
//
//    [self callAPI];
//
//
//    if ( !self.tempDegree) {
//        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//        NSString *strTempDefault = [userdefault objectForKey:@"tempDegree"];
//        if ( strTempDefault ) {
//            self.tempDegree = [strTempDefault stringByAppendingString:@"°C"];
//        } else {
//            self.tempDegree = @"--°C";
//        }
//
//    }
//    //weatherDesc
//    if ( !self.weatherDesc) {
//        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//        NSString *strTempDefault = [userdefault objectForKey:@"weatherDesc"];
//        if ( strTempDefault ) {
//            self.weatherDesc = strTempDefault;
//        } else {
//            self.weatherDesc = @"LOADING";
//        }
//
//    }
//
//    CLKComplicationServer *complicationServer = [CLKComplicationServer sharedInstance];
//
//    for (CLKComplication *complication in complicationServer.activeComplications) {
//        [complicationServer extendTimelineForComplication:complication];
//    }
//
//}
//


#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionNone );
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler([NSDate date]);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler([NSDate date]);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_CurrentWeather]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                //
                NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                
                //NSLog(@"requestedUpdateDidBegin Complication:\n%@",dataString);
                //NSLog(@"error %@", [error description]);
                
                NSRange rangeAirTemp = [dataString rangeOfString:@"Air temperature : "];
                
                if ( rangeAirTemp.location == NSNotFound ) {
                    return;
                } else {
                    NSRange rangeAirTempNum = { rangeAirTemp.location + rangeAirTemp.length, 2};
                    self.tempDegree = [dataString substringWithRange: rangeAirTempNum];
                    self.tempDegree = [self.tempDegree stringByAppendingString:@"°C"];
                }
                
                NSLog(@"requestedUpdateDidBegin Complication:\n%@",self.tempDegree);
                
                //
                [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_LocalWeatherForecast]
                        completionHandler:^(NSData *data,
                                            NSURLResponse *response,
                                            NSError *error) {
                            
                            NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                            
                            NSLog(@"requestedUpdateDidBegin Complication 2 :\n%@",dataString);
                            
                            //
                            NSRange rangeForecast = [dataString rangeOfString:@"Weather forecast for this afternoon and tonight:<br/>"];
                            
                            if ( rangeForecast.location == NSNotFound ) {
                                rangeForecast = [dataString rangeOfString:@"Weather forecast for tonight and tomorrow:<br/>"];
                                
                                if ( rangeForecast.location == NSNotFound ) {
                                    rangeForecast = [dataString rangeOfString:@":<br/>"];
                                    if ( rangeForecast.location == NSNotFound ) {
                                        NSLog(@"FORCAST NOT FOUND");
                                        return;
                                    }
                                }
                            }
                            
                            long rangeLength = dataString.length - (rangeForecast.location + rangeForecast.length) - 5;
                            
                            NSRange rangeForecastText = { rangeForecast.location + rangeForecast.length, rangeLength};
                            NSString *strForecast = [dataString substringWithRange: rangeForecastText];
                            self.weatherDesc = [[NSBundle mainBundle] localizedStringForKey:[self detectWeatherType:strForecast] value:@"" table:nil];
                            
                            if ( !self.tempDegree) {
                                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                                NSString *strTempDefault = [userdefault objectForKey:@"tempDegree"];
                                if ( strTempDefault ) {
                                    self.tempDegree = [strTempDefault stringByAppendingString:@"°C"];
                                } else {
                                    self.tempDegree = @"--°C";
                                }
                                
                            }
                            
                            if ( !self.weatherDesc) {
                                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                                NSString *strTempDefault = [userdefault objectForKey:@"weatherDesc"];
                                if ( strTempDefault ) {
                                    self.weatherDesc = strTempDefault;
                                } else {
                                    self.weatherDesc = @"LOADING";
                                }
                                
                            }
                            
                            NSLog(@"getCurrentTimelineEntryForComplication Complication:\n%@",self.tempDegree);
                            
                            // Call the handler with the current timeline entry
                            if ( complication.family == CLKComplicationFamilyUtilitarianSmall) {
                                CLKComplicationTemplateUtilitarianSmallFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
                                // Create template object
                                
                                myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
                                CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
                                
                                handler(entry);
                                
                            } else if ( complication.family == CLKComplicationFamilyUtilitarianLarge ) {
                                CLKComplicationTemplateUtilitarianLargeFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
                                // Create template object
                                NSString *utilitarianLargeStr = [NSString stringWithFormat:@"%@ %@",self.tempDegree, self.weatherDesc];
                                myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText: utilitarianLargeStr];
                                CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
                                
                                handler(entry);
                                
                                
                            } else if ( complication.family == CLKComplicationFamilyCircularSmall ) {
                                CLKComplicationTemplateCircularSmallSimpleText *myComplicationTemplate =[[CLKComplicationTemplateCircularSmallSimpleText alloc] init];
                                // Create template object
                                
                                myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
                                CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
                                
                                handler(entry);
                            } else if ( complication.family == CLKComplicationFamilyModularSmall ) {
                                CLKComplicationTemplateModularSmallStackText *myComplicationTemplate =[[CLKComplicationTemplateModularSmallStackText alloc] init];
                                // Create template object
                                
                                myComplicationTemplate.line1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
                                myComplicationTemplate.line2TextProvider = [CLKTextProvider textProviderWithFormat:@" ",nil];
                                CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
                                
                                handler(entry);
                            } else if ( complication.family == CLKComplicationFamilyModularLarge ) {
                                CLKComplicationTemplateModularLargeStandardBody *myComplicationTemplate =[[CLKComplicationTemplateModularLargeStandardBody alloc] init];
                                // Create template object
                                NSString *header = [[NSBundle mainBundle] localizedStringForKey:@"HKWeather" value:@"" table:nil];
                                
                                myComplicationTemplate.headerTextProvider = [CLKTextProvider textProviderWithFormat:@"%@", header];
                                myComplicationTemplate.body1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
                                myComplicationTemplate.body2TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.weatherDesc];
                                
                                CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
                                
                                handler(entry);
                                
                            } else {
                                handler(nil);
                            }
                            
                        }] resume];
                
            }] resume];

    
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
//    [self callAPI];
    if ( !self.tempDegree) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *strTempDefault = [userdefault objectForKey:@"tempDegree"];
        if ( strTempDefault ) {
            self.tempDegree = [strTempDefault stringByAppendingString:@"°C"];
        } else {
            self.tempDegree = @"--°C";
        }
        
    }
    
    if ( !self.weatherDesc) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *strTempDefault = [userdefault objectForKey:@"weatherDesc"];
        if ( strTempDefault ) {
            self.weatherDesc = strTempDefault;
        } else {
            self.weatherDesc = @"LOADING";
        }
        
    }
    
    NSLog(@"getTimelineEntriesForComplication beforeDate Complication:\n%@",self.tempDegree);
    CLKComplicationTimelineEntry *entry;
    if ( complication.family == CLKComplicationFamilyUtilitarianSmall) {
        CLKComplicationTemplateUtilitarianSmallFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
        // Create template object
        
        myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
        
        //handler(entry);
        
    } else if ( complication.family == CLKComplicationFamilyUtilitarianLarge ) {
        CLKComplicationTemplateUtilitarianLargeFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
        // Create template object
        NSString *utilitarianLargeStr = [NSString stringWithFormat:@"%@ %@",self.tempDegree, self.weatherDesc];
        myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText: utilitarianLargeStr];
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
        //handler(entry);
        
    } else if ( complication.family == CLKComplicationFamilyCircularSmall ) {
        CLKComplicationTemplateCircularSmallSimpleText *myComplicationTemplate =[[CLKComplicationTemplateCircularSmallSimpleText alloc] init];
        // Create template object
        
        myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
        
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
    } else if ( complication.family == CLKComplicationFamilyModularSmall ) {
        CLKComplicationTemplateModularSmallStackText *myComplicationTemplate =[[CLKComplicationTemplateModularSmallStackText alloc] init];
        // Create template object
        
        myComplicationTemplate.line1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
        myComplicationTemplate.line2TextProvider = [CLKTextProvider textProviderWithFormat:@" ",nil];
        
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        

        //handler(entry);
    } else if ( complication.family == CLKComplicationFamilyModularLarge ) {
        CLKComplicationTemplateModularLargeStandardBody *myComplicationTemplate =[[CLKComplicationTemplateModularLargeStandardBody alloc] init];
        // Create template object
        NSString *header = [[NSBundle mainBundle] localizedStringForKey:@"HKWeather" value:@"" table:nil];
        
        myComplicationTemplate.headerTextProvider = [CLKTextProvider textProviderWithFormat:@"%@", header];
        myComplicationTemplate.body1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
        
        myComplicationTemplate.body2TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.weatherDesc];
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
    } else {
        //handler(nil);
    }
    
    handler([NSArray arrayWithObject:entry]);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
//    [self callAPI];
    if ( !self.tempDegree) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *strTempDefault = [userdefault objectForKey:@"tempDegree"];
        if ( strTempDefault ) {
            self.tempDegree = [strTempDefault stringByAppendingString:@"°C"];
        } else {
            self.tempDegree = @"--°C";
        }
        
    }
    
    if ( !self.weatherDesc) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *strTempDefault = [userdefault objectForKey:@"weatherDesc"];
        if ( strTempDefault ) {
            self.weatherDesc = strTempDefault;
        } else {
            self.weatherDesc = @"LOADING";
        }
        
    }
    
    NSLog(@"getTimelineEntriesForComplication afterDate Complication:\n%@",self.tempDegree);
    CLKComplicationTimelineEntry *entry;
    if ( complication.family == CLKComplicationFamilyUtilitarianSmall) {
        CLKComplicationTemplateUtilitarianSmallFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
        // Create template object
        
        myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
        
        //handler(entry);
        
        
    } else if ( complication.family == CLKComplicationFamilyUtilitarianLarge ) {
        CLKComplicationTemplateUtilitarianLargeFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
        // Create template object
        NSString *utilitarianLargeStr = [NSString stringWithFormat:@"%@ %@",self.tempDegree, self.weatherDesc];
        myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText: utilitarianLargeStr];
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
        //handler(entry);
        
    } else if ( complication.family == CLKComplicationFamilyCircularSmall ) {
        CLKComplicationTemplateCircularSmallSimpleText *myComplicationTemplate =[[CLKComplicationTemplateCircularSmallSimpleText alloc] init];
        // Create template object
        
        myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
        
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
        
        //handler(entry);
        
    } else if ( complication.family == CLKComplicationFamilyModularSmall ) {
        CLKComplicationTemplateModularSmallStackText *myComplicationTemplate =[[CLKComplicationTemplateModularSmallStackText alloc] init];
        // Create template object
        
        myComplicationTemplate.line1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
        myComplicationTemplate.line2TextProvider = [CLKTextProvider textProviderWithFormat:@" ",nil];
        
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
    } else if ( complication.family == CLKComplicationFamilyModularLarge ) {
        CLKComplicationTemplateModularLargeStandardBody *myComplicationTemplate =[[CLKComplicationTemplateModularLargeStandardBody alloc] init];
        // Create template object
        NSString *header = [[NSBundle mainBundle] localizedStringForKey:@"HKWeather" value:@"" table:nil];
        
        myComplicationTemplate.headerTextProvider = [CLKTextProvider textProviderWithFormat:@"%@", header];
        myComplicationTemplate.body1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
        myComplicationTemplate.body2TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.weatherDesc];
        
        entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:myComplicationTemplate];
        
    } else {
        //handler(nil);
    }
    
    handler([NSArray arrayWithObject:entry]);
    
}

#pragma mark Update Scheduling
//
//- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
//    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
//    NSDate *timeOneHour = [NSDate dateWithTimeIntervalSinceNow:60*60];
//    handler(timeOneHour);
//}

#pragma mark - Placeholder Templates

- (void)getLocalizableSampleTemplate:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    // This method will be called once per supported complication, and the results will be cached

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_CurrentWeather]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                //
                NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                
                //NSLog(@"requestedUpdateDidBegin Complication:\n%@",dataString);
                //NSLog(@"error %@", [error description]);
                
                NSRange rangeAirTemp = [dataString rangeOfString:@"Air temperature : "];
                
                if ( rangeAirTemp.location == NSNotFound ) {
                    return;
                } else {
                    NSRange rangeAirTempNum = { rangeAirTemp.location + rangeAirTemp.length, 2};
                    self.tempDegree = [dataString substringWithRange: rangeAirTempNum];
                    self.tempDegree = [self.tempDegree stringByAppendingString:@"°C"];
                }
                
                NSLog(@"requestedUpdateDidBegin Complication:\n%@",self.tempDegree);
                
                //
                [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_LocalWeatherForecast]
                        completionHandler:^(NSData *data,
                                            NSURLResponse *response,
                                            NSError *error) {
                            
                            NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                            
                            NSLog(@"requestedUpdateDidBegin Complication 2 :\n%@",dataString);
                            
                            //
                            NSRange rangeForecast = [dataString rangeOfString:@"Weather forecast for this afternoon and tonight:<br/>"];
                            
                            if ( rangeForecast.location == NSNotFound ) {
                                rangeForecast = [dataString rangeOfString:@"Weather forecast for tonight and tomorrow:<br/>"];
                                
                                if ( rangeForecast.location == NSNotFound ) {
                                    rangeForecast = [dataString rangeOfString:@":<br/>"];
                                    if ( rangeForecast.location == NSNotFound ) {
                                        NSLog(@"FORCAST NOT FOUND");
                                        return;
                                    }
                                }
                            }
                            
                            long rangeLength = dataString.length - (rangeForecast.location + rangeForecast.length) - 5;
                            
                            NSRange rangeForecastText = { rangeForecast.location + rangeForecast.length, rangeLength};
                            NSString *strForecast = [dataString substringWithRange: rangeForecastText];
                            self.weatherDesc = [[NSBundle mainBundle] localizedStringForKey:[self detectWeatherType:strForecast] value:@"" table:nil];
                            
                            if ( !self.tempDegree) {
                                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                                NSString *strTempDefault = [userdefault objectForKey:@"tempDegree"];
                                if ( strTempDefault ) {
                                    self.tempDegree = [strTempDefault stringByAppendingString:@"°C"];
                                } else {
                                    self.tempDegree = @"--°C";
                                }
                                
                            }
                            
                            if ( !self.weatherDesc) {
                                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                                NSString *strTempDefault = [userdefault objectForKey:@"weatherDesc"];
                                if ( strTempDefault ) {
                                    self.weatherDesc = strTempDefault;
                                } else {
                                    self.weatherDesc = @"LOADING";
                                }
                                
                            }
                            
                            NSLog(@"getCurrentTimelineEntryForComplication Complication:\n%@",self.tempDegree);
                            
                            switch (complication.family) {
                        
                        
                                case CLKComplicationFamilyCircularSmall: {
                                    CLKComplicationTemplateCircularSmallSimpleText *myComplicationTemplate =[[CLKComplicationTemplateCircularSmallSimpleText alloc] init];
                                    // Create template object
                        
                                    //myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:@"--°C"];
                        
                                    myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
                                    handler(myComplicationTemplate);
                                    break;
                                }
                                case CLKComplicationFamilyUtilitarianSmall: {
                                    CLKComplicationTemplateUtilitarianSmallFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
                                    // Create template object
                        
                                    //myComplicationTemplate.textProvider = [CLKTextProvider textProviderWithFormat:@"--°C"];
                        
                                    myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
                                    handler(myComplicationTemplate);
                                    break;
                                }
                                case CLKComplicationFamilyUtilitarianLarge: {
                                    CLKComplicationTemplateUtilitarianLargeFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
                                    // Create template object
                        
                                    //myComplicationTemplate.textProvider = [CLKTextProvider textProviderWithFormat:@"--°C"];
                        
                                    myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
                                    handler(myComplicationTemplate);
                                    break;
                                }
                                case CLKComplicationFamilyModularSmall: {
                                    CLKComplicationTemplateModularSmallStackText *myComplicationTemplate =[[CLKComplicationTemplateModularSmallStackText alloc] init];
                                    // Create template object
                        //
                        //            myComplicationTemplate.line1TextProvider = [CLKTextProvider textProviderWithFormat:@"--"];
                        //            myComplicationTemplate.line2TextProvider = [CLKTextProvider textProviderWithFormat:@" "];
                                    myComplicationTemplate.line1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
                                    myComplicationTemplate.line2TextProvider = [CLKTextProvider textProviderWithFormat:@" ",nil];
                        
                                    handler(myComplicationTemplate);
                                    break;
                                }
                                case CLKComplicationFamilyModularLarge: {
                                    CLKComplicationTemplateModularLargeStandardBody *myComplicationTemplate =[[CLKComplicationTemplateModularLargeStandardBody alloc] init];
                                    // Create template object
                        
                                    NSString *header = [[NSBundle mainBundle] localizedStringForKey:@"HKWeather" value:@"" table:nil];
                        //
                        //            myComplicationTemplate.headerTextProvider = [CLKTextProvider textProviderWithFormat:@"%@", header];
                        //            myComplicationTemplate.body1TextProvider = [CLKTextProvider textProviderWithFormat:@"--°C"];
                        //            myComplicationTemplate.body2TextProvider = [CLKTextProvider textProviderWithFormat:@"--"];
                                    myComplicationTemplate.headerTextProvider = [CLKTextProvider textProviderWithFormat:@"%@", header];
                                    myComplicationTemplate.body1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
                                    myComplicationTemplate.body2TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.weatherDesc];
                        
                                    handler(myComplicationTemplate);
                                    break;
                                }
                                default:
                        
                                    handler(nil);
                                    break;
                            }
                            
                        }] resume];
                
            }] resume];
    
//    if ( !self.tempDegree) {
//        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//        NSString *strTempDefault = [userdefault objectForKey:@"tempDegree"];
//        if ( strTempDefault ) {
//            self.tempDegree = [strTempDefault stringByAppendingString:@"°C"];
//        } else {
//            self.tempDegree = @"18°C";
//        }
//
//    }
//
//    if ( !self.weatherDesc) {
//        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//        NSString *strTempDefault = [userdefault objectForKey:@"weatherDesc"];
//        if ( strTempDefault ) {
//            self.weatherDesc = strTempDefault;
//        } else {
//            self.weatherDesc = @"Cloudy";
//        }
//
//    }
//    switch (complication.family) {
//
//
//        case CLKComplicationFamilyCircularSmall: {
//            CLKComplicationTemplateCircularSmallSimpleText *myComplicationTemplate =[[CLKComplicationTemplateCircularSmallSimpleText alloc] init];
//            // Create template object
//
//            //myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:@"--°C"];
//
//            myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
//            handler(myComplicationTemplate);
//            break;
//        }
//        case CLKComplicationFamilyUtilitarianSmall: {
//            CLKComplicationTemplateUtilitarianSmallFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
//            // Create template object
//
//            //myComplicationTemplate.textProvider = [CLKTextProvider textProviderWithFormat:@"--°C"];
//
//            myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
//            handler(myComplicationTemplate);
//            break;
//        }
//        case CLKComplicationFamilyUtilitarianLarge: {
//            CLKComplicationTemplateUtilitarianLargeFlat *myComplicationTemplate =[[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
//            // Create template object
//
//            //myComplicationTemplate.textProvider = [CLKTextProvider textProviderWithFormat:@"--°C"];
//
//            myComplicationTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:self.tempDegree];
//            handler(myComplicationTemplate);
//            break;
//        }
//        case CLKComplicationFamilyModularSmall: {
//            CLKComplicationTemplateModularSmallStackText *myComplicationTemplate =[[CLKComplicationTemplateModularSmallStackText alloc] init];
//            // Create template object
////
////            myComplicationTemplate.line1TextProvider = [CLKTextProvider textProviderWithFormat:@"--"];
////            myComplicationTemplate.line2TextProvider = [CLKTextProvider textProviderWithFormat:@" "];
//            myComplicationTemplate.line1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
//            myComplicationTemplate.line2TextProvider = [CLKTextProvider textProviderWithFormat:@" ",nil];
//
//            handler(myComplicationTemplate);
//            break;
//        }
//        case CLKComplicationFamilyModularLarge: {
//            CLKComplicationTemplateModularLargeStandardBody *myComplicationTemplate =[[CLKComplicationTemplateModularLargeStandardBody alloc] init];
//            // Create template object
//
//            NSString *header = [[NSBundle mainBundle] localizedStringForKey:@"HKWeather" value:@"" table:nil];
////
////            myComplicationTemplate.headerTextProvider = [CLKTextProvider textProviderWithFormat:@"%@", header];
////            myComplicationTemplate.body1TextProvider = [CLKTextProvider textProviderWithFormat:@"--°C"];
////            myComplicationTemplate.body2TextProvider = [CLKTextProvider textProviderWithFormat:@"--"];
//            myComplicationTemplate.headerTextProvider = [CLKTextProvider textProviderWithFormat:@"%@", header];
//            myComplicationTemplate.body1TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.tempDegree];
//            myComplicationTemplate.body2TextProvider = [CLKTextProvider textProviderWithFormat:@"%@",self.weatherDesc];
//
//            handler(myComplicationTemplate);
//            break;
//        }
//        default:
//
//            handler(nil);
//            break;
//    }
    
}

- (NSString*) detectWeatherType: (NSString*) desc
{
    NSRange rangeType;
    
    rangeType = [desc rangeOfString:@"rain" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc rain";
    }
    
    rangeType = [desc rangeOfString:@"shower" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc shower";
    }
    rangeType = [desc rangeOfString:@"cloudy" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        NSLog(@"cloudy");
        return  @"desc cloudy";
    }
    rangeType = [desc rangeOfString:@"fine" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc fine";
    }
    rangeType = [desc rangeOfString:@"sunny intervals" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"bright intervals" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"sunny periods" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"bright periods" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"sunny" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny";
    }
    rangeType = [desc rangeOfString:@"bright" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny";
    }
    rangeType = [desc rangeOfString:@"thunderstorm" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc thunderstorm";
    }
    
    
    
    return @"";
}




@end
