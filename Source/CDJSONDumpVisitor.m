
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
#import "CDSearchPathState.h"

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

- (void)createOutputPathIfNecessary;
{
    if (self.outputPath != nil) {
        BOOL isDirectory;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:self.outputPath isDirectory:&isDirectory] == NO) {
            NSError *error = nil;
            BOOL result = [fileManager createDirectoryAtPath:self.outputPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (result == NO) {
                NSLog(@"Error: Couldn't create output directory: %@", self.outputPath);
                NSLog(@"error: %@", error); // TODO: Test this
                return;
            }
        } else if (isDirectory == NO) {
            NSLog(@"Error: File exists at output path: %@", self.outputPath);
            return;
        }
    }
}

#pragma mark -

- (void)willBeginVisiting;
{
}

- (void)didEndVisiting;
{
    CDArch arch = self.classDump.targetArch;
    NSString *archName = CDNameForCPUType(arch.cputype, arch.cpusubtype);
    NSString *executablePath = self.classDump.searchPathState.executablePath;
    NSString *frameworkName = CDImportNameForPath(executablePath);
    
    [self createOutputPathIfNecessary];
    
    if (self.outputPath) {
        if (self.useSeparateFiles) {
            for (NSDictionary *objectDictionary in self.objecsArray) {
                
                NSString *filePath = nil;
                NSString *type = objectDictionary[@"type"];
                if ([type isEqualToString:@"class"]) {
                    NSString *className = objectDictionary[@"className"];
                    filePath = [NSString stringWithFormat:@"%@.json", className];
                } else if ([type isEqualToString:@"category"]) {
                    NSString *className = objectDictionary[@"className"];
                    NSString *categoryName = objectDictionary[@"categoryName"];
                    filePath = [NSString stringWithFormat:@"%@-%@.json", className, categoryName];
                } else if ([type isEqualToString:@"protocol"]) {
                    NSString *protocolName = objectDictionary[@"protocolName"];
                    filePath = [NSString stringWithFormat:@"%@-Protocol.json", protocolName];
                } else {
                    NSAssert(nil, @"Not supported type.");
                }
                filePath = [self.outputPath stringByAppendingPathComponent:filePath];
                
                NSDictionary *dict;
                NSError *error;
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                    @autoreleasepool {
                        NSData *oldData = [NSData dataWithContentsOfFile:filePath];
                        NSMutableDictionary *oldDict = [NSJSONSerialization JSONObjectWithData:oldData options:NSJSONReadingMutableContainers error:&error];
                        if (error) {
                            NSLog(@"%@", error);
                            exit(6);
                        }
                        
                        oldDict[archName] = objectDictionary;
                        dict = [oldDict copy];
                    }
                } else {
                    dict = @{archName: objectDictionary};
                }
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
                if (error) {
                    NSLog(@"%@", error);
                    exit(7);
                }
                
                [jsonData writeToFile:filePath atomically:YES];
            }
        } else {
            NSString *filePath = [NSString stringWithFormat:@"%@.json", frameworkName];
            filePath = [self.outputPath stringByAppendingPathComponent:filePath];
            
            NSDictionary *dict;
            NSError *error;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                @autoreleasepool {
                    NSData *oldData = [NSData dataWithContentsOfFile:filePath];
                    NSMutableDictionary *oldDict = [NSJSONSerialization JSONObjectWithData:oldData options:NSJSONReadingMutableContainers error:&error];
                    if (error) {
                        NSLog(@"%@", error);
                        exit(6);
                    }
                    
                    oldDict[archName] = self.objecsArray;
                    dict = [oldDict copy];
                }
            } else {
                dict = @{archName: self.objecsArray};
            }
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            if (error) {
                NSLog(@"%@", error);
                exit(7);
            }
            
            [jsonData writeToFile:filePath atomically:YES];
        }
    } else {
        NSError *error;
        NSDictionary *data = @{archName: self.objecsArray};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"%@", error);
            exit(7);
        }
        
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
