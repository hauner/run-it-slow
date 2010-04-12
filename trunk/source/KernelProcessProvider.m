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
#import "KernelProcessProvider.h"
#import "KernelProcessLister.h"
#import "KernelProcess.h"
#import "CpuSample.h"
#import "TimeSpan.h"


@implementation KernelProcessProvider

-(id)init:(KernelProcessLister *)Lister {
  if (self = [super init]) {
    lister = Lister;
  }
  return self;  
}

-(NSArray*)samples {
  NSMutableArray* samples = [NSMutableArray arrayWithCapacity:100];
  [lister createProcInfo];

  for (KernelProcess* kproc in [lister get]) {
    [samples addObject:
     [CpuSample withPid: [kproc gpid]//[kproc pid]
                    Cpu: [[kproc userTime] add:[kproc sysTime]]]];
  }
  
  [lister releaseProcInfo];
  return samples;
}

/*
 NSLog(@"element: pid(%d) ppid(%d) u(%llu)ns s(%llu)ns", 
 [kproc pid],
 [kproc ppid],
 [[kproc userTime] ns],
 [[kproc sysTime] ns]);
*/

@end
