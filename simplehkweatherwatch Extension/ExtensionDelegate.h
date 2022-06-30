//
//  ExtensionDelegate.h
//  simplehkweatherwatch Extension
//
//  Created by carl on 18/3/2016.
//  Copyright © 2016 carl. All rights reserved.
//

#import <WatchKit/WatchKit.h>

@interface ExtensionDelegate : NSObject <WKExtensionDelegate>
{
    NSString *strTempDegree;
    NSString *strHumidity;
    NSString *strUV;
    NSString *strUpdateTime;
    NSString *strForecast;
    NSString *Desc;
    
    WKRefreshBackgroundTask *savedTask;
}
@property (nonatomic,strong) NSMutableDictionary *responsesData;

@end
