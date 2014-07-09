//
//  CDJSONDumpVisitor.m
//  class-dump
//
//  Created by Bartosz Janda on 09.07.2014.
//
//

#import "CDJSONDumpVisitor.h"

@interface CDJSONDumpVisitor ()

@property (strong, nonatomic) NSMutableArray *classesArray;

@end

@implementation CDJSONDumpVisitor

- (id)init
{
    self = [super init];
    if (self) {
        self.classesArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark -

- (void)willBeginVisiting;
{
}

- (void)didEndVisiting;
{
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

- (void)willVisitOptionalMethods;
{
}

- (void)didVisitOptionalMethods;
{
}

// Called after visiting.
- (void)didVisitObjectiveCProcessor:(CDObjectiveCProcessor *)processor;
{
}

- (void)willVisitProtocol:(CDOCProtocol *)protocol;
{
}

- (void)didVisitProtocol:(CDOCProtocol *)protocol;
{
}

- (void)willVisitClass:(CDOCClass *)aClass;
{
}

- (void)didVisitClass:(CDOCClass *)aClass;
{
}

- (void)willVisitIvarsOfClass:(CDOCClass *)aClass;
{
}

- (void)didVisitIvarsOfClass:(CDOCClass *)aClass;
{
}

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
}

- (void)didVisitCategory:(CDOCCategory *)category;
{
}

// Not called.
//- (void)willVisitPropertiesOfCategory:(CDOCCategory *)category;
//{
//}

// Not called.
//- (void)didVisitPropertiesOfCategory:(CDOCCategory *)category;
//{
//}

- (void)visitClassMethod:(CDOCMethod *)method;
{
}

- (void)visitInstanceMethod:(CDOCMethod *)method propertyState:(CDVisitorPropertyState *)propertyState;
{
}

- (void)visitIvar:(CDOCInstanceVariable *)ivar;
{
}

// Not called.
//- (void)visitProperty:(CDOCProperty *)property;
//{
//}

- (void)visitRemainingProperties:(CDVisitorPropertyState *)propertyState;
{
}

@end
