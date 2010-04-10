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
#import "KernelProcessLister.h"
#import "KernelProcess.h"
#import "TimeSpan.h"
#import "Clock.h"

// sys
#import <SenTestingKit/SenTestingKit.h>


@interface KernelProcessListerTest : SenTestCase {
  KernelProcessLister* processes;
}

@end


@implementation KernelProcessListerTest


- (void)setUp {
  processes = [KernelProcessLister new];
  [processes allocate];
}

- (void)tearDown {
  [processes release];
}

- (void)testShouldReturnNonEmptyProcessList {
  NSArray* array = [processes get];
  STAssertTrue (0 < [array count], @"");

  for (KernelProcess* kp in array) {
    STAssertTrue (kp != nil, @"");
  }
}

- (void)testShouldHaveACurrentTimeStamp {
  MilliSeconds expected = [[Clock now] ms];
  MilliSeconds actual = [[processes timeStamp] ms];
  
  STAssertTrue (expected > actual, @"");
  STAssertEqualsWithAccuracy (expected, actual, 500, @"");
}

@end
