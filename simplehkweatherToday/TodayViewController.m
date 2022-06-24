//
//  TodayViewController.m
//  任何天氣 Any Weather
//
//  Created by carladmin on 23/7/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#define kRSS_URL_CurrentWeather @"http://rss.weather.gov.hk/rss/CurrentWeather.xml"
#define kRSS_URL_LocalWeatherForecast @"http://rss.weather.gov.hk/rss/LocalWeatherForecast.xml"


#define LString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = CGSizeMake(0, 90);
    NSLog(@"today widget viewDidLoad");
    
    [self loadCurrentWeatherRSS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    NSLog(@"today widget widgetPerformUpdateWithCompletionHandler");

    completionHandler(NCUpdateResultNewData);
}



- (void) loadCurrentWeatherRSS
{
    // Create the request.
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kRSS_URL_CurrentWeather]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10.0];
    
    // create the connection with the request
    // and start loading the data
    // note that the delegate for the NSURLConnection is self, so delegate methods must be defined in this file
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                               NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                               //self.lblUpdateTime.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:15.0];
                               
                               NSRange rangeAirTemp = [dataString rangeOfString:@"Air temperature : "];
                               
                               if ( rangeAirTemp.location == NSNotFound ) {
                                   return;
                               } else {
                                   NSRange rangeAirTempNum = { rangeAirTemp.location + rangeAirTemp.length, 2};
                                   strTempDegree = [dataString substringWithRange: rangeAirTempNum];
                                   self.lblTempDegree.text = strTempDegree;
                                   
                               }
                               
                               //
                               
//                               NSRange rangeRH = [dataString rangeOfString:@"Relative Humidity : "];
//
//                               if ( rangeRH.location == NSNotFound ) {
//                                   return;
//                               } else {
//                                   NSRange rangeRHNum = { rangeRH.location + rangeRH.length, 2};
//                                   strHumidity = [dataString substringWithRange: rangeRHNum];
//                                   self.lblHumidity.text = [NSString stringWithFormat:@"RH %@%%", strHumidity];
//
//                               }
                               
                               
                               //
//                               NSRange rangeUV = [dataString rangeOfString:@"the mean UV Index recorded at King's Park : "];
//
//                               if ( rangeUV.location == NSNotFound ) {
                                   //return;
//                                   self.lblUV.text = @"UV - ";
//                               } else {
//                                   NSRange rangeUVNum = { rangeUV.location + rangeUV.length, 3};
//                                   strUV = [dataString substringWithRange: rangeUVNum];
//                                   strUV = [strUV stringByReplacingOccurrencesOfString:@"<b" withString:@""];
//                                   self.lblUV.text = [NSString stringWithFormat:@"UV %@", strUV];
//
//                               }
                               //
                               NSRange rangeUpdateTime = [dataString rangeOfString:@"Bulletin updated at "];
                               
                               if ( rangeUpdateTime.location == NSNotFound ) {
                                   return;
                               } else {
                                   NSRange rangeUpdateTimeText = { rangeUpdateTime.location + rangeUpdateTime.length, 20};
                                   strUpdateTime = [[dataString substringWithRange: rangeUpdateTimeText] stringByReplacingOccurrencesOfString:@"HKT " withString:@"  "];
                                   //self.lblUpdateTime.text = strUpdateTime;
                                   
                               }
                               
                               // Warning detection
                               NSRange rangeWarningExist;
                               //UITabBarItem *tabChanged;
                               rangeWarningExist = [dataString rangeOfString:@"Cold Weather Warning" options:NSCaseInsensitiveSearch];
                               if ( rangeWarningExist.location != NSNotFound ) {
                                   
                                   //tabChanged = [[UITabBarItem alloc] initWithTitle:LString(@"Current warning" , nil) image:[UIImage imageNamed:@"warning_cold.gif"] tag:2];
                                   //self.tabBarItem = tabChanged;
                               }
                               
                        });
                    }];
    [task resume];
    
    NSURLRequest *theRequest2 = [NSURLRequest requestWithURL:[NSURL URLWithString:kRSS_URL_LocalWeatherForecast]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:10.0];
    NSURLSessionDataTask *task2 = [[NSURLSession sharedSession] dataTaskWithRequest:theRequest2 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                               NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                               
                               NSLog(@"dataString 2 :\n%@",dataString);
                               
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
                               NSRange rangeForecastText = { rangeForecast.location + rangeForecast.length, 40};
                               strForecast = [dataString substringWithRange: rangeForecastText];
                               NSLog(@"strForecast %@", strForecast);
                               self.lblDesc.text = LString([self detectWeatherType:strForecast], nil);
                               
                               UIImage *imageWeather;
                               if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc rain"] ) {
                                   imageWeather = [UIImage imageNamed:@"rain.png"];
                               } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc shower"]  ) {
                                   imageWeather = [UIImage imageNamed:@"rain_sunny.png"];
                               } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc showerWithSun"]  ) {
                                   imageWeather = [UIImage imageNamed:@"rain_sunny.png"];
                               } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc cloudy"]  ) {
                                   imageWeather = [UIImage imageNamed:@"cloudy.png"];
                               } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc sunny interval"]  ) {
                                   imageWeather = [UIImage imageNamed:@"sunnyperiod.png"];
                                   
                               } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc fine"]  ) {
                                   imageWeather = [UIImage imageNamed:@"sunny.png"];
                               } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc sunny"]  ) {
                                   imageWeather = [UIImage imageNamed:@"sunny.png"];
                               } else if ( [[self detectWeatherType:strForecast] isEqualToString:@"desc thunderstorm"]  ) {
                                   imageWeather = [UIImage imageNamed:@"thunder.png"];
                               }
                               
                               //self.imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(75, 330, 172, 110)];
                               self.imageViewIcon.image = imageWeather;
                               [self.view addSubview:self.imageViewIcon];
                            });
                        }];
    [task2 resume];
    
    //
    
}


- (NSString*) detectWeatherType: (NSString*) desc
{
    NSRange rangeType;
    
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
