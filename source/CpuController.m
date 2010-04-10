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
//#import "WhatDoIKnow.h"


//const int MAX_STEPS        = 100;
//const int TICKS_PER_SECOND = 100;



// TickCounter         => SecondTickCounter
//       ticks
//       intervall

//   CpuLimiter        => CpuLimiter
//   CpuWatcher


@implementation CpuController

- (id)initWith:(WhatDoIKnow*)aWdik {
  if (self = [super init]) {
    wdik = aWdik;
    tick = 100;//MAX_STEPS;
  }
  return self;  
}

+ (id)with:(WhatDoIKnow*)wdik {
  return [[CpuController alloc] initWith:wdik];
}

- (void)tick {
  if (tick == /*TICKS_PER_SECOND*/100) {
    [wdik reset];
    tick = 0;
  } else {
    [wdik sample];
  }
  tick++;

/*
  if (tick == MAX_STEPS) {
    tick = 0;
    [watcher initSampling];
  } else {
    //if ([signaler isActive]) {
    [watcher sample];
    if ([watcher hasReachedCpuLimit]) {
      //[signaler deactivate];
    }
    //}
  }
 */
}








#if 0
// test   deactivate when cpu limit reached
given limit
given samples
given process
// test   reactivate when ticks overflows

- (void)tick {
  if (tick == MAX_STEPS) {
    tick = 0;
    [self reset];
  } else {
    [self sample];
  }
  tick++;
}

- (void)reset {
  [ctrler resetAndStart];
}

- (void)sample {
  [ctrlr sampleAndStop]
}



ctrlr:

- (void)resetAndStart {
  [watcher initSampling];
  [process reactivate];
}

- (void)sampleAndStop {
  if ([process isActive]) {
    [watcher sample];
    if ([watcher hasReachedCpuLimit]) {
      [process deactivate];
    }
  }
}

#endif


#if 0

- (void)tick {
  if (tick == MAX_STEPS) {
    tick = 0;
    [watcher initSampling];
  } else {
    //if ([signaler isActive]) {
      [watcher sample];
      if ([watcher hasReachedCpuLimit]) {
        //[signaler deactivate];
      }
    //}
  }
  tick++;
}
#endif

@end
