// -*- mode: ObjC -*-

//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2014 Steve Nygard.

#import "CDOCInstanceVariable.h"

#import "CDClassDump.h"
#import "CDTypeFormatter.h"
#import "CDTypeParser.h"
#import "CDTypeController.h"
#import "CDTypeName.h"
#import "CDType.h"

@interface CDOCInstanceVariable ()
@property (assign) BOOL hasParsedType;
@end

#pragma mark -

@implementation CDOCInstanceVariable
{
    NSString *_name;
    NSString *_typeString;
    NSUInteger _offset;
    NSUInteger _alignment;
    NSUInteger _size;
    
    BOOL _hasParsedType;
    CDType *_type;
    NSError *_parseError;
}

- (id)initWithName:(NSString *)name typeString:(NSString *)typeString offset:(NSUInteger)offset alignment:(NSUInteger)alignment size:(NSUInteger)size
{
    if ((self = [super init])) {
        _name       = name;
        _typeString = typeString;
        _offset     = offset;
        _alignment  = alignment;
        _size       = size;
        
        _hasParsedType = NO;
        _type          = nil;
        _parseError    = nil;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name typeString:(NSString *)typeString offset:(NSUInteger)offset;
{
    if ((self = [self initWithName:name typeString:typeString offset:offset alignment:0 size:0])) {
    }

    return self;
}

#pragma mark - Debugging

- (NSString *)description;
{
    return [NSString stringWithFormat:@"[%@] name: %@, typeString: '%@', offset: %lu",
            NSStringFromClass([self class]), self.name, self.typeString, self.offset];
}

#pragma mark -

- (CDType *)type;
{
    if (self.hasParsedType == NO && self.parseError == nil) {
        CDTypeParser *parser = [[CDTypeParser alloc] initWithString:self.typeString];
        NSError *error;
        _type = [parser parseType:&error];
        if (_type == nil) {
            NSLog(@"Warning: Parsing instance variable type failed, %@", self.name);
            _parseError = error;
        } else {
            self.hasParsedType = YES;
        }
    }

    return _type;
}

- (void)appendToString:(NSMutableString *)resultString typeController:(CDTypeController *)typeController;
{
    CDType *type = [self type]; // Parses it, if necessary;
    if (self.parseError != nil) {
        [resultString appendFormat:@"    // Error parsing type: %@, name: %@", self.typeString, self.name];
    } else {
        NSString *formattedString = [[typeController ivarTypeFormatter] formatVariable:self.name type:type];
        NSParameterAssert(formattedString != nil);
        [resultString appendString:formattedString];
        [resultString appendString:@";"];
        if ([typeController shouldShowIvarOffsets]) {
            [resultString appendFormat:@"\t// %ld = 0x%lx", self.offset, self.offset];
        }
    }
}

- (NSDictionary *)dictionaryRepresentationWithTypeController:(CDTypeController *)typeController
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.name) {
        dictionary[@"name"] = self.name;
    }
    CDType *type = [self type];
    if (type) {
        [type phase0RecursivelyFixStructureNames:NO];
        [type phase3MergeWithTypeController:typeController];
        NSString *typeName = [type formattedString:nil formatter:typeController.ivarTypeFormatter level:0];
        dictionary[@"type"] = typeName;
    }
    dictionary[@"offset"] = @(self.offset);
    dictionary[@"alignment"] = @(self.alignment);
    dictionary[@"size"] = @(self.size);
    
    return [dictionary copy];
}

@end
