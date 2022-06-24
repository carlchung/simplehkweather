//
//  AirIndexInterfaceController.m
//  simplehkweather
//
//  Created by carl on 6/6/15.
//  Copyright (c) 2015 carl. All rights reserved.
//

#import "AirIndexInterfaceController.h"


#define kRSS_URL_AirIndexSummary @"http://www.aqhi.gov.hk/epd/ddata/html/out/aqhirss_Eng.xml"
#define kRSS_URL_AirIndexSummary_Zh @"http://www.aqhi.gov.hk/epd/ddata/html/out/aqhirss_ChT.xml"

#define LString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


@interface AirIndexInterfaceController ()

@end

@implementation AirIndexInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    
    parseDesc = NO;
    parseHeader = NO;
    
    arrayHeader = [NSMutableArray arrayWithCapacity:0];
    arrayDesc = [NSMutableArray arrayWithCapacity:0];
    //[self loadAirIndexRSS];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    parseDesc = NO;
    parseHeader = NO;

    [self loadAirIndexRSS];
    
    [self invalidateUserActivity];
    NSDictionary *dict = @{@"page":@"airindex"};
    [self updateUserActivity:@"com.metacreate.simplehkweather.airindex" userInfo:dict webpageURL:nil];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
}

- (IBAction)doMenuReload {
    parseDesc = NO;
    parseHeader = NO;
    
    [self loadAirIndexRSS];
}


- (void) loadAirIndexRSS
{
    
    NSString * urlString;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"lang %@", language);
    if ( [language hasPrefix:@"zh"]) {
        urlString = kRSS_URL_AirIndexSummary_Zh;
    } else {
        urlString = kRSS_URL_AirIndexSummary;
    }
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                
                NSString *dataString = [[NSString alloc] initWithData: data  encoding:NSUTF8StringEncoding];
                
                NSLog(@"Air Index dataString:\n%@",dataString);
                
                [arrayHeader removeAllObjects];
                [arrayDesc removeAllObjects];
                
                BOOL success;
                if (self.xhtmlParser) {
                    self.xhtmlParser = nil;
                }
                self.xhtmlParser = [[NSXMLParser alloc] initWithData:data ];
                [self.xhtmlParser setDelegate:self];
                [self.xhtmlParser setShouldResolveExternalEntities:YES];
                success = [self.xhtmlParser parse]; // return value not used
                
                
                
            }] resume];
    
    // Create the request.
    /*
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10.0];
    

    
    [NSURLConnection sendAsynchronousRequest:theRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               //
                               
                               
                           }];
     
     */
}
/*
 <title>香港空氣質素健康指數，發布時間：Sat, 06 Jun 2015 17:30:00 +0800
 當前空氣狀況：</title>
 
 　　<link>http://www.aqhi.gov.hk/tc.html</link><guid isPermaLink="true">http://www.aqhi.gov.hk/tc.html</guid>
 　　<description><![CDATA[<p>一般監測站: 2 至 3 (健康風險：低)</p><p>路邊監測站: 3 (健康風險：低)</p>]]></description>
 　　</item>
 */


- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    //tblCurrAQHI_trHeader
    if ([elementName isEqualToString:@"title"]) {
        parseHeader = YES;
        
    }
    
    if ([elementName isEqualToString:@"description"]) {
        parseDesc = YES;
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ( [string isEqualToString:@" "]) {
        return;
    }
    
    if ( parseHeader ) {
        [arrayHeader addObject:string];
        NSLog(@"arrayHeader add : %@", string);
    }
    
    if ( parseDesc ) {
        [arrayDesc addObject:string];
        NSLog(@"arrayHeader add : %@", string);
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"title"]) {
        
        parseHeader = NO;
        
    }
    
    if ([elementName isEqualToString:@"description"]) {
        
        parseDesc = NO;
        
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"parserDidEndDocument %@ %@", arrayPlace, arrayBand);

    
    if ( [arrayHeader count] >= 2) {
        NSString *strHeader = [arrayHeader objectAtIndex:1];
        
        //strHeader = [strHeader stringByReplacingOccurrencesOfString:@"，發布時間：" withString:@"\n"];
        //strHeader = [strHeader stringByReplacingOccurrencesOfString:@"at : " withString:@"\n"];
        strHeader = [strHeader stringByReplacingOccurrencesOfString:@"+0800" withString:@""];
        strHeader = [strHeader stringByReplacingOccurrencesOfString:@"Current Condition : " withString:@""];
        strHeader = [strHeader stringByReplacingOccurrencesOfString:@"HKSAR Air Quality Health Index at:" withString:@""];
        strHeader = [strHeader stringByReplacingOccurrencesOfString:@"		" withString:@""];
        self.labelHeader.text = strHeader;
    }
    

    if ( [arrayDesc count] >= 2) {
        NSString *strDesc = [arrayDesc objectAtIndex:1];
        strDesc = [strDesc stringByReplacingOccurrencesOfString:@"Stations" withString:@""];
        NSArray *arrayItems = [strDesc componentsSeparatedByString:@"</p><p>"];
        
        //strDesc = [strDesc stringByReplacingOccurrencesOfString:@"(" withString:@"\n("];
        if ( [arrayItems count] >=2 ) {
            self.labelGeneral.text = [arrayItems[0] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
            self.labelRoadside.text = [arrayItems[1] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
            self.labelGeneral.textColor = [self colorByRiskLevel: arrayItems[0]];
            self.labelRoadside.textColor = [self colorByRiskLevel: arrayItems[1]];
                                           
        }
        
    }
    
    
}

- (UIColor*) colorByRiskLevel: (NSString*) str
{
    NSRange rangeType;
    rangeType = [str rangeOfString:@"Serious" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return [UIColor brownColor];
    }
    
    rangeType = [str rangeOfString:@"High" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return [UIColor redColor];
    }
    
    rangeType = [str rangeOfString:@"Moderate" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return [UIColor yellowColor];
    }
    rangeType = [str rangeOfString:@"嚴重" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return [UIColor brownColor];
    }
    
    rangeType = [str rangeOfString:@"高" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return [UIColor redColor];
    }
    
    rangeType = [str rangeOfString:@"中" options:NSCaseInsensitiveSearch];
    if ( rangeType.location != NSNotFound ) {
        return [UIColor yellowColor];
    }
    
    return [UIColor greenColor];
}


@end



