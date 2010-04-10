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
#import "ProcessSignaler.h"


@implementation ProcessSignaler

- (void)stopPid:(pid_t)pid {
  //printf("propagating stop signal (%d) to process (%d).\n", SIGSTOP, pid);  
  int r = killpg (pid, SIGSTOP);
  if (r == -1) {
    NSLog(@"failed to stop process (%d)(%s)", pid, strerror(errno));
  }
}

- (void)contPid:(pid_t)pid {
  //printf("propagating cont signal (%d) to process (%d).\n", SIGCONT, pid);  
  int r = killpg (pid, SIGCONT);
  if (r == -1) {
    NSLog(@"failed to continue process (%d)(%s)", pid, strerror(errno));
  }
}

@end
