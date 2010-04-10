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
#import "Launch.h"
#import "Signal.h"
#import "Process.h"
#import "TimeSpan.h"
#import "SamplingScheduler.h"
#import "Timer.h"
#import "KernelProcessLister.h"
#import "KernelProcessProvider.h"
#import "CpuSampleFinder.h"
#import "ProcessSignaler.h"
#import "CpuWatcher.h"

// sys
#import <Foundation/Foundation.h>
#import <objc/objc-auto.h>


/*
 TODO
 
 - give max cpu percent on the command line
    -p 50
 - print warning if not running suid root!
 - accept command without ""
 - test runnig overhead and adjust timer settings
*/


/*

 Design:
 
 KernelProcessLister, low level process information
 => KernelProcess
 
 
 ProcessProvider
 => Process
 
 implemented by KernelProcessProvider
   translates KernelProcess to Processs
 
 
 ProcessExplorer, find process with pid, uses ProcessProvider
 
 
 
 Timer, runs every 100th second, delegates timer event to TimerTick
 
 
 ProcessController, Timer target, implements TimerTick protocol

 

          1  s
       1000 ms
    1000000 us
 1000000000 ns
  500000000
  100000000 0.1 s
*/


const NanoSeconds second = 1000000000;


int main (int argc, const char * argv[]) {
  objc_startCollectorThread();

  
  
  NSString* command = [NSString stringWithFormat:@"%s", argv[1]];
  NSLog(@"command (%@)", command);

  Launch* launch = [[Launch alloc] initWithCommand:command];
  [launch launch];

  Process* process = [Process withPid:[launch pid]
                             cpuLimit:[TimeSpan withNanoSeconds:
                                       500000000 
//                                         100000000 
                                       -  10000000]];
  
  [Signal createSigintHandler:[process pid]];
  
  KernelProcessLister* lister = [KernelProcessLister new];
  
  KernelProcessProvider* provider = [[KernelProcessProvider alloc] init:lister];
  
  CpuSampleFinder* finder = [[CpuSampleFinder alloc] initWithProvider:provider];
  ProcessSignaler* signal = [ProcessSignaler new];
  
  CpuWatcher* watcher = [CpuWatcher withProcess:process 
                                         Finder:finder
                                         Signal:signal];
  
  SamplingScheduler* scheduler = [SamplingScheduler
                                  withCpuWatcher:watcher Resolution:10];
  
  Timer* timer = [Timer withTimerTick:scheduler];
  [timer run];
  

  //printf("waiting for child to exit...");
  [launch wait];
  //printf("exited.\n");
  [timer stop];
  
  return 0;
}
