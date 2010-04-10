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
#import "CpuSampleFinder.h"
#import "CpuSample.h"
#import "TimeSpan.h"

// libs
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


@interface CpuSampleFinderTest : SenTestCase {
  CpuSampleFinder* finder;
  CpuSample* expected;
}
@end


const NanoSeconds TimeStampNs = 5;
const NanoSeconds CpuUsageNs  = 32;
const pid_t       UnknownPid  = 10;
const pid_t       ExpectedPid = 2;


@implementation CpuSampleFinderTest

- (id)createFinder:(id<CpuSampleProvider>)provider {
  return [[CpuSampleFinder alloc] initWithProvider:provider];
}

- (id<CpuSampleProvider>)createProvider {
  id prov = [OCMockObject mockForProtocol:@protocol(CpuSampleProvider)];

  id samples = [NSArray arrayWithObjects:
                [CpuSample withPid:1 Cpu:[TimeSpan zero]],
                expected, 
                [CpuSample withPid:3 Cpu:[TimeSpan zero]],
                nil];

  [[[prov stub] andReturn:samples] samples];
  return prov;
} 

- (CpuSample*)createSample {
  return [CpuSample withPid:ExpectedPid 
                        Cpu:[TimeSpan withNanoSeconds:CpuUsageNs]];
}

- (void)setUp {
  expected = [self createSample];
  finder = [self createFinder:[self createProvider]];
}

- (void)tearDown {
}


- (void)testShouldFindCpuSampleByPid {
  id sample = [finder cpuSampleByPid: ExpectedPid];
  STAssertNotNil (sample, @"");
  STAssertTrue ([sample isEqual: expected], @"");
}


- (void)testShouldReturnNilForUnknownPid {
  id sample = [finder cpuSampleByPid: UnknownPid];
  STAssertNil (sample, @"");
}


@end
