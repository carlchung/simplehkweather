//
//  swNowViewController.m
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

#import "swAppDelegate.h"
#import "swNowViewController.h"

#define kRSS_URL_CurrentWeather @"http://rss.weather.gov.hk/rss/CurrentWeather.xml"
#define kRSS_URL_LocalWeatherForecast @"http://rss.weather.gov.hk/rss/LocalWeatherForecast.xml"

@interface swNowViewController ()

@end

@implementation swNowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = LString(@"M_NOW", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LString(@"M_NOW", nil);
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:LString(@"M_7DAYS", nil)];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:LString(@"M_WARNINGS", nil)];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setTitle:LString(@"M_AIR", nil)];

    
	// Do any additional setup after loading the view.
    swAppDelegate* appDelegate = (swAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *fontName = [appDelegate customFontName];
    //self.lblDesc.font = [UIFont fontWithName:fontName size:30.0];
    self.lblWarning.font = [UIFont fontWithName:fontName size:18.0];
    
    self.lblUpdateTime.font = [UIFont fontWithName:fontName size:15.0];
    self.lblUpdateTime.text = LString(@"Loading. Please wait.", nil);
    
    self.lblRefresh.font = [UIFont fontWithName:fontName size:16.0];
    self.lblRefresh.text = LString(@"Release to refresh", nil);
    self.lblRefresh.alpha = 0.0;
    
    [self loadCurrentWeatherRSS];
    
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
                                   self.lblUpdateTime.font = [UIFont fontWithName:@"BodoniSvtyTwoITCTT-Book" size:15.0];
                                
                                   NSRange rangeAirTemp = [dataString rangeOfString:@"Air temperature : "];
                                
                                   if ( rangeAirTemp.location == NSNotFound ) {
                                       return;
                                   } else {
                                       NSRange rangeAirTempNum = { rangeAirTemp.location + rangeAirTemp.length, 2};
                                       strTempDegree = [dataString substringWithRange: rangeAirTempNum];
                                       self.lblTempDegree.text = strTempDegree;
                                       
                                   }
                                   //
                                
                                   NSRange rangeWarning;
                                
                                   rangeWarning = [dataString rangeOfString:@"Tropical Cyclone Signal No. 8"];
                                
                                   if ( rangeWarning.location == NSNotFound ) {
                                       
                                   } else {
                                       
                                       self.lblWarning.text = LString(@"Typhoon Signal No. 8", nil);
                                       
                                   }
                                
                                   rangeWarning = [dataString rangeOfString:@"Tropical Cyclone Signal No. 3"];
                                
                                   if ( rangeWarning.location == NSNotFound ) {
                                       
                                   } else {
                                       
                                       self.lblWarning.text = LString(@"Typhoon Signal No. 3", nil);
                                       
                                   }
                                   rangeWarning = [dataString rangeOfString:@"Very Hot Weather Warning"];
                                
                                   if ( rangeWarning.location == NSNotFound ) {
                                       
                                   } else {
                                       
                                       self.lblWarning.text = LString(@"Very Hot Weather Warning", nil);
                                       
                                   }
                                   rangeWarning = [dataString rangeOfString:@"Cold Weather Warning"];
                                
                                   if ( rangeWarning.location == NSNotFound ) {
                                       
                                   } else {
                                       
                                       self.lblWarning.text = LString(@"Cold Weather Warning", nil);
                                       
                                   }
                                   rangeWarning = [dataString rangeOfString:@"Amber Rainstorm Warning Signal issued"];
                                
                                   if ( rangeWarning.location == NSNotFound ) {
                                       
                                   } else {
                                       
                                       self.lblWarning.text = LString(@"Amber Rainstorm Warning Signal", nil);
                                       
                                   }
                                   rangeWarning = [dataString rangeOfString:@"Red Rainstorm Warning Signal issued"];
                                
                                   if ( rangeWarning.location == NSNotFound ) {
                                       
                                   } else {
                                       
                                       self.lblWarning.text = LString(@"Red Rainstorm Warning Signal", nil);
                                       
                                   }
                                   rangeWarning = [dataString rangeOfString:@"Black Rainstorm Warning Signal issued"];
                                
                                   if ( rangeWarning.location == NSNotFound ) {
                                       
                                   } else {
                                       
                                       self.lblWarning.text = LString(@"Black Rainstorm Warning Signal", nil);
                                       
                                   }
                                
                                   //
                                
                                   NSRange rangeRH = [dataString rangeOfString:@"Relative Humidity : "];
                                   self.lblHumidity.text = @"";
                                   if ( rangeRH.location == NSNotFound ) {
                                       return;
                                   } else {
                                       NSRange rangeRHNum = { rangeRH.location + rangeRH.length, 2};
                                       strHumidity = [dataString substringWithRange: rangeRHNum];
                                       self.lblHumidity.text = [NSString stringWithFormat:@"%@ %@%%",LString(@"RH", nil), strHumidity];
                                       
                                   }
                                
                                
                                   //
                                   NSRange rangeUV = [dataString rangeOfString:@"the mean UV Index recorded at King's Park : "];
                                
                                   if ( rangeUV.location == NSNotFound ) {
                                       //return;
                                       self.lblHumidity.text = [NSString stringWithFormat:@"%@  %@",self.lblHumidity.text, @"UV - "];
                                   } else {
                                       NSRange rangeUVNum = { rangeUV.location + rangeUV.length, 3};
                                       strUV = [dataString substringWithRange: rangeUVNum];
                                       strUV = [strUV stringByReplacingOccurrencesOfString:@"<b" withString:@""];
                                       self.lblHumidity.text = [NSString stringWithFormat:@"%@  %@ %@",self.lblHumidity.text, LString(@"UV", nil), strUV];
                                       
                                   }
                                   //
                                   NSRange rangeUpdateTime = [dataString rangeOfString:@"Bulletin updated at "];
                                
                                   if ( rangeUpdateTime.location == NSNotFound ) {
                                       return;
                                   } else {
                                       NSRange rangeUpdateTimeText = { rangeUpdateTime.location + rangeUpdateTime.length, 20};
                                       strUpdateTime = [[dataString substringWithRange: rangeUpdateTimeText] stringByReplacingOccurrencesOfString:@"HKT " withString:@"  "];
                                       self.lblUpdateTime.text = strUpdateTime;
                                       
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
                                   
                                   long rangeLength = dataString.length - (rangeForecast.location + rangeForecast.length) - 5;
                                   NSRange rangeForecastText = { rangeForecast.location + rangeForecast.length, rangeLength};
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
                                   
                                   //UIImageView *imageWeatherView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 330, 172, 110)];
                                   _imageViewCenter.image = imageWeather;
                                });
                           }];
    [task2 resume];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -


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

- (IBAction)updateAction {
    self.lblTempDegree.text = @"";
    self.lblHumidity.text = @"";
    self.lblDesc.text= @"";
    self.lblUpdateTime.text = LString(@"Loading. Please wait.", nil);
    self.lblRefresh.alpha = 0.0;
    
    
    swAppDelegate* appDelegate = (swAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *fontName = [appDelegate customFontName];
    self.lblUpdateTime.font = [UIFont fontWithName:fontName size:15.0];

    [self loadCurrentWeatherRSS];
    
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x ,
                                         recognizer.view.center.y +  (translation.y/2));
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    if ( recognizer.view.center.y > 320) {
        self.lblRefresh.alpha = 1.0;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"recognizer.view.center %f", recognizer.view.center.y);
        if ( recognizer.view.center.y < 350) {

            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenWidth = screenRect.size.width;
                CGFloat screenHeight = screenRect.size.height;
                
                recognizer.view.center = CGPointMake(screenWidth/2, screenHeight/2);
                
                
            } completion:^(BOOL Finished){
                
            }];
            return;
        }

     
        self.lblTempDegree.text = @"";
        self.lblHumidity.text = @"";
        self.lblDesc.text= @"";
        self.lblUpdateTime.text = LString(@"Loading. Please wait.", nil);
        self.lblRefresh.alpha = 0.0;
        
        
        swAppDelegate* appDelegate = (swAppDelegate*)[[UIApplication sharedApplication]delegate];
        NSString *fontName = [appDelegate customFontName];
        self.lblUpdateTime.font = [UIFont fontWithName:fontName size:15.0];


        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            
            recognizer.view.center = CGPointMake(screenWidth/2, screenHeight/2);

            
        } completion:^(BOOL Finished){
            
            [self loadCurrentWeatherRSS];
            
        }];
        
    }
    
    
}


@end
