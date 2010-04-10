// Slow
#import "Clock.h"
#import "TimeSpan.h"

// extern
#import <SenTestingKit/SenTestingKit.h>


@interface ClockTest : SenTestCase {
  
}

@end


@implementation ClockTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testClockReturnsIncreasingTimeStamps {
  id ts1 = [Clock now];
    
  for (int i = 0; i < 10; ++i) {
    id ts2 = [Clock now];
    STAssertTrue ([ts2 ns] > [ts1 ns], @"");

    ts1 = ts2;
  }
}


@end
