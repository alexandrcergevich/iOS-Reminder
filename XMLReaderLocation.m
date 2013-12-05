//
//  XMLReaderLocation.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLReaderLocation.h"

#define MAX_ITEM_COUNT 10
@implementation XMLReaderLocation
@synthesize currentItem, itemArray, totalCount, contentOfCurrentBlock;

- (id) init {
	if (self = [super init])
	{
		
	}
	return self;
}
- (void)parseXMLWithData:(NSData *)data parseError:(NSError **)error {
	
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
	
	////NSLog(@"didStartElement ================== %@ ", elementName);
	
	
    // If the number of parsed earthquakes is greater than MAX_ELEMENTS, abort the parse.
    // Otherwise the application runs very slowly on the device.
	if (totalCount == MAX_ITEM_COUNT) {
		
        [parser abortParsing];
		return;
    }
	
	if ([elementName isEqualToString:@"Result"])
	{
		totalCount++;
		isFirstGeoPoint = YES;
		self.currentItem = [[[PlaceItem alloc] init] autorelease];
		self.currentItem.addr1 = nil;
		self.currentItem.addr2 = nil;
	}
	else if ([elementName isEqualToString:@"woeid"])
	{
		self.contentOfCurrentBlock = [NSMutableString string];
	}
	else if ([elementName isEqualToString:@"city"])
	{
		self.contentOfCurrentBlock = [NSMutableString string];
	}
	
	else if ([elementName isEqualToString:@"country"])
	{
		self.contentOfCurrentBlock = [NSMutableString string];
	}

	else if ([elementName isEqualToString:@"postal"])
	{
		self.contentOfCurrentBlock = [NSMutableString string];
	}
	
	else if ([elementName isEqualToString:@"latitude"] && isFirstGeoPoint)
	{
		self.contentOfCurrentBlock = [NSMutableString string];
	}
	
	else if ([elementName isEqualToString:@"logitude"] && isFirstGeoPoint)
	{
		self.contentOfCurrentBlock = [NSMutableString string];
	}
	else
	{
		self.contentOfCurrentBlock = nil;
    }
	
	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
	if (qName) {
		elementName = qName;
	}
	
	
	if (totalCount == MAX_ITEM_COUNT) {
		
		[parser abortParsing];
		return;
	}
	if ([elementName isEqualToString:@"city"])
	{
		self.currentItem.placeName = self.contentOfCurrentBlock; 
	}
	
	else if ([elementName isEqualToString:@"woeid"])
	{
		self.currentItem.woeID = self.contentOfCurrentBlock;
	}
	else if ([elementName isEqualToString:@"country"])
	{
		self.currentItem.countryName = self.contentOfCurrentBlock;
	}
	
	else if ([elementName isEqualToString:@"postal"])
	{
		self.currentItem.postal = self.contentOfCurrentBlock;
	}
	
	else if ([elementName isEqualToString:@"latitude"] && isFirstGeoPoint)
	{
		self.currentItem.latitudeCenter = self.contentOfCurrentBlock;
	}
	
	else if ([elementName isEqualToString:@"logitude"] && isFirstGeoPoint)
	{
		self.currentItem.longitudeCenter = self.contentOfCurrentBlock;
		isFirstGeoPoint = NO;
	}
	else if ([elementName isEqualToString:@"Result"])
	{
		[self.itemArray addObject:self.currentItem];
		
		
		NSLog(@"Retriving Place data(%d) - %@, %@, %@", totalCount, currentItem.woeID, currentItem.placeName, currentItem.countryName);
		
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
	if (totalCount == MAX_ITEM_COUNT) {
		
		[parser abortParsing];
		return;
    }
	
	string=(NSString*)[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	////NSLog(@"Class Type : %@ ", string);
	if([string compare:@""] == NSOrderedSame)
		return;	
	
	////NSLog(@"foundCharacters >>>>>>>>>>>>>>>>>> %@ ", string);
    if (self.contentOfCurrentBlock) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
		[self.contentOfCurrentBlock appendString:string];	
		
    }
	
	// Insert data to sqllite database
	
	
	
}


- (void)dealloc {
	[currentItem release];
	[itemArray release];
	[contentOfCurrentBlock release];
	[super dealloc];
}

@end
