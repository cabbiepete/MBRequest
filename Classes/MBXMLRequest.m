//
//  MBXMLRequest.m
//  MBRequest
//
//  Created by Sebastian Celis on 3/4/12.
//  Copyright (c) 2012 Mobiata, LLC. All rights reserved.
//

#import "MBXMLRequest.h"

#import "MBBaseRequestSubclass.h"

@interface MBXMLRequest ()
@property (nonatomic, retain, readwrite) NSError *error;
@end


@implementation MBXMLRequest

@dynamic error;

#pragma mark - Response

- (void)connectionOperationDidFinish
{
    [super connectionOperationDidFinish];

    if ([self error] == nil && ![self isCancelled])
    {
        // Create an autorelease pool for this parser.
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        // Parse the XML response.
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[[self connectionOperation] responseData]];
        [parser setDelegate:self];
        [parser parse];

        [parser release];
        [pool release];
    }
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (![self isCancelled])
    {
        [self setError:parseError];
    }
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError
{
    if (![self isCancelled])
    {
        [self setError:validError];
    }
}

@end