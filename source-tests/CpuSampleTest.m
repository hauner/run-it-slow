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
#import "CpuSample.h"
#import "TimeSpan.h"

// libs
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


@interface CpuSampleTest : SenTestCase {
}

@end


@implementation CpuSampleTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testShouldEqualItself {
  id s = [CpuSample withPid:1 Cpu:[TimeSpan zero]];
  STAssertTrue ([s isEqual:s], @"");
}

- (void)testShouldEqualIdentical {
  id s1 = [CpuSample withPid:1 Cpu:[TimeSpan zero]];
  id s2 = [CpuSample withPid:1 Cpu:[TimeSpan zero]];
  STAssertTrue ([s1 isEqual:s2], @"");
}

- (void)testShouldNotEqualOnPid {
  id s1 = [CpuSample withPid:1 Cpu:[TimeSpan zero]];
  id s2 = [CpuSample withPid:2 Cpu:[TimeSpan zero]];
  STAssertFalse ([s1 isEqual:s2], @"");
}

- (void)testShouldNotEqualDifferentCpu {
  id s1 = [CpuSample withPid:1 Cpu:[TimeSpan withNanoSeconds:1]];
  id s2 = [CpuSample withPid:1 Cpu:[TimeSpan withNanoSeconds:2]];
  STAssertFalse ([s1 isEqual:s2], @"");
}

- (void)testShouldNotEqualOtherClass {
  id s1 = [CpuSample withPid:1 Cpu:[TimeSpan zero]];
  id s2 = [NSObject new]; 
  STAssertFalse ([s1 isEqual:s2], @"");
}

- (void)testShouldNotEqualNil {
  id s = [CpuSample withPid:1 Cpu:[TimeSpan zero]];
  STAssertFalse ([s isEqual:nil], @"");
}


@end
