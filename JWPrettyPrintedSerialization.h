//
//  JWPrettyPrintedSerialization.h
//  JWPrettyPrintedSerialization
//
//  Created by Julian Weinert on 07.01.14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JWPrettyPrintedSerializationOption) {
	JWPrettyPrintedSerializationOptionNone,
	JWPrettyPrintedSerializationOptionPrettyPrinted
};

@interface JWPrettyPrintedSerialization : NSObject

+ (id)prettyPrintedObjectWithString:(NSString *)string error:(NSError **)error;
+ (NSString *)stringWithPrettyPrintedObject:(id)object error:(NSError **)error;

+ (id)prettyPrintedObjectWithData:(NSData *)data error:(NSError **)error;
+ (NSData *)dataWithPrettyPrintedObject:(id)object error:(NSError **)error;

+ (NSInteger)writePrettyPrintedObject:(id)object toStream:(NSOutputStream *)stream error:(NSError **)error;
+ (id)prettyPrintedObjectWithStream:(NSInputStream *)stream error:(NSError **)error;

+ (NSString *)prettyPrintedStringWithJSON:(NSString *)JSON error:(NSError **)error;
+ (NSString *)JSONWithPrettyPrintedString:(NSString *)string error:(NSError **)error;

@end
