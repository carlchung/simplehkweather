//
//  MoreInterfaceController.m
//  simplehkweather
//
//  Created by carl on 26/4/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import "MoreInterfaceController.h"
#import "DayRow.h"
#define kRSS_URL_SeveralDays @"http://rss.weather.gov.hk/rss/SeveralDaysWeatherForecast.xml"

#define LString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


@interface MoreInterfaceController()
- (NSString*) detectWeatherType: (NSString*) desc;
- (NSString *) translateDayOfWeek:(NSString*) str;
- (IBAction)doMenuReload;
@end


@implementation MoreInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    //[self setupTable];
    NSLog(@"after setupTable");
    [self.tableDays setNumberOfRows:1 withRowType:@"DayRow"];

    
}


- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSDictionary *dict = @{@"page":@"9day"};
    
    [self invalidateUserActivity];
//    [self updateUserActivity:@"com.metacreate.simplehkweather.9day" userInfo:dict webpageURL:nil];
    
    [self loadCurrentWeatherRSS];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
}

- (void) loadCurrentWeatherRSS
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:kRSS_URL_SeveralDays]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if ( ! error ) {
                    NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                    NSLog(@"dataTaskWithURL Table Weather:\n%@",dataString);
                    
                    arrayContent = [dataString componentsSeparatedByString:@"Date/Month:"];
                    
                    [self setupTable];
                } else {
                    NSLog(@"Error %@", [error description]);
                }


            }] resume];
    
    
    // Create the request.
    /*
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kRSS_URL_SeveralDays]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10.0];
    

    [NSURLConnection sendAsynchronousRequest:theRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {


                           }];
     
     */
}

- (IBAction)doMenuReload
{
    [self loadCurrentWeatherRSS];
    
}


- (void)setupTable
{
    
    [self.tableDays setNumberOfRows:[arrayContent count]-1 withRowType:@"DayRow"];

    
    for (NSInteger i = 1; i < self.tableDays.numberOfRows+1; i++)
    {
        DayRow *row = [self.tableDays rowControllerAtIndex:i-1];
        
            NSString *cellWholeStringInLines = [arrayContent objectAtIndex:i ];
            NSString *cellWholeString = [[cellWholeStringInLines componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            
            NSArray *arrayItems = [cellWholeString componentsSeparatedByString:@"<br/>"];
            
            //NSLog(@"items %i %@", indexPath.row, arrayItems);
            
            
            if ( [arrayItems count] >= 4 ) {
                
                row.labelDay.text = [self translateDayOfWeek:[arrayItems objectAtIndex:0]];
                row.labelTemperature.text =  [self translateToLocalized: [arrayItems objectAtIndex:3]];
            }
            
            NSString *strForecast = [self translateToLocalized:[arrayItems objectAtIndex:2]] ;
            
            if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc rain"] ) {
                [row.imageIcon setImageNamed:@"watch_rain.png"];
            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc shower"]  ) {
                [row.imageIcon setImageNamed:@"watch_rain_sunny.png"];
                
            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc showerWithSun"]  ) {
                [row.imageIcon setImageNamed:@"watch_rain_sunny.png"];
                
            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc cloudy"]  ) {
                [row.imageIcon setImageNamed:@"watch_cloudy.png"];
            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc sunny interval"]  ) {
                [row.imageIcon setImageNamed:@"watch_sunnyperiod.png"];
                
            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc fine"]  ) {
                [row.imageIcon setImageNamed:@"watch_sunny.png"];
            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc sunny"]  ) {
                [row.imageIcon setImageNamed:@"watch_sunny.png"];
            } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc thunderstorm"]  ) {
                [row.imageIcon setImageNamed:@"watch_thunder.png"];
            }
    
        
    }
    
}


- (NSString*) detectWeatherType: (NSString*) desc
{
    NSRange rangeType;
    NSLog(@"Desc %@", desc);
    
    rangeType = [desc rangeOfString:@"rain" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        
        rangeType = [desc rangeOfString:@"sunnyperiods" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc showerWithSun";
        }
        rangeType = [desc rangeOfString:@"sunnyintervals" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc showerWithSun";
        }
        return  @"desc rain";
    }
    
    rangeType = [desc rangeOfString:@"shower" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        
        rangeType = [desc rangeOfString:@"sunnyperiods" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc showerWithSun";
        }
        rangeType = [desc rangeOfString:@"sunnyintervals" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc showerWithSun";
        }
        
        return  @"desc shower";
    }
    rangeType = [desc rangeOfString:@"cloudy" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        rangeType = [desc rangeOfString:@"sunnyperiods" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc sunny interval";
        }
        rangeType = [desc rangeOfString:@"sunnyintervals" options:NSCaseInsensitiveSearch];
        if ( rangeType.location != NSNotFound ) {
            return  @"desc sunny interval";
        }
        return  @"desc cloudy";
    }
    rangeType = [desc rangeOfString:@"sunnyintervals" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"brightintervals" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"sunnyperiods" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    rangeType = [desc rangeOfString:@"brightperiods" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny interval";
    }
    
    rangeType = [desc rangeOfString:@"fine" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc fine";
    }
    rangeType = [desc rangeOfString:@"sunny" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc sunny";
    }
    
    rangeType = [desc rangeOfString:@"thunderstorm" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return  @"desc thunderstorm";
    }
    
    
    
    return @"";
}
- (NSString *) translateDayOfWeek:(NSString*) str
{
    NSRange rangeType;
    rangeType = [str rangeOfString:@"Monday" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return LString(@"Monday", nil);
    }
    
    rangeType = [str rangeOfString:@"Tuesday" options:NSCaseInsensitiveSearch];
    
    if ( rangeType.location != NSNotFound ) {
        return LString(@"Tuesday", nil);
    }
    rangeType = [str rangeOfString:@"Wednesday" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return LString(@"Wednesday", nil);
    }
    rangeType = [str rangeOfString:@"Thursday" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return LString(@"Thursday", nil);
    }
    rangeType = [str rangeOfString:@"Friday" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return LString(@"Friday", nil);
    }
    rangeType = [str rangeOfString:@"Saturday" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return LString(@"Saturday", nil);
    }
    
    rangeType = [str rangeOfString:@"Sunday" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return LString(@"Sunday", nil);
    }
    
    return @"";
}

- (NSString*) translateToLocalized:(NSString*) str
{
    str = [str stringByReplacingOccurrencesOfString:@" C"  withString:@"°"];
    str = [str stringByReplacingOccurrencesOfString:@" -"  withString:@"° "];
    
    str = [str stringByReplacingOccurrencesOfString:@"\t"  withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n"  withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"Weather:" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"Temp range:" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"Monday" withString:LString(@"Monday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Tuesday" withString:LString(@"Tuesday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Wednesday" withString:LString(@"Wednesday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Thursday" withString:LString(@"Thursday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Friday" withString:LString(@"Friday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Saturday" withString:LString(@"Saturday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@"Sunday" withString:LString(@"Sunday", nil)];
    str = [str stringByReplacingOccurrencesOfString:@" "  withString:@""];
    return str;
}


@end



