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


@implementation Process

- (id)initWithPid:(pid_t)aPid cpuLimit:(TimeSpan*)aLimit {
  if (self = [super init]) {
    pid = aPid;
    limit = aLimit;
    running = YES;
  }
  return self;
}

+ (id)withPid:(pid_t)pid cpuLimit:(TimeSpan*)limit {
  return [[Process alloc] initWithPid:pid cpuLimit:limit];
}

- (pid_t)pid {
  return pid;
}

- (BOOL)hasReachedCpuLimit:(TimeSpan*)usedCpu {
  //printf( "used (%lld) limit (%lld)\n", [usedCpu ns], [limit ns]);
  return [usedCpu ns] > [limit ns];
}

- (void)stop:(ProcessSignaler*)signaler {
  if (running == YES) {
    [signaler stopPid:pid];
    running = NO;
  }
}

- (void)cont:(ProcessSignaler*)signaler {
  if (running == NO) {
    [signaler contPid:pid];
    running = YES;
  }
}

- (BOOL)isRunning {
  return running;
}

@end
