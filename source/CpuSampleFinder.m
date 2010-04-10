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


@implementation CpuSampleFinder

- (id)initWithProvider:(id <CpuSampleProvider>)aProvider {
  if (self = [super init]) {
    provider = aProvider;
  }
  return self;  
}

- (CpuSample*)cpuSampleByPid:(pid_t)pid {
  for (id proc in [provider samples]) {
    if ([proc pid] == pid) {
      return proc;
    }
  }
  return nil;
}

- (CpuSample*)cpuSampleByGPid:(pid_t)gpid {
  TimeSpan* span = [TimeSpan zero];
  
   for (id proc in [provider samples]) {
     if ([proc pid] == gpid) {
       span = [span add:[proc cpu]];
     }
   }
  return [CpuSample withPid:gpid Cpu:span];
}


@end
