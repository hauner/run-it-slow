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
@class TimeSpan;
@class ProcessSignaler;


@interface Process : NSObject {
  pid_t pid;
  TimeSpan* limit;
  BOOL running;
}

// todo change limit to percent
+ (id)withPid:(pid_t)pid cpuLimit:(TimeSpan*)limit;

- (pid_t)pid;
- (BOOL)hasReachedCpuLimit:(TimeSpan*)usedCpu;

- (void)stop:(ProcessSignaler*)signaler;
- (void)cont:(ProcessSignaler*)signaler;

- (BOOL)isRunning;

@end


