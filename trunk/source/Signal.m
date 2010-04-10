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
#import "Signal.h"

// sys
#include <stdio.h>


static pid_t childPid = 0;

static void handler (int signal)
{
  //printf("in signal handler!\n");
  if (childPid == 0) {
    return;
  }
  
  //printf("propagating signal (%d) to child process (%d).\n", signal, childPid);
  int r = kill (childPid, SIGINT);
  if (r == -1) {
    NSLog(@"failed to kill child process (%d)(%s)", childPid, strerror(errno));
  }
}

@implementation Signal

+ (void)createSigintHandler:(pid_t)pid {
  childPid = pid;
  struct sigaction action;
  action.sa_flags = SA_SIGINFO | SA_RESETHAND;
  action.sa_mask = 0;
  action.sa_handler = handler;
  int r = sigaction(SIGINT, &action, NULL);
  if(r!=0) {
    NSLog(@"failed to install signal handler (%s)!", strerror(errno));
  }
}

@end

