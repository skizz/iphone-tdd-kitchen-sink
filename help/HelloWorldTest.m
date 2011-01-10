#import "TestHelper.h"

@interface HelloWorldTest : GTMTestCase {
}
@end

@implementation HelloWorldTest

- (void) setUp {
    NSLog(@"Inside setup");
}

- (void) tearDown {
    NSLog(@"Inside teardown");
}

- (void) testAddition {
  STAssertEquals(2, 1+1, nil);
}

@end
