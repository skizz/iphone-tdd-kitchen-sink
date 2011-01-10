#import "GTMSenTestCase.h"
#import <UIKit/UIKit.h>


// Add your own asserts, helpers anything else
#define STAssertStringStartsWith(startsWith, actual) STAssertTrue([actual hasPrefix:startsWith], @"'%@' did not start with '%@' string", actual, startsWith)
#define STAssertStringEndsWith(endsWith, actual) STAssertTrue([actual hasSuffix:endsWith], @"'%@' did not end with '%@' string", actual, endsWith)
