//
//  CDJSONDumpVisitor.h
//  class-dump
//
//  Created by Bartosz Janda on 09.07.2014.
//
//

#import "CDVisitor.h"

@interface CDJSONDumpVisitor : CDVisitor

@property (assign, nonatomic) BOOL useSeparateFiles;
@property (strong, nonatomic) NSString *outputPath;

@end
