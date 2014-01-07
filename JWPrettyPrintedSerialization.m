//
//  JWPrettyPrintedSerialization.m
//  JWPrettyPrintedSerialization
//
//  Created by Julian Weinert on 07.01.14.
//
//

#import "JWPrettyPrintedSerialization.h"

@implementation JWPrettyPrintedSerialization

+ (id)prettyPrintedObjectWithString:(NSString *)string error:(NSError *__autoreleasing *)error {
	return [self _objectFromString:string error:error];
}

+ (NSString *)stringWithPrettyPrintedObject:(id)object error:(NSError *__autoreleasing *)error {
	return [self _stringFromObject:object error:error];
}

+ (id)prettyPrintedObjectWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
	NSString *prettyPrintedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return [self prettyPrintedObjectWithString:prettyPrintedString error:error];
}

+ (NSData *)dataWithPrettyPrintedObject:(id)object error:(NSError *__autoreleasing *)error {
	return [[self stringWithPrettyPrintedObject:object error:error] dataUsingEncoding:NSUTF8StringEncoding];
}

+ (id)prettyPrintedObjectWithStream:(NSInputStream *)stream error:(NSError *__autoreleasing *)error {
	NSMutableData *readData = [NSMutableData data];
	uint8_t buffer[1024];
	
	while ([stream hasBytesAvailable]) {
		NSInteger bytesRead = [stream read:buffer maxLength:sizeof(buffer)];
		[readData appendBytes:buffer length:bytesRead];
	}
	
	return [self prettyPrintedObjectWithData:readData error:error];
}

+ (NSInteger)writePrettyPrintedObject:(id)object toStream:(NSOutputStream *)stream error:(NSError *__autoreleasing *)error {
	NSData *writeData = [self dataWithPrettyPrintedObject:object error:error];
	NSInteger bytesWritten = 0;
	uint8_t buffer[1024];
	
	while ([stream hasSpaceAvailable]) {
		[writeData getBytes:buffer length:sizeof(buffer)];
		bytesWritten += [stream write:buffer maxLength:sizeof(buffer)];
	}
	
	return bytesWritten;
}

+ (NSString *)prettyPrintedStringWithJSON:(NSString *)JSON error:(NSError *__autoreleasing *)error {
	id object = [NSJSONSerialization JSONObjectWithData:[JSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:error];
	
	if (error) {
		return nil;
	}
	
	NSString *string = [self stringWithPrettyPrintedObject:object error:error];
	
	if (error) {
		return nil;
	}
	
	return string;
}

+ (NSString *)JSONWithPrettyPrintedString:(NSString *)string error:(NSError *__autoreleasing *)error {
	id object = [self prettyPrintedObjectWithString:string error:error];
	
	if (error) {
		return nil;
	}
	
	NSString *_string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:0 error:error] encoding:NSUTF8StringEncoding];
	
	if (error) {
		return nil;
	}
	
	return _string;
}

+ (id)_objectFromString:(NSString *)string error:(NSError **)error {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	NSRegularExpression *parser = [NSRegularExpression regularExpressionWithPattern:@"\\[([^\\]]+)\\]=>(Array\\([^\\)]+\\)|[^,\\)]+)?" options:0 error:error];
	
	if (error) {
		return nil;
	}
	
	__block BOOL singleValue = YES;
	
	[parser enumerateMatchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, [string length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		if (result) {
			singleValue = NO;
			[dict setObject:[self _objectFromString:[string substringWithRange:[result rangeAtIndex:2]] error:error] forKey:[string substringWithRange:[result rangeAtIndex:1]]];
		}
	}];
	
	if (singleValue) {
		return string;
	}
	
	for (NSString *key in [dict allKeys]) {
		if ([key rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
			NSMutableDictionary *result = [NSMutableDictionary dictionary];
			
			[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				[result setObject:obj forKey:key];
			}];
			
			return result;
		}
	}
	
	NSMutableArray *result = [NSMutableArray array];
	
	[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[result insertObject:obj atIndex:[key integerValue]];
	}];
	
	return result;
}

+ (NSString *)_stringFromObject:(id)object error:(NSError **)error {
	NSMutableString *str = [NSMutableString string];
	
	if ([object respondsToSelector:@selector(count)] && [object respondsToSelector:@selector(objectAtIndex:)]) {
		[str appendString:@"Array("];
		
		for (int i = 0; i < [object count]; i++) {
			[str appendFormat:@"%@[%i]=>%@", (i == 0 ? @"" : @","), i, [self _stringFromObject:[object objectAtIndex:i] error:error]];
		}
		
		[str appendString:@")"];
	}
	else if ([object respondsToSelector:@selector(allKeys)] && [object respondsToSelector:@selector(objectForKey:)]) {
		[str appendString:@"Array("];
		
		for (NSString *key in [object allKeys]) {
			[str appendFormat:@"%@[%@]=>%@", (key == [[object allKeys] firstObject] ? @"" : @","), key, [self _stringFromObject:[object objectForKey:key] error:error]];
		}
		
		[str appendString:@")"];
	}
	else {
		[str appendFormat:@"%@", object];
	}
	
	return str;
}

@end
