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


@implementation CpuWatcher

- (id)initWithProcess:(Process*)aProcess
               Finder:(CpuSampleFinder*)aFinder
               Signal:(ProcessSignaler*)aSignal {
  if (self = [super init]) {
    process = aProcess;
    finder  = aFinder;
    signal  = aSignal;
    initSample = nil;
    currSample = nil;
  }
  return self;  
}

+ (id)withProcess:(Process*)process 
           Finder:(CpuSampleFinder*)finder
           Signal:(ProcessSignaler*)signal {
  return [[CpuWatcher alloc] initWithProcess:process 
                                      Finder:finder
                                      Signal:signal]; 
}

- (void)getInitSample {
  initSample = [[finder cpuSampleByGPid:[process pid]] cpu];
  //printf ("init (%lld)\n", [initSample ns]);
}

- (void)getCurrSample {
  currSample = [[finder cpuSampleByGPid:[process pid]] cpu];
  //printf ("curr (%lld)\n", [currSample ns]);
}

- (void)reset {
  [self getInitSample];
  [process cont:signal];
}

// rename to watch
- (void)sample {
  if (![process isRunning])
    return;
  
  [self getCurrSample];
  if ([self hasReachedCpuLimit]) {
    [process stop:signal];
  }
}

- (BOOL)hasReachedCpuLimit {
  return [process hasReachedCpuLimit:[currSample sub:initSample]];
}

@end
