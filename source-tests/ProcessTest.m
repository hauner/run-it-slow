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
#import "Process.h"
#import "TimeSpan.h"
#import "ProcessSignaler.h"

// libs
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


static const pid_t Pid = 0;

@interface ProcessTest : SenTestCase {
  
}

@end

@implementation ProcessTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testHasReachedCpuLimitIsFalse {
  id process = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:10]];

  id cpu = [TimeSpan withNanoSeconds:9];
  BOOL reached = [process hasReachedCpuLimit:cpu];
  STAssertEquals (NO, reached, @"was YES, should be NO.", nil);

  cpu = [TimeSpan withNanoSeconds:10];
  reached = [process hasReachedCpuLimit:cpu];
  STAssertEquals (NO, reached, @"was YES, should be NO.", nil);
}

- (void)testHasReachedCpuLimitIsTrue {
  id process = [Process withPid:Pid cpuLimit:[TimeSpan withNanoSeconds:10]];

  id cpu = [TimeSpan withNanoSeconds:11];
  BOOL reached = [process hasReachedCpuLimit:cpu];
  STAssertEquals (YES, reached, @"was NO, should be YES.", nil);
}


- (void)testIsRunningAfterConstruction {
  id process = [Process withPid:Pid cpuLimit:nil];
  BOOL running = [process isRunning];
  STAssertEquals (YES, running, @"was NO, should be YES.", nil);
}

- (void)testIsNotRunningAfterStop {
  Process* process = [Process withPid:Pid cpuLimit:nil];
  [process stop: nil];
  BOOL stopped = ! [process isRunning];
  STAssertEquals (YES, stopped, @"was NO, should be YES.", nil);
}

- (void)testIsRunningAfterContinue {
  Process* process = [Process withPid:Pid cpuLimit:nil];
  [process stop: nil];
  
  [process cont: nil];
  BOOL running = [process isRunning];
  STAssertEquals (YES, running, @"was NO, should be YES.", nil);
}

- (void)testSignalsWhenContinued {
  id process = [Process withPid:Pid cpuLimit:nil];
  [process stop: nil];
  id signal = [OCMockObject mockForClass:[ProcessSignaler class]];
  [[signal expect] contPid:Pid];
  
  [process cont:signal];
  [signal verify];
}

- (void)testSignalsWhenStopped {
  id process = [Process withPid:Pid cpuLimit:nil];
  id signal = [OCMockObject mockForClass:[ProcessSignaler class]];
  [[signal expect] stopPid:Pid];
  
  [process stop:signal];
  [signal verify];
}


@end
