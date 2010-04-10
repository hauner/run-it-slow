/**
 * ==========================================================================
 * Copyright (c) 2010  Martin Hauner
 *                     http://code.google.com/p/run-it-slow
 *
 * This file is part of "run it slow".
 *
 * "run it slow" is free software: you  can redistribute  it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License,  or (at your option)
 * any later version.
 *
 * "run it slow" is  distributed  in  the  hope  that  it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS  FOR A  PARTICULAR PURPOSE. See the  GNU General Public License
 * for more details.
 *
 * You should have  received a copy of the  GNU General Public License  along
 * with "run it slow". If not, see <http://www.gnu.org/licenses/>.
 * ==========================================================================
 */

// slow
#import "TimeSpan.h"

// lib
#import <SenTestingKit/SenTestingKit.h>


@interface TimeSpanTest : SenTestCase {
  
}

@end



@implementation TimeSpanTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testCreateWithZeroIsZero {
  id s = [TimeSpan zero];
  STAssertEquals ((NanoSeconds)0, [s ns], @"");
}

- (void)testShouldEqualItself {
  id s = [TimeSpan withNanoSeconds:10];
  STAssertTrue ([s isEqual:s], @"");
}

- (void)testShouldEqualIdentical {
  id s1 = [TimeSpan withNanoSeconds:10];
  id s2 = [TimeSpan withNanoSeconds:10];
  STAssertTrue ([s1 isEqual:s2], @"");
}

- (void)testShouldNotEqual {
  id s1 = [TimeSpan withNanoSeconds:10];
  id s2 = [TimeSpan withNanoSeconds:11];
  STAssertFalse ([s1 isEqual:s2], @"");
}

- (void)testShouldNotEqualOtherClass {
  id s = [TimeSpan withNanoSeconds:10];
  id o = [NSObject new]; 
  STAssertFalse ([s isEqual:o], @"");
}

- (void)testShouldNotEqualNil {
  id s = [TimeSpan withNanoSeconds:10];
  STAssertFalse ([s isEqual:nil], @"");
}

- (void)testShouldConvertToMicroSeconds {
  id s = [TimeSpan withNanoSeconds:1000];
  STAssertEquals ((MicroSeconds)1, [s us], @"");
  s = [TimeSpan withNanoSeconds:2000];
  STAssertEquals ((MicroSeconds)2, [s us], @"");
  s = [TimeSpan withNanoSeconds:3000];
  STAssertEquals ((MicroSeconds)3, [s us], @"");
}

- (void)testShouldConvertToMilliSeconds {
  id s = [TimeSpan withNanoSeconds:1000000];
  STAssertEquals ((MilliSeconds)1, [s ms], @"");
  s = [TimeSpan withNanoSeconds:2000000];
  STAssertEquals ((MilliSeconds)2, [s ms], @"");
  s = [TimeSpan withNanoSeconds:3000000];
  STAssertEquals ((MilliSeconds)3, [s ms], @"");
}

- (void)testSubstractToZero {
  id span1 = [TimeSpan withNanoSeconds:1];
  id span2 = [TimeSpan withNanoSeconds:1];
  id span = [span1 sub: span2];
  STAssertEquals ( (NanoSeconds)0, [span ns], @"");
}

- (void)testSubstractToPositive {
  id span1 = [TimeSpan withNanoSeconds:10];
  id span2 = [TimeSpan withNanoSeconds:3];
  id span = [span1 sub: span2];
  STAssertEquals ( (NanoSeconds)7, [span ns], @"");
}

- (void)testSubstractToNegative {
  id span1 = [TimeSpan withNanoSeconds:3];
  id span2 = [TimeSpan withNanoSeconds:10];
  id span = [span1 sub: span2];
  STAssertEquals ( (NanoSeconds)-7, [span ns], @"");
}

- (void)testAddPositive {
  TimeSpan* span1 = [TimeSpan withNanoSeconds:1];
  TimeSpan* span2 = [TimeSpan withNanoSeconds:2];
  id span = [span1 add: span2];
  STAssertEquals ( (NanoSeconds)3, [span ns], @"");
}

- (void)testAddNegative {
  TimeSpan* span1 = [TimeSpan withNanoSeconds:-1];
  TimeSpan* span2 = [TimeSpan withNanoSeconds:-2];
  id span = [span1 add: span2];
  STAssertEquals ( (NanoSeconds)-3, [span ns], @"");
}

- (void)testAddToZero {
  TimeSpan* span1 = [TimeSpan withNanoSeconds:-1];
  TimeSpan* span2 = [TimeSpan withNanoSeconds:+1];
  id span = [span1 add: span2];
  STAssertEquals ( (NanoSeconds)0, [span ns], @"");
}

@end
