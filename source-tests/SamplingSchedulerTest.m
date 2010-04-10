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
#import "SamplingScheduler.h"
#import "CpuWatcher.h"

// libs
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


@interface SamplingSchedulerTest : SenTestCase {
  id  watcher;
  int resolution;
  
  int watcher_reset;
  int watcher_sample;
}

@end


@implementation SamplingSchedulerTest


- (void)reset {
  watcher_reset++;
}

- (void)sample {
  watcher_sample++;
}

- (void)resetWatcher {
  watcher_reset = 0;
  watcher_sample = 0;
}

- (void)setUp {
  resolution = 10;
  watcher = [OCMockObject mockForClass:[CpuWatcher class]];
  [[[watcher stub] andCall:@selector(reset) onObject:self] reset];
  [[[watcher stub] andCall:@selector(sample) onObject:self] sample];
  [self resetWatcher];
}

- (void)tearDown {
}

- (void)testFirstTickInitsSampling {
  id sched = [SamplingScheduler withCpuWatcher:watcher Resolution:resolution];
  
  [sched tick];
  STAssertEquals (1, watcher_reset, @"");
  STAssertEquals (0, watcher_sample, @"");
}

- (void)testSecondToMaxTickContinueSampling {
  id sched = [SamplingScheduler withCpuWatcher:watcher Resolution:resolution];
  [sched tick];
  
  for (int i = 1; i < resolution; i++) {
    [sched tick];
    STAssertEquals (1, watcher_reset, @"");
    STAssertEquals (i, watcher_sample, @"");
  }
}

- (void)testMaxTickResetsSampling {
  id sched = [SamplingScheduler withCpuWatcher:watcher Resolution:resolution];

  for (int i = 0; i < resolution; i++) {
    [sched tick];
  }
  [self resetWatcher];
  
  [sched tick];
  STAssertEquals (1, watcher_reset, @"");
  STAssertEquals (0, watcher_sample, @"");
}

@end
