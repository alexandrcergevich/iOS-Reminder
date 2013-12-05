//
//  XMLReaderCurrency.m
//  AlarmAndClock
//
//  Created by Alexandr on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLReaderCurrency.h"


@implementation XMLReaderCurrency
@synthesize currentItem, contentOfCurrentBlock;
@synthesize totalCount, itemArray;

- (void)parseXMLWithData:(NSData*)data parseError:(NSError**)error {
	
	self.itemArray = [NSMutableArray arrayWithCapacity:5];
	self.currentItem = [[CurrencyItem alloc] init];
	[self.itemArray addObject:currentItem];
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
	
	if ([elementName isEqualToString:@"Cube"])
	{
		
		NSString *currencyName = [attributeDict objectForKey:@"currency"];
		NSString *rateString = [attributeDict objectForKey:@"rate"];
		if (currencyName == nil || rateString == nil)
			return;
		float rate = [rateString floatValue];
		if ([currencyName isEqualToString:@"USD"])
			self.currentItem.usd = rate;
		else if ([currencyName isEqualToString:@"JPY"])
			self.currentItem.jpy = rate;
		else if ([currencyName isEqualToString:@"GBP"])
			self.currentItem.gbp = rate;
		else if ([currencyName isEqualToString:@"AUD"])
			self.currentItem.aud = rate;
		else if ([currencyName isEqualToString:@"CNY"])
			self.currentItem.cny = rate;
		else if ([currencyName isEqualToString:@"CAD"])
			self.currentItem.cad = rate;
		else if ([currencyName isEqualToString:@"HKD"])
			self.currentItem.hkd = rate;
	}
	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
	if (qName) {
		elementName = qName;
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
