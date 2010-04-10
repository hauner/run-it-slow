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
#import "CpuWatcher.h"
#import "CpuSample.h"
#import "CpuSampleFinder.h"
#import "Process.h"
#import "TimeSpan.h"

// libs
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


@interface CpuWatcherTest : SenTestCase {
  NSUInteger countSamples;
  NSArray*   samples;
  id         finder;
}

@end


const pid_t       Pid        = 0;
const NanoSeconds InitialCpu = 50;


@implementation CpuWatcherTest

- (CpuSample*)newSample:(NanoSeconds)usedCpu {
  return [CpuSample withPid:Pid
                        Cpu:[TimeSpan withNanoSeconds:InitialCpu+usedCpu]];
}

- (void)setUp {
  countSamples = 0;
  samples = [NSArray arrayWithObjects:
             [self newSample:0],
             [self newSample:10],
             [self newSample:30],
             [self newSample:40],
             [self newSample:60],
             nil];

  finder = [OCMockObject mockForClass:[CpuSampleFinder class]];
  [[[finder stub] andCall:@selector(returnSample:) onObject:self]
   cpuSampleByGPid:Pid];
}

- (void)tearDown {
}

- (CpuSample*)returnSample:(pid_t)pid {
  return [samples objectAtIndex:countSamples++];
}

- (void)testHasNotReachedCpuLimitAfterInit {
  id proc = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:5]];
  id watcher = [CpuWatcher withProcess:proc Finder:nil Signal:nil];
  [watcher reset];
  BOOL reached = [watcher hasReachedCpuLimit];
  STAssertEquals (NO, reached, @"was YES but should be NO.", nil);
}

- (void)testHasNotReachedCpuLimitAfterMultipleSamples {
  id proc = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:60]];
  id watcher = [CpuWatcher withProcess:proc Finder:finder Signal:nil];
  [watcher reset];
  [watcher sample];
  [watcher sample];
  [watcher sample];
  [watcher sample];
  BOOL reached = [watcher hasReachedCpuLimit];
  STAssertEquals (NO, reached, @"was YES but should be NO.", nil);
}

- (void)testHasReachedCpuLimitIsFalseAfterSingleSample {
  id proc = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:5]];
  id watcher = [CpuWatcher withProcess:proc Finder:finder Signal:nil];
  [watcher reset];
  [watcher sample];
  BOOL reached = [watcher hasReachedCpuLimit];
  STAssertEquals (YES, reached, @"was NO but should be YES.", nil);
}

- (void)testHasReachedCpuLimitAfterMultipleSamples {
  id proc = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:59]];
  id watcher = [CpuWatcher withProcess:proc Finder:finder Signal:nil];
  [watcher reset];
  [watcher sample];
  [watcher sample];
  [watcher sample];
  [watcher sample];
  BOOL reached = [watcher hasReachedCpuLimit];
  STAssertEquals (YES, reached, @"was NO but should be YES.", nil);
}

- (void)testContinuesStoppedProcessOnReset {
  id proc = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:5]];
  id watcher = [CpuWatcher withProcess:proc Finder:nil Signal:nil];
  [proc stop:nil];
  [watcher reset];
  BOOL active = [proc isRunning];
  STAssertEquals (YES, active, @"was NO but should be YES.", nil);  
}

- (void)testStopsProcessWhenCpuLimitIsReached {
  id proc = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:5]];
  id watcher = [CpuWatcher withProcess:proc Finder:finder Signal:nil];
  [watcher reset];
  [watcher sample];
  BOOL running = [proc isRunning];
  STAssertEquals (NO, running, @"was YES but should be NO.", nil);  
}

- (void)testKeepsProcessRunningWhenCpuLimitIsNotReached {
  id proc = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:11]];
  id watcher = [CpuWatcher withProcess:proc Finder:finder Signal:nil];
  [watcher reset];
  [watcher sample];
  BOOL running = [proc isRunning];
  STAssertEquals (YES, running, @"was NO but should be YES.", nil);  
}

@end
