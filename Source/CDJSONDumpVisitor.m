//
//  CDJSONDumpVisitor.m
//  class-dump
//
//  Created by Bartosz Janda on 09.07.2014.
//
//

#import "CDJSONDumpVisitor.h"

#import "CDClassDump.h"
#import "CDOCClass.h"
#import "CDOCCategory.h"
#import "CDFile.h"

@interface CDJSONDumpVisitor ()

@property (strong, nonatomic) NSMutableArray *objecsArray;

@end

@implementation CDJSONDumpVisitor

- (id)init
{
    self = [super init];
    if (self) {
        self.objecsArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark -

- (void)willBeginVisiting;
{
}

- (void)didEndVisiting;
{
    NSError *error;
    
    CDArch arch = self.classDump.targetArch;
    NSString *archName = CDNameForCPUType(arch.cputype, arch.cpusubtype);
    NSDictionary *data = @{archName: self.objecsArray};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"%@", error);
        exit(6);
    }
    
    if (self.outputPath) {
        NSString *filePath = [NSString stringWithFormat:@"%@.json", archName];
        filePath = [self.outputPath stringByAppendingPathComponent:filePath];
        [jsonData writeToFile:filePath atomically:YES];
    } else {
        [(NSFileHandle *)[NSFileHandle fileHandleWithStandardOutput] writeData:jsonData];
    }
}

// Called before visiting.
- (void)willVisitObjectiveCProcessor:(CDObjectiveCProcessor *)processor;
{
}

// This gets called before visiting the children, but only if it has children it will visit.
- (void)visitObjectiveCProcessor:(CDObjectiveCProcessor *)processor;
{
}

// Not called.
//- (void)willVisitPropertiesOfProtocol:(CDOCProtocol *)protocol;
//{
//}

// Not called.
//- (void)didVisitPropertiesOfProtocol:(CDOCProtocol *)protocol;
//{
//}

// Not used.
//- (void)willVisitOptionalMethods;
//{
//}

// Not used.
//- (void)didVisitOptionalMethods;
//{
//}

// Called after visiting.
- (void)didVisitObjectiveCProcessor:(CDObjectiveCProcessor *)processor;
{
}

- (void)willVisitProtocol:(CDOCProtocol *)protocol;
{
    @autoreleasepool {
        NSDictionary *protocolDictionaryRepresentation = [protocol dictionaryRepresentationWithTypeController:self.classDump.typeController];
        [self.objecsArray addObject:protocolDictionaryRepresentation];
    }
}

// Not used.
//- (void)didVisitProtocol:(CDOCProtocol *)protocol;
//{
//}

- (void)willVisitClass:(CDOCClass *)aClass;
{
    @autoreleasepool {
        NSDictionary *classDictionaryRepresentation = [aClass dictionaryRepresentationWithTypeController:self.classDump.typeController];
        [self.objecsArray addObject:classDictionaryRepresentation];
    }
}

// Not used.
//- (void)didVisitClass:(CDOCClass *)aClass;
//{
//}

// Not used.
//- (void)willVisitIvarsOfClass:(CDOCClass *)aClass;
//{
//}

// Not used.
//- (void)didVisitIvarsOfClass:(CDOCClass *)aClass;
//{
//}

// Not called.
//- (void)willVisitPropertiesOfClass:(CDOCClass *)aClass;
//{
//}

// Not called.
//- (void)didVisitPropertiesOfClass:(CDOCClass *)aClass;
//{
//}

- (void)willVisitCategory:(CDOCCategory *)category;
{
    @autoreleasepool {
        NSDictionary *categoryDictionaryRepresentation = [category dictionaryRepresentationWithTypeController:self.classDump.typeController];
        [self.objecsArray addObject:categoryDictionaryRepresentation];
    }
}

// Not used.
//- (void)didVisitCategory:(CDOCCategory *)category;
//{
//}

// Not called.
//- (void)willVisitPropertiesOfCategory:(CDOCCategory *)category;
//{
//}

// Not called.
//- (void)didVisitPropertiesOfCategory:(CDOCCategory *)category;
//{
//}

// Not used.
//- (void)visitClassMethod:(CDOCMethod *)method;
//{
//}

// Not used.
//- (void)visitInstanceMethod:(CDOCMethod *)method propertyState:(CDVisitorPropertyState *)propertyState;
//{
//}

// Not used.
//- (void)visitIvar:(CDOCInstanceVariable *)ivar;
//{
//}

// Not called.
//- (void)visitProperty:(CDOCProperty *)property;
//{
//}

// Not used.
//- (void)visitRemainingProperties:(CDVisitorPropertyState *)propertyState;
//{
//}

@end
