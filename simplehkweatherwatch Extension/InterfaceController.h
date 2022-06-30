//
//  InterfaceController.h
//  simplehkweather WatchKit Extension
//
//  Created by carl on 25/4/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController <NSURLConnectionDelegate, WKExtensionDelegate, NSURLSessionDataDelegate>
{
    NSString *strTempDegree;
    NSString *strHumidity;
    NSString *strUV;
    NSString *strUpdateTime;
    NSString *strForecast;
    NSString *Desc;
    
//    WKRefreshBackgroundTask *savedTask;
    
}


//@property (nonatomic,strong) NSMutableDictionary* dictMoreInfo;
//@property (nonatomic,strong) NSMutableDictionary *responsesData;
//@property (weak, nonatomic) IBOutlet WKInterfaceButton *btnMore;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelDegree;

@property (weak, nonatomic) IBOutlet WKInterfaceImage *imageWeatherIcon;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelWeather;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelTime;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelRH;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelUV;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelWarning;

@end
