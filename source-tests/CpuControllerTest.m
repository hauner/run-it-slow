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
#import "CpuController.h"
#import "CpuWatcher.h"
#import "Process.h"
#import "TimeSpan.h"
//#import "WhatDoIKnow.h"

// libs
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


#if 0
@interface StubCpuWatcher : CpuWatcher {
  int initSamples;
  int samples;
}
- (void)initSampling;
- (void)sample;
- (int)initSamples;
- (int)samples;
@end

@implementation StubCpuWatcher
- (id) init {
  if (self = [super init]) {
    initSamples = 0;
    samples = 0;
  }
  return self;    
}

- (void)initSampling {
  initSamples++;
}

- (void)sample {
  samples++;
}

- (int)initSamples {
  return initSamples;
}

- (int)samples {
  return samples;
}
@end
#endif


#if 0
@interface XXX : WhatDoIKnow {
  int cntReset;
  int cntSample;
}
@end

@implementation XXX
- (id)init {
  if (self = [super init]) {
    cntReset = 0;
    cntSample = 0;
  }
  return self;
}
- (void)reset {
  cntReset++;
}
- (void)sample {
  cntSample++;
}
- (int)cntReset {
  return cntReset;
}
- (int)cntSample {
  return cntSample;
}
@end




@interface CpuControllerTest : SenTestCase {
  
}

@end


@implementation CpuControllerTest

- (void)setUp {
}

- (void)tearDown {
}


- (void)testFirstTickResetsWhatDoIKnow {
  id wdik = [XXX new];
  id ctrl = [CpuController with:wdik];
  
  [ctrl tick];

  STAssertEquals (1,[wdik cntReset], @"");
  STAssertEquals (0,[wdik cntSample], @"");
}

- (void)testSecondToMaxTickSamplesWhatDoIKnow {
  id wdik = [XXX new];
  id ctrl = [CpuController with:wdik];
  
  for (int i = 0; i < 100/*MAX_STEPS*/; i++) {
    [ctrl tick];
    STAssertEquals (1,[wdik cntReset], @"");
    STAssertEquals (i,[wdik cntSample], @"");
  }
  [ctrl tick];

  const int CntTicks = 100/*MAX_STEPS*/ + 1;
  const int CntResets = 2;
  const int CntSamples = CntTicks - CntResets;
  
  STAssertEquals (CntResets,[wdik cntReset], @"");
  STAssertEquals (CntSamples,[wdik cntSample], @"");
}

#if 0
HundredthTicker

STEPS_PER_SECOND = 10;

tick = 10     = reset
tick = 1      = sample
tick = 2      = sample
tick = 3      = sample
tick = 4      = sample
tick = 5      = sample
tick = 6      = sample
tick = 7      = sample
tick = 8      = sample
tick = 9      = sample
tick = 10     = reset
tick = 1



#endif

#if 0
- (void)testInitsWatcherOnInitalTick {
  StubCpuWatcher* watcher = [StubCpuWatcher new];
  id controller = [CpuController withWatcher:watcher];
  [controller tick];
  STAssertEquals (1, [watcher initSamples], @"");
}

- (void)testInitsWatcherAtEveryMaxTick {
  StubCpuWatcher* watcher = [StubCpuWatcher new];
  id controller = [CpuController withWatcher:watcher];
  [controller tick];
  for (int i = 1; i < 100/*MAX_STEPS*/; i++) {
    [controller tick];
    STAssertEquals (1, [watcher initSamples], @"");
  }
  [controller tick];
  STAssertEquals (2, [watcher initSamples], @"");
}

- (void)testDoesNotSampleOnInitialTick {
  StubCpuWatcher* watcher = [StubCpuWatcher new];
  id controller = [CpuController withWatcher:watcher];
  [controller tick];
  STAssertEquals (0, [watcher samples], @"");
}

- (void)testSamplesOnEveryTickButMaxTick {
  StubCpuWatcher* watcher = [StubCpuWatcher new];
  id controller = [CpuController withWatcher:watcher];
  for (int i = 0; i <= 100/*MAX_STEPS*/; i++) {
    [controller tick];
  }
  STAssertEquals (99, [watcher samples], @"");
}
#endif

#if 0
- (void)testSamplesOnlyActiveProcess {
  StubCpuWatcher* watcher = [StubCpuWatcher new];
  id signaler = [OCMockObject mockForClass:[ProcessSignaler class]];
  BOOL retval = NO;
  [[[signaler stub] andReturnValue:OCMOCK_VALUE(retval)] isActive];
  
  id controller = [CpuController withWatcher:watcher signaler:signaler];
  for (int i = 0; i <= 100/*MAX_STEPS*/; i++) {
    [controller tick];
  }
  STAssertEquals (0, [watcher samples], @"");
}
#endif

#if 0
- (void)testDeactivatesProcessIfCpuLimitIsReached {
#if 0
  //CPuWatcher return samples
  
  id controller = [CpuController withWatcher:watcher signaler:signaler];
  
  tick
#endif
}

- (void)testReactivatesProcessOnNewTickInterval {
  
}
#endif

@end
#endif
