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
#import "KernelProcessLister.h"
#import "KernelProcess.h"
#import "Clock.h"
#import "Times.h"

// sys
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_time.h>


struct tinfo_proc {
  uint64_t nanoUser;
  uint64_t nanoSystem;
};


@interface MachTime : NSObject {
}

- (struct tinfo_proc)times:(pid_t)pid;

@end


@implementation MachTime


- (BOOL)getAbsTimes:(id_t)pid into:(struct task_absolutetime_info *)tti {
  kern_return_t kr;
  
  mach_port_name_t pname;
  kr = task_for_pid (mach_task_self (), pid, &pname);
  if (kr != KERN_SUCCESS) {
    return NO;
  }
  
  mach_msg_type_number_t count = TASK_ABSOLUTETIME_INFO_COUNT;
  kr = task_info (pname, TASK_ABSOLUTETIME_INFO, (task_info_t)tti, &count);
  if (kr != KERN_SUCCESS) {
    return NO;
  }
  
  return YES;
}

- (struct tinfo_proc)times:(pid_t)pid {
  struct task_absolutetime_info tti;
  struct tinfo_proc tinfo;
  
  // this fails regularly, so we have to handle it gracefully..
  if ([self getAbsTimes:pid into:&tti]) {
    tinfo.nanoUser   = toNanoSeconds (tti.total_user);
    tinfo.nanoSystem = toNanoSeconds (tti.total_system);
  }
  else {
    tinfo.nanoUser   = 0;
    tinfo.nanoSystem = 0;
  }
  return tinfo;
}

@end





@interface KernelProcessLister ()

- (id)init;
- (void)createProcArray;
- (void)sizeProcArray;
- (void)allocProcArray;
- (void)initProcArray;
- (size_t)fillProcArray;
- (void)setProcCount:(size_t)size;
- (void)createTimeArray;
- (void)initTimeArray;
- (KernelProcess*)process:(int)idx;

@end


static int mib[]   = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };
static int mibSize = 4;


@implementation KernelProcessLister

- (void)reset {
  _count = 0;
  _ksize = 0;
  _kinfo = NULL;
  _tinfo = NULL;
}

-(id)init {
  if (self = [super init]) {
    [self reset];
  }
  return self;  
}

- (void)allocate {
  _stamp = [Clock now];
  [self createProcArray];
  [self initProcArray];
  [self createTimeArray];
  [self initTimeArray];
}

- (void)release {
  free(_kinfo);
  free(_tinfo);
  [self reset];
}

- (NSArray*)get {
  NSMutableArray* array = [NSMutableArray arrayWithCapacity:_count];
  for (int i = 0; i < _count; ++i) {
    [array addObject:[self process:i]];
  }
  return array;
}

- (TimeSpan*)timeStamp {
  return _stamp;
}

- (void)createProcArray {
  [self sizeProcArray];
  [self allocProcArray];
}

-(void)sizeProcArray {
  int err = sysctl (mib, mibSize, NULL, &_ksize, NULL, 0);
  if (err == -1) {
    NSLog(@"failed to get size of kinfo_proc[] (%s)!\n", strerror(errno));
  }
}

- (void)allocProcArray {
  _kinfo = malloc(_ksize);
  if (_kinfo == NULL) {
    NSLog(@"failed to allocate kinfo_proc[] (%s)!\n", strerror(errno));
  }
}

- (void)initProcArray {
  [self setProcCount: [self fillProcArray]];
}

- (size_t)fillProcArray {
  size_t size = _ksize;
  int err = sysctl (mib, mibSize, _kinfo, &size, NULL, 0);
  if (err == -1) {
    NSLog(@"failed to populate kinfo_proc[] (%s)!\n", strerror(errno));
  }
  return size;
}

- (void)setProcCount:(size_t)size {
  _count = size / sizeof(struct kinfo_proc);
}

- (void)createTimeArray {
  _tinfo = calloc (_count, sizeof(struct tinfo_proc));
}

- (void)initTimeArray {
  MachTime* mtime = [MachTime new];
  for (int i = 0; i < _count; ++i) {
    pid_t pid = _kinfo[i].kp_proc.p_pid;
    //NSLog(@"pid at times: %d", (int)pid);
    _tinfo[i] = [mtime times:pid];
  }
}

- (KernelProcess*)process:(int)idx {
  return [KernelProcess createWithPid:_kinfo[idx].kp_proc.p_pid
                                 PPid:_kinfo[idx].kp_eproc.e_ppid
                                 GPid:_kinfo[idx].kp_eproc.e_pgid
                               UserNs:_tinfo[idx].nanoUser
                             SystemNs:_tinfo[idx].nanoSystem];
}

@end









#if 0
// fails regularly
- (void)getPortName:(pid_t)pid into:(mach_port_name_t*)pname {
  kern_return_t kr = task_for_pid (mach_task_self (), pid, pname);
  
  if (kr != KERN_SUCCESS) {
    NSLog(@"failed to get task for pid %d (%s)!\n", (int)pid,
          mach_error_string(kr));
    return false;
  }
}
#endif

#if 0
- (void)getAbsTimes:(mach_port_name_t)pname
into:(struct task_absolutetime_info*)tti {
  kern_return_t kr;
  mach_msg_type_number_t count = TASK_ABSOLUTETIME_INFO_COUNT;
  kr = task_info (pname, TASK_ABSOLUTETIME_INFO, (task_info_t)tti, &count);
  
  if (kr != KERN_SUCCESS) {
    NSLog(@"failed to get time info for task (%s)!\n",mach_error_string(kr));
  }
}
#endif

#if 0
- (BOOL)getPortName:(pid_t)pid into:(mach_port_name_t*)pname {
  return
  task_for_pid (mach_task_self (), pid, pname)
  == KERN_SUCCESS;
}

- (BOOL)getAbsTimes:(mach_port_name_t)pname
into:(struct task_absolutetime_info*)tti {
  mach_msg_type_number_t count = TASK_ABSOLUTETIME_INFO_COUNT;
  
  return
  task_info (pname, TASK_ABSOLUTETIME_INFO, (task_info_t)tti, &count)
  == KERN_SUCCESS;
}
#endif





/*
 mach_timebase_info_data_t timebase;
 mach_timebase_info(&timebase);
 
 kern_return_t kr;
 for (int i = 0; i < _count; ++i) {
 mach_port_name_t pname;
 kr = task_for_pid (mach_task_self (), _kinfo[i].kp_proc.p_pid, &pname);
 if (kr != KERN_SUCCESS) {
 NSLog(@"failed to get task for pid (%s)!\n",mach_error_string(kr));
 }
 
 mach_msg_type_number_t count = TASK_ABSOLUTETIME_INFO_COUNT;
 struct task_absolutetime_info tti;
 kr = task_info (pname, TASK_ABSOLUTETIME_INFO, (task_info_t)&tti, &count);
 if (kr != KERN_SUCCESS) {
 NSLog(@"failed to get time info for task (%s)!\n",mach_error_string(kr));
 }
 
 _tinfo[i].nanoUser   = tti.total_user   * timebase.numer / timebase.denom;
 _tinfo[i].nanoSystem = tti.total_system * timebase.numer / timebase.denom;
 
 mach_port_deallocate (mach_task_self (), pname);
 }
 */





