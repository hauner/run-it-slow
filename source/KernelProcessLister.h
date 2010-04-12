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

// sys
#import <sys/types.h>
struct kinfo_proc;
struct tinfo_proc;


@interface KernelProcessLister : NSObject {
  size_t _count;

  size_t _ksize;
  struct kinfo_proc* _kinfo;
  struct tinfo_proc* _tinfo;

  TimeSpan* _stamp;
}

- (void)createProcInfo;
- (void)releaseProcInfo;

- (NSArray*)get;
- (TimeSpan*)timeStamp;

@end
