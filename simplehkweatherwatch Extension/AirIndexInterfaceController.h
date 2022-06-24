//
//  AirIndexInterfaceController.h
//  simplehkweather
//
//  Created by carl on 6/6/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>


@interface AirIndexInterfaceController : WKInterfaceController <NSXMLParserDelegate>
{
    BOOL parseDesc,  parseHeader;
    
    NSMutableArray *arrayHeader;
    NSMutableArray *arrayDesc ;
    
}


@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelHeader;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelGeneral;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelRoadside;

@property (nonatomic, strong) NSXMLParser *xhtmlParser;

@end
