// -*- mode: ObjC -*-

//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2014 Steve Nygard.

@class CDType, CDTypeController;

@interface CDOCInstanceVariable : NSObject

- (id)initWithName:(NSString *)name typeString:(NSString *)typeString offset:(NSUInteger)offset alignment:(NSUInteger)alignment size:(NSUInteger)size;
- (id)initWithName:(NSString *)name typeString:(NSString *)typeString offset:(NSUInteger)offset;

@property (readonly) NSString *name;
@property (readonly) NSString *typeString;
@property (readonly) NSUInteger offset;
@property (readonly) NSUInteger alignment;
@property (readonly) NSUInteger size;

// Lazily parses the typeString.  Returns nil and sets the parseError if parsing failed.  Does not try to parse again in the event of an error.
@property (nonatomic, readonly) CDType *type;

// This is set after the typeString has been parsed if there was an error.  Doesn't trigger parsing.
@property (readonly) NSError *parseError;

- (void)appendToString:(NSMutableString *)resultString typeController:(CDTypeController *)typeController;
- (NSDictionary *)dictionaryRepresentation;

@end
