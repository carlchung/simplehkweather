//
//  swWarningViewController.m
//  simplehkweather
//
//  Created by carl on 3/2/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

#import "swAppDelegate.h"
#import "swWarningViewController.h"
#define kRSS_URL_LocalWeatherForecast @"http://rss.weather.gov.hk/rss/LocalWeatherForecast.xml"
#define kRSS_URL_LocalWeatherForecast_zht @"http://rss.weather.gov.hk/rss/LocalWeatherForecast_uc.xml"


#define kRSS_URL_warning @"http://rss.weather.gov.hk/rss/WeatherWarningSummaryv2.xml"

@interface swWarningViewController ()

@end

@implementation swWarningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSLog(@"swWarningViewController initialization");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    swAppDelegate* appDelegate = (swAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *fontName = [appDelegate customFontName];
    //self.lblWarningTitle.font = [UIFont fontWithName:fontName size:40.0];
    //self.lblBigOne.font = [UIFont fontWithName:fontName size:30.0];
    
    
    //self.lblWarningTitle.text = LString(@"Current warning", nil);
    
    self.textViewBig.text = [NSString stringWithFormat:@"\n%@", LString(@"Loading. Please wait.", nil)];
    
    self.lblRefresh.font = [UIFont fontWithName:fontName size:25.0];
    self.lblRefresh.text = LString(@"Release to refresh", nil);
    self.lblRefresh.alpha = 0.0;
    
    //self.tabBarItem.title = LString(@"M_WARNINGS", nil);
    [self loadForecastRSS];
    //[self loadWarningRSS];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.lblBigOne.frame = CGRectMake(15.0, 95, 285, 40*countWarning +40);
    

}

-(void) loadForecastRSS
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"lang %@", language);
    if ( [language hasPrefix:@"zh"]) {
        urlString = kRSS_URL_LocalWeatherForecast_zht;
    } else {
        urlString = kRSS_URL_LocalWeatherForecast;
    }
    
    NSURLRequest *theRequest2 = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:10.0];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:theRequest2 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                                
                                NSLog(@"dataString forecast :\n%@",dataString);
                                
                                //
                                NSRange rangeForecast = [dataString rangeOfString:@"Weather forecast for this afternoon and tonight:<br/>"];
                                
                                if ( rangeForecast.location == NSNotFound ) {
                                    rangeForecast = [dataString rangeOfString:@"Weather forecast for tonight and tomorrow:<br/>"];
                                    if ( rangeForecast.location == NSNotFound ) {
                                        rangeForecast = [dataString rangeOfString:@"Weather forecast for today:<br/>"];
                                        if ( rangeForecast.location == NSNotFound ) {
                                            rangeForecast = [dataString rangeOfString:@"天氣預測:<br/>"];
                                            
                                            if ( rangeForecast.location == NSNotFound ) {
                                                NSLog(@"FORCAST NOT FOUND");
                                                return;
                                            }
                                        }
                                    }
                                    
                                }
                                
                                long rangeLength = dataString.length - (rangeForecast.location + rangeForecast.length) - 5;
                                NSRange rangeForecastText = { rangeForecast.location + rangeForecast.length, rangeLength};
                                NSString *strForecast = [dataString substringWithRange: rangeForecastText];
                                //NSLog(@"strForecast %@", strForecast);
                                
                                NSArray *arrayForecast = [strForecast componentsSeparatedByString:@"]]>" ];
                                //NSLog(@"arrayForecast %@", [arrayForecast[0] stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "]);
                                NSString *textForecast =  [arrayForecast[0] stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
                                textForecast = [textForecast stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                self.textViewBig.text =  [NSString stringWithFormat:@"\n%@\n\n%@", LString(@"Local Weather Forecast", nil), textForecast];
                                
                            });
        
    }];
    
    [task resume];
}

- (void) loadWarningRSS
{
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kRSS_URL_warning]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10.0];
    
    // create the connection with the request
    // and start loading the data
    // note that the delegate for the NSURLConnection is self, so delegate methods must be defined in this file
    
    [[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
                if ( error ) {
                    
                    // inform the user
//                    UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"Connection failed!" message: @""  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//                    [didFailWithErrorMessage show];
//
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Connection failed! "
                                                 message:@""
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        //do something when click button
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    //inform the user
                    NSLog(@"Connection failed! Error - %@ %@",
                          [error localizedDescription],
                          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
                    
                }
                NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                //dataString = @"<item> <title><![CDATA[Strong Wind Signal (01:03 HKT 04/02/2014)  ]]></title><link>http://www.weather.gov.hk/textonly/warning/warn.htm</link><author>Hong Kong Observatory</author><description><![CDATA[Strong Wind Signal]]></description> <pubDate>Tue, 04 Feb 2014 01:03:20 +0800</pubDate><guid isPermaLink=\"false\">http://rss.weather.gov.hk/rss/1391447000/nowarning</guid></item><item> <title><![CDATA[Red Rainstorm Warning Signal (01:03 HKT 04/02/2014)  ]]></title><link>http://www.weather.gov.hk/textonly/warning/warn.htm</link><author>Hong Kong Observatory</author><description><![CDATA[Red Rainstorm Warning Signal]]></description> <pubDate>Tue, 04 Feb 2014 01:03:20 +0800</pubDate><guid isPermaLink=\"false\">http://rss.weather.gov.hk/rss/1391447000/nowarning</guid></item>";
                
                NSLog(@"dataString:\n%@",dataString);
                
                NSRange rangeWarningExist;
                strLongText = @"";
                countWarning = 0;
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
                    strLongText =  LString(@"No warning in force", nil);
                    countWarning++;
                }
                //self.lblBigOne.frame = CGRectMake(15.0, 95, 285, 70*countWarning+40 );
                
                //self.lblBigOne.text = strLongText;
                
            }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        self.textViewBig.text = @"";
        self.lblRefresh.alpha = 0.0;
        
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            
            recognizer.view.center = CGPointMake(screenWidth/2, screenHeight/2);
            
            
        } completion:^(BOOL Finished){
            
            //[self loadWarningRSS];
            [self loadForecastRSS];
        }];
        
    }
    
    
}


@end
