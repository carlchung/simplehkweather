//
//  InterfaceController.m
//  simplehkweather WatchKit Extension
//
//  Created by carl on 25/4/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import "InterfaceController.h"
#import <ClockKit/ClockKit.h>

#define kRSS_URL_CurrentWeather @"http://rss.weather.gov.hk/rss/CurrentWeather.xml"
#define kRSS_URL_LocalWeatherForecast @"http://rss.weather.gov.hk/rss/LocalWeatherForecast.xml"
#define kRSS_URL_warning @"http://rss.weather.gov.hk/rss/WeatherWarningSummaryv2.xml"

#define LString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
    // Configure interface objects here.

//    self.dictMoreInfo = [[NSMutableDictionary alloc] initWithCapacity:0];

//    [self loadCurrentWeatherRSS];
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self loadCurrentWeatherRSS];
//    NSDictionary *dict = @{@"page":@"main"};
    
    [self invalidateUserActivity];
//    [self updateUserActivity:@"com.metacreate.simplehkweather.mainpage" userInfo:dict webpageURL:nil];
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType: @"com.metacreate.simplehkweather.mainpage"];
    userActivity.userInfo = @{@"page":@"main"};
    [self updateUserActivity: userActivity];
//    [WKExtension sharedExtension].delegate = self;
//    [WKExtension.sharedExtension scheduleBackgroundRefreshWithPreferredDate:[NSDate dateWithTimeIntervalSinceNow:60*60] userInfo:nil scheduledCompletion:^(NSError * _Nullable error) {
//        
//        if(error == nil) {
//            NSLog(@"background refresh task re-scheduling successfuly  ");
//            
//        } else{
//            
//            NSLog(@"Error occurred while re-scheduling background refresh: %@",error.localizedDescription);
//        }
//    }];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *strTempDefault = [userdefault objectForKey:@"tempDegree"];
    if ( strTempDefault ) {
        self.labelDegree.text = strTempDefault;
    }
    
    strTempDefault = [userdefault objectForKey:@"weatherDesc"];
    if ( strTempDefault ) {
        self.labelWeather.text = strTempDefault;
    }
    
    strTempDefault = [userdefault objectForKey:@"strForecast"];
    if ( [[self detectWeatherType:strTempDefault] isEqualToString:@"desc rain"] ) {
        [self.imageWeatherIcon setImageNamed:@"watch_rain.png"];
    } else if ( [[self detectWeatherType:strTempDefault] isEqualToString:@"desc shower"]  ) {
        [self.imageWeatherIcon setImageNamed:@"watch_rain_sunny.png"];
    } else if ( [[self detectWeatherType:strTempDefault] isEqualToString:@"desc showerWithSun"]  ) {
        [self.imageWeatherIcon setImageNamed:@"watch_rain_sunny.png"];
        
    } else if ( [[self detectWeatherType:strTempDefault] isEqualToString:@"desc cloudy"]  ) {
        [self.imageWeatherIcon setImageNamed:@"watch_cloudy.png"];
        
    } else if ( [[self detectWeatherType:strTempDefault] isEqualToString:@"desc sunny interval"]  ) {
        [self.imageWeatherIcon setImageNamed:@"watch_sunnyperiod.png"];
        
    } else if ( [[self detectWeatherType:strTempDefault] isEqualToString:@"desc fine"]  ) {
        [self.imageWeatherIcon setImageNamed:@"watch_sunny.png"];
        
    } else if ( [[self detectWeatherType:strTempDefault] isEqualToString:@"desc sunny"]  ) {
        [self.imageWeatherIcon setImageNamed:@"watch_sunny.png"];
        
    } else if ( [[self detectWeatherType:strTempDefault] isEqualToString:@"desc thunderstorm"]  ) {
        [self.imageWeatherIcon setImageNamed:@"watch_thunder.png"];
        
    }
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
}


- (IBAction)doMenuReload
{
    [self loadCurrentWeatherRSS];
    
}

- (void) loadCurrentWeatherRSS
{
    // Create the request.

    
    // create the connection with the request
    // and start loading the data
    // note that the delegate for the NSURLConnection is self, so delegate methods must be defined in this file
    //NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"loadCurrentWeatherRSS START");
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_CurrentWeather]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                //
                NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                
                NSLog(@"sendAsynchronousRequest dataString:\n%@",dataString);
                NSLog(@"error %@", [error description]);
                
                NSRange rangeAirTemp = [dataString rangeOfString:@"Air temperature : "];
                
                if ( rangeAirTemp.location == NSNotFound ) {
                    return;
                } else {
                    NSRange rangeAirTempNum = { rangeAirTemp.location + rangeAirTemp.length, 2};
                    strTempDegree = [dataString substringWithRange: rangeAirTempNum];
                    //self.lblTempDegree.text = strTempDegree;
                    self.labelDegree.text = strTempDegree;
                    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                    [userdefault setObject:strTempDegree forKey:@"tempDegree"];
                }
                
                //
                
                NSRange rangeRH = [dataString rangeOfString:@"Relative Humidity : "];
                
                if ( rangeRH.location == NSNotFound ) {
                    return;
                } else {
                    NSRange rangeRHNum = { rangeRH.location + rangeRH.length, 2};
                    strHumidity = [dataString substringWithRange: rangeRHNum];
                    self.labelRH.text = [NSString stringWithFormat:@"RH %@%%", strHumidity];
                    //self.dictMoreInfo[@"RH"] = strHumidity;
                }
                
                
                //
                NSRange rangeUV = [dataString rangeOfString:@"the mean UV Index recorded at King's Park : "];
                
                if ( rangeUV.location == NSNotFound ) {
                    //return;
                    self.labelUV.text = @"UV - ";
//                    self.dictMoreInfo[@"UV"] = @"-";
                } else {
                    NSRange rangeUVNum = { rangeUV.location + rangeUV.length, 3};
                    strUV = [dataString substringWithRange: rangeUVNum];
                    strUV = [strUV stringByReplacingOccurrencesOfString:@"<b" withString:@""];
                    self.labelUV.text = [NSString stringWithFormat:@"UV %@", strUV];
                    //self.dictMoreInfo[@"UV"] = strUV;
                }
                
                //
                NSRange rangeUpdateTime = [dataString rangeOfString:@"Bulletin updated at "];
                
                if ( rangeUpdateTime.location == NSNotFound ) {
                    return;
                } else {
                    NSRange rangeUpdateTimeText = { rangeUpdateTime.location + rangeUpdateTime.length, 6};
                    strUpdateTime = [[dataString substringWithRange: rangeUpdateTimeText] stringByReplacingOccurrencesOfString:@"HKT " withString:@"  "];
                    //self.lblUpdateTime.text = strUpdateTime;
                    self.labelTime.text = strUpdateTime;
                }
                ////
                
                
                [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_LocalWeatherForecast]
                        completionHandler:^(NSData *data,
                                            NSURLResponse *response,
                                            NSError *error) {
                            
                            NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                            
                            NSLog(@"sendAsynchronousRequest dataString 2 :\n%@",dataString);
                            
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
                            strForecast = [dataString substringWithRange: rangeForecastText];
                            //self.lblDesc.text = LString([self detectWeatherType:strForecast], nil);
                            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                            [userdefault setObject:strForecast forKey:@"strForecast"];
                            NSString *tempDescWeather = [[NSBundle mainBundle] localizedStringForKey:[self detectWeatherType:strForecast] value:@"" table:nil];
                            self.labelWeather.text = tempDescWeather;
                            [userdefault setObject:tempDescWeather forKey:@"weatherDesc"];
                            //LString([self detectWeatherType:strForecast], nil);
                            
                            if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc rain"] ) {
                                [self.imageWeatherIcon setImageNamed:@"watch_rain.png"];
                            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc shower"]  ) {
                                [self.imageWeatherIcon setImageNamed:@"watch_rain_sunny.png"];
                            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc showerWithSun"]  ) {
                                [self.imageWeatherIcon setImageNamed:@"watch_rain_sunny.png"];
                                
                            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc cloudy"]  ) {
                                [self.imageWeatherIcon setImageNamed:@"watch_cloudy.png"];
                                
                            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc sunny interval"]  ) {
                                [self.imageWeatherIcon setImageNamed:@"watch_sunnyperiod.png"];
                                
                            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc fine"]  ) {
                                [self.imageWeatherIcon setImageNamed:@"watch_sunny.png"];
                                
                            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc sunny"]  ) {
                                [self.imageWeatherIcon setImageNamed:@"watch_sunny.png"];
                                
                            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc thunderstorm"]  ) {
                                [self.imageWeatherIcon setImageNamed:@"watch_thunder.png"];
                                
                            }
                            ///
                            
                            [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_warning]
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {
                                        NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                                        //dataString = @"<item> <title><![CDATA[Strong Wind Signal (01:03 HKT 04/02/2014)  ]]></title><link>http://www.weather.gov.hk/textonly/warning/warn.htm</link><author>Hong Kong Observatory</author><description><![CDATA[Strong Wind Signal]]></description> <pubDate>Tue, 04 Feb 2014 01:03:20 +0800</pubDate><guid isPermaLink=\"false\">http://rss.weather.gov.hk/rss/1391447000/nowarning</guid></item><item> <title><![CDATA[Red Rainstorm Warning Signal (01:03 HKT 04/02/2014)  ]]></title><link>http://www.weather.gov.hk/textonly/warning/warn.htm</link><author>Hong Kong Observatory</author><description><![CDATA[Red Rainstorm Warning Signal]]></description> <pubDate>Tue, 04 Feb 2014 01:03:20 +0800</pubDate><guid isPermaLink=\"false\">http://rss.weather.gov.hk/rss/1391447000/nowarning</guid></item>";
                                        
                                        NSLog(@"dataString:\n%@",dataString);
                                        
                                        NSRange rangeWarningExist;
                                        NSString *strLongText = @"";
                                        int countWarning = 0;
                                        rangeWarningExist = [dataString rangeOfString:@"Standby Signal" options:NSCaseInsensitiveSearch];
                                        
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Typhoon Signal No. 1", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Strong Wind Signal" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Typhoon Signal No. 3", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Northeast Gale or Storm Signal" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Typhoon Signal No. 8", nil)];
                                            countWarning++;
                                        }
                                        
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Northwest Gale or Storm Signal" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Typhoon Signal No. 8", nil)];
                                            countWarning++;
                                        }
                                        
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Southeast Gale or Storm Signal" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Typhoon Signal No. 8", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Southwest Gale or Storm Signal" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Typhoon Signal No. 8", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Increasing Gale or Storm Signal" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Typhoon Signal No. 9", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Hurricane Signal" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Typhoon Signal No. 10", nil)];
                                            countWarning++;
                                        }
                                        
                                        
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Amber Rainstorm Warning Signal issued" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Amber Rainstorm Warning Signal", nil)];
                                            countWarning++;
                                            
                                            NSLog(@"Really Amber??????");
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Red Rainstorm Warning Signal issued" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Red Rainstorm Warning Signal", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Black Rainstorm Warning Signal issued" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Black Rainstorm Warning Signal", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Thunderstorm Warning issued" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Thunderstorm Warning", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Special Announcement On Flooding In Northern New Territories issued" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Special Announcement On Flooding In Northern New Territories", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"Landslip" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Landslip Warning", nil)];
                                            countWarning++;
                                        }
                                        rangeWarningExist = [dataString rangeOfString:@"Strong Monsoon" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Strong Monsoon Signal", nil)];
                                            countWarning++;
                                        }
                                        rangeWarningExist = [dataString rangeOfString:@"Frost" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Frost Warning", nil)];
                                            countWarning++;
                                        }
                                        rangeWarningExist = [dataString rangeOfString:@"Yellow Fire" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Yellow Fire Danger Warning", nil)];
                                            countWarning++;
                                        }
                                        rangeWarningExist = [dataString rangeOfString:@"Red Fire" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Red Fire Danger Warning", nil)];
                                            countWarning++;
                                        }
                                        rangeWarningExist = [dataString rangeOfString:@"Cold Weather Warning" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Cold Weather Warning", nil)];
                                            countWarning++;
                                        }
                                        rangeWarningExist = [dataString rangeOfString:@"Very Hot Weather Warning" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Very Hot Weather Warning", nil)];
                                            countWarning++;
                                        }
                                        rangeWarningExist = [dataString rangeOfString:@"Tsunami" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = [strLongText stringByAppendingString:LString(@"Tsunami Warning", nil)];
                                            countWarning++;
                                        }
                                        
                                        rangeWarningExist = [dataString rangeOfString:@"no warning in force" options:NSCaseInsensitiveSearch];
                                        if ( rangeWarningExist.location != NSNotFound ) {
                                            strLongText = @"";
                                            //self.labelWarning
                                            countWarning++;
                                        }
                                        self.labelWarning.text = strLongText;
                                        
//                                        NSDate *now = [NSDate date];
//                                
//                                        [[WKExtension sharedExtension] scheduleSnapshotRefreshWithPreferredDate:now userInfo:nil scheduledCompletion:^(NSError *error) {
//                                            if (error != nil) {
//                                                NSLog(@"scheduleSnapshotRefreshWithPreferredDate return error %@", error);
//                                            }
//                                        }];
                                        [self refreshComplications];
                                        
                                    }] resume];
                        }] resume];
            }] resume];


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


- (void)refreshComplications {
    CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
    for(CLKComplication *complication in server.activeComplications) {
        [server reloadTimelineForComplication:complication];
    }
}

@end



