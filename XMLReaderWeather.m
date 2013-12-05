//
//  XMLReaderWeather.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLReaderWeather.h"

@implementation XMLReaderWeather
@synthesize currentItem, contentOfCurrentBlock;
@synthesize totalCount, itemArray;

- (void)parseXMLWithData:(NSData*)data parseError:(NSError**)error {
	
	self.itemArray = [NSMutableArray arrayWithCapacity:100];
	totalCount = 0;
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
	
	[parser release];
}

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
{
    
	self.itemArray = [NSMutableArray arrayWithCapacity:100];
	totalCount = 0;
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
	
	
    [parser setDelegate:self];	
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
    }
    
    [parser release]; 
}
#pragma mark -
#pragma mark NSXMLParser

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
	
	if ([elementName isEqualToString:@"channel"])
	{
		self.currentItem = [[[WeatherItem alloc] init] autorelease];
		totalCount ++;
	}
	
	

	if ([elementName isEqualToString:@"yweather:units"])
	{
		self.currentItem.unitTemperature = [attributeDict objectForKey:@"temperature"];
		self.currentItem.unitDistance = [attributeDict objectForKey:@"distance"];
		self.currentItem.unitPressure = [attributeDict objectForKey:@"pressure"];
		self.currentItem.unitSpeed = [attributeDict objectForKey:@"speed"];
	}
	else if ([elementName isEqualToString:@"yweather:wind"])
	{
		self.currentItem.windSpeed = [attributeDict objectForKey:@"speed"];
	}
	else if ([elementName isEqualToString:@"yweather:condition"])
	{
		self.currentItem.condition = [attributeDict objectForKey:@"text"];
		self.currentItem.code = [attributeDict objectForKey:@"code"];
		self.currentItem.temperature = [attributeDict objectForKey:@"temp"];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
	if (qName) {
		elementName = qName;
	}
	if ([elementName isEqualToString:@"channel"])
	{
		[itemArray addObject:self.currentItem];
	}
	
}



/*
 - (void)loadItemImage {
 NSURL* imageUrl = [NSURL URLWithString:self.currentRSSItem.image];
 self.currentRSSItem.imageData = [NSData dataWithContentsOfURL:imageUrl];
 }
 */

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

	string=(NSString*)[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	////NSLog(@"Class Type : %@ ", string);
	if([string compare:@""] == NSOrderedSame)
		return;	
	/*
	////NSLog(@"foundCharacters >>>>>>>>>>>>>>>>>> %@ ", string);
    if (self.contentOfCurrentBlock) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
		[self.contentOfCurrentBlock appendString:string];	
		
    }
	*/
	// Insert data to sqllite database
	
	
	
}


- (void)dealloc {
	[itemArray release];
	[currentItem release];
	[contentOfCurrentBlock release];
	[super dealloc];
}
@end
