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
#import "KernelProcess.h"
#import "KernelProcessLister.h"
#import "KernelProcessProvider.h"
#import "CpuSample.h"
#import "TimeSpan.h"

// sys
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


@interface KernelProcessProviderTest : SenTestCase {
  TimeSpan* timeStamp; 
  NSArray* sourceSamples;
  NSArray* expectedSamples;
  
  id kernelProcessLister;
}

@end


@implementation KernelProcessProviderTest


- (void)setUp {
  timeStamp = [TimeSpan withNanoSeconds:10];
  
  sourceSamples =
    [NSArray arrayWithObjects:
     [KernelProcess createWithPid:1 PPid:-1 GPid:1 UserNs:100 SystemNs:150],
     [KernelProcess createWithPid:2 PPid:-1 GPid:2 UserNs:200 SystemNs:250],
     [KernelProcess createWithPid:3 PPid: 2 GPid:3 UserNs:300 SystemNs:350],
     nil];
  
  kernelProcessLister = [OCMockObject mockForClass:[KernelProcessLister class]];
  [[[kernelProcessLister stub] andReturn: sourceSamples] get];
  [[[kernelProcessLister stub] andReturn: timeStamp] timeStamp];
  [[kernelProcessLister stub] createProcInfo];
  [[kernelProcessLister stub] releaseProcInfo];
  
  expectedSamples = 
    [NSArray arrayWithObjects:
     [CpuSample withPid:1 Cpu:[TimeSpan withNanoSeconds:250]],
     [CpuSample withPid:2 Cpu:[TimeSpan withNanoSeconds:450]],                 
     [CpuSample withPid:3 Cpu:[TimeSpan withNanoSeconds:650]],
     nil];
}

- (void)tearDown {
}

- (void)testConvertsKernelProcessesToProcesses {
  id provider = [[KernelProcessProvider alloc] init: kernelProcessLister];
  id samples = [provider samples];
 
  STAssertEquals ([samples count], (NSUInteger)3, @"");
  for (NSUInteger idx = 0; idx < [samples count]; ++idx) {
    STAssertEqualObjects (
      [samples objectAtIndex:idx], [expectedSamples objectAtIndex:idx], @"");
  }
}

@end
