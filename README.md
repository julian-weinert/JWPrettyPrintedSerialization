JWPrettyPrintedSerialization
============================

**A parser and composer for pretty printed arrays

`JWPrettyPrintedSerialization` is a class that can parse and compose strings that represent arrays and dictionaries in the pretty printed array notation like PHP's `print_r` returns.

`JWPrettyPrintedSerialization` comes with following features:

- Parse pretty printed arrays to create `NSArray` resp. `NSDictionary`
- Composes many objects to pretty printed strings
- Convert from and to JSON
- Automatic Reference Counting

## Installation

Easily drop the class into your project

## Usage

``` objective-c
NSString *prettyPrintedArray = @"Array([0]=>\"ABC\",[1]=>Array([a]=>123,[b]=>\"XYZ\"))";
NSArray *object = [JWPrettyPrintedSerialization prettyPrintedObjectWithString:prettyPrintedArray error:nil];
NSString *prettyPrinted = [JWPrettyPrintedSerialization stringWithPrettyPrintedObject:object error:nil];
NSString *JSONString = [JWPrettyPrintedSerialization JSONWithPrettyPrintedString:prettyPrinted] error:nil];
```

## Methods

``` objective-c
+ (id)prettyPrintedObjectWithString:(NSString *)string error:(NSError **)error;
+ (NSString *)stringWithPrettyPrintedObject:(id)object error:(NSError **)error;

+ (id)prettyPrintedObjectWithData:(NSData *)data error:(NSError **)error;
+ (NSData *)dataWithPrettyPrintedObject:(id)object error:(NSError **)error;

+ (NSInteger)writePrettyPrintedObject:(id)object toStream:(NSOutputStream *)stream error:(NSError **)error;
+ (id)prettyPrintedObjectWithStream:(NSInputStream *)stream error:(NSError **)error;

+ (NSString *)prettyPrintedStringWithJSON:(NSString *)JSON error:(NSError **)error;
+ (NSString *)JSONWithPrettyPrintedString:(NSString *)string error:(NSError **)error;
```

## Contact / Reference

Julian Weinert

- https://github.com/julian-weinert
- https://stackoverflow.com/users/1041122/julian

## License

`JWPrettyPrintedSerialization` is available under the GPL V2 license. See the LICENSE file for more info.