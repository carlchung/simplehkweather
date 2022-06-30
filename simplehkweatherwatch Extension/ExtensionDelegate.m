//
//  ExtensionDelegate.m
//  simplehkweatherwatch Extension
//
//  Created by carl on 18/3/2016.
//  Copyright © 2016 carl. All rights reserved.
//

#import "ExtensionDelegate.h"
#import <ClockKit/ClockKit.h>
#define kRSS_URL_CurrentWeather @"http://rss.weather.gov.hk/rss/CurrentWeather.xml"
#define kRSS_URL_LocalWeatherForecast @"http://rss.weather.gov.hk/rss/LocalWeatherForecast.xml"
#define kRSS_URL_warning @"http://rss.weather.gov.hk/rss/WeatherWarningSummaryv2.xml"

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    // Perform any final initialization of your application.
    
    NSDate *now = [NSDate date];
    [WKExtension.sharedExtension scheduleBackgroundRefreshWithPreferredDate: now userInfo:nil scheduledCompletion:^(NSError * _Nullable error) {
        
        if(error == nil) {
            NSLog(@"schedule background refresh task successfuly  ");
            
        } else{
            NSLog(@"Error occurred while re-scheduling background refresh: %@",error.localizedDescription);
        }
    }];
    
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self refreshComplications];
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}

- (void) scheduleURLSession
{
    NSLog(@"Scheduling URL Session...");
    NSURLSessionConfiguration *backgroundSessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString ];
    
    backgroundSessionConfig.sessionSendsLaunchEvents = YES;
    NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfig];
    NSURLSessionDataTask *dataTask = [backgroundSession dataTaskWithURL:[NSURL URLWithString:kRSS_URL_CurrentWeather]];
    [dataTask resume];
}


//
- (void)handleBackgroundTasks:(NSSet<WKRefreshBackgroundTask *> *)backgroundTasks
{
    for (WKRefreshBackgroundTask * task in backgroundTasks) {
        
        if ([task isKindOfClass:[WKApplicationRefreshBackgroundTask class]]) {
            // location update methods schedule as background task
            [self scheduleURLSession];
            savedTask = task;
            //[backgroundTask setTaskCompleted];
            
        } else if ([task isKindOfClass:[WKSnapshotRefreshBackgroundTask class]]) {
            WKSnapshotRefreshBackgroundTask *snapshotTask = (WKSnapshotRefreshBackgroundTask*)task;
            [snapshotTask setTaskCompletedWithDefaultStateRestored:YES estimatedSnapshotExpiration:[NSDate distantFuture] userInfo:nil];
            
        } else if ([task isKindOfClass:[WKWatchConnectivityRefreshBackgroundTask class]]) {
            WKWatchConnectivityRefreshBackgroundTask *backgroundTask = (WKWatchConnectivityRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompletedWithSnapshot: YES];
            
        } else if ([task isKindOfClass:[WKURLSessionRefreshBackgroundTask class]]) {
            WKURLSessionRefreshBackgroundTask *urlSessionBackgroundTask = (WKURLSessionRefreshBackgroundTask*)task;
            NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:urlSessionBackgroundTask.sessionIdentifier ];
            NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfigObject delegate: self delegateQueue: nil];
            NSLog(@"Rejoining session %@", backgroundSession);
            
            //let backgroundConfigObject = URLSessionConfiguration.background(withIdentifier: urlSessionTask.sessionIdentifier)
            //let backgroundSession = URLSession(configuration: backgroundConfigObject, delegate: self, delegateQueue: nil)
            //print("Rejoining session ", backgroundSession)
            
            
            [urlSessionBackgroundTask setTaskCompletedWithSnapshot: YES];
            
        } else {
            [task setTaskCompletedWithSnapshot: NO];
        }
    }
}


// MARK: URLSession handling


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSMutableData *responseData = self.responsesData[@(dataTask.taskIdentifier)];
    if (!responseData) {
        responseData = [NSMutableData dataWithData:data];
        self.responsesData[@(dataTask.taskIdentifier)] = responseData;
    } else {
        [responseData appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSLog(@"URLSession: task: didCompleteWithError");
    if (error) {
        NSLog(@"URLSession: task: didCompleteWithError %@ failed: %@", task.originalRequest.URL, error);
    }
    
    NSMutableData *responseData = self.responsesData[@(task.taskIdentifier)];
    
    if (responseData) {
        
        NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseData = %@", dataString);
        
        // handle response
        
        NSRange rangeAirTemp = [dataString rangeOfString:@"Air temperature : "];
        
        if ( rangeAirTemp.location == NSNotFound ) {
            return;
        } else {
            NSRange rangeAirTempNum = { rangeAirTemp.location + rangeAirTemp.length, 2};
            strTempDegree = [dataString substringWithRange: rangeAirTempNum];
            //self.lblTempDegree.text = strTempDegree;
//            self.labelDegree.text = strTempDegree;
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
//            self.labelRH.text = [NSString stringWithFormat:@"RH %@%%", strHumidity];
        }
        
        
        //
        NSRange rangeUV = [dataString rangeOfString:@"the mean UV Index recorded at King's Park : "];
        
        if ( rangeUV.location == NSNotFound ) {
            //return;
//            self.labelUV.text = @"UV - ";
        } else {
            NSRange rangeUVNum = { rangeUV.location + rangeUV.length, 3};
            strUV = [dataString substringWithRange: rangeUVNum];
            strUV = [strUV stringByReplacingOccurrencesOfString:@"<b" withString:@""];
//            self.labelUV.text = [NSString stringWithFormat:@"UV %@", strUV]; 
        }
        
        //
        NSRange rangeUpdateTime = [dataString rangeOfString:@"Bulletin updated at "];
        
        if ( rangeUpdateTime.location == NSNotFound ) {
            return;
        } else {
            NSRange rangeUpdateTimeText = { rangeUpdateTime.location + rangeUpdateTime.length, 6};
            strUpdateTime = [[dataString substringWithRange: rangeUpdateTimeText] stringByReplacingOccurrencesOfString:@"HKT " withString:@"  "];
            //self.lblUpdateTime.text = strUpdateTime;
//            self.labelTime.text = strUpdateTime;
        }
        ////
        
        NSDate *now = [NSDate date];
        [[WKExtension sharedExtension] scheduleSnapshotRefreshWithPreferredDate:now userInfo:nil scheduledCompletion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"scheduleSnapshotRefreshWithPreferredDate return error %@", error);
            }
        }];
        
        
        [self.responsesData removeObjectForKey:@(task.taskIdentifier)];
        [self refreshComplications];
        [savedTask setTaskCompletedWithSnapshot: YES];
    } else {
        NSLog(@"responseData is nil");
    }
}

- (void)refreshComplications {
    CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
    for(CLKComplication *complication in server.activeComplications) {
        [server reloadTimelineForComplication:complication];
    }
}
@end
