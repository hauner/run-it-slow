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
#import "KernelProcess.h"
#import "TimeSpan.h"


@implementation KernelProcess

@synthesize pid;
@synthesize ppid;
@synthesize gpid;
@synthesize userTime;
@synthesize sysTime;


-(id)initWithPid:(pid_t)Pid
            PPid:(pid_t)PPid
            GPid:(pid_t)GPid
            User:(TimeSpan*)user 
          System:(TimeSpan*)sys {
  if (self = [super init]) {
    pid  = Pid;
    ppid = PPid;
    gpid = GPid;
    userTime = user;
    sysTime  = sys;
  }
  return self;  
}

+(id)createWithPid:(pid_t)pid
              PPid:(pid_t)ppid
              GPid:(pid_t)gpid
            UserNs:(uint64_t)uNs
          SystemNs:(uint64_t)sNs {
  return [[KernelProcess alloc] initWithPid:pid
                                       PPid:ppid
                                       GPid:gpid
                                       User:[TimeSpan withNanoSeconds:uNs]
                                     System:[TimeSpan withNanoSeconds:sNs]];
}


@end
