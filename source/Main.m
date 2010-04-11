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
#import "Main.h"
#import "TimeSpan.h"
#import "Launch.h"
#import "Signal.h"
#import "Process.h"
#import "ProcessSignaler.h"
#import "KernelProcessLister.h"
#import "KernelProcessProvider.h"
#import "CpuSampleFinder.h"
#import "CpuWatcher.h"
#import "SamplingScheduler.h"
#import "Timer.h"


static const double DefaultPercentage = 50.0;
static const double SamplesPerSecond  = 100.0;

/**

 Design Overview:
 ================
 
 Algorithm:
 ==========
 
 slow sample the cpu usage for the command SamplesPerSecond times in a second.
 If the cpu usage gets above the limit it sigstops the process. When the next
 second begins it sigconts the process.
 
 
 Objects:
 ========

 Timer
   uses SamplingScheduler
   triggers scheduler
 
 SamplingScheduler
   uses CpuWatcher
   controls sample timing
 
 CpuWatcher, watch Process Cpu
   uses CpuSampleFinder, ProcessSignaler
   stop, restarts process based on samples

 CpuSampleFinder, get CpuSamples by pid/gpid
   uses CpuSampleProvider
   result => CpuSample
 
 KernelProcessProvider, implements CpuSampleProvider
   uses KernelProcessLister
   result => CpuSample
 
 KernelProcessLister, low level process information
   result => KernelProcess
 
 KernelProcess, single process information

**/


@implementation Main

- (id)initWithPercent:(double)aPercent Command:(NSString*)aCommand {
  if (self = [super init]) {
    percent = aPercent;
    command = aCommand;
  }
  return self;  
}

+ (id)withPercent:(double)percent Command:(NSString*)command {
  return [[Main alloc] initWithPercent:percent Command:command];
}

- (double)percentage {
  if (percent == -1.0) {
    return DefaultPercentage;
  }
  return percent;
}

- (TimeSpan*)calcLimit {
  return [TimeSpan withNanoSeconds:(double)Second * [self percentage] / 100.0];
}

- (Launch*)createLauncher {
  return [Launch withCommand:command];
}

- (void)installSigintHandler:(Launch*)launch {
  [Signal createSigintHandler:[launch pid]];
}

- (Process*)createProcess:(Launch*)launch {
  return [Process withPid:[launch pid] cpuLimit:[self calcLimit]];
}

- (KernelProcessProvider*)createProvider {
  return [[KernelProcessProvider alloc] init:[KernelProcessLister new]];
}

- (CpuSampleFinder*)createFinder {
  return [[CpuSampleFinder alloc] initWithProvider:[self createProvider]];
}

- (ProcessSignaler*)createSignaler {
  return [ProcessSignaler new];
}

- (CpuWatcher*)createWatcher:(Process*)process {
  return [CpuWatcher withProcess:process 
                          Finder:[self createFinder]
                          Signal:[self createSignaler]];
}

- (SamplingScheduler*)createScheduler:(CpuWatcher*)watcher {
  return [SamplingScheduler withCpuWatcher:watcher Resolution:SamplesPerSecond];
}

- (Timer*)createTimer:(Process*)process {
  return [Timer withTimerTick:
          [self createScheduler:
           [self createWatcher:process]] Interval:(1.0/SamplesPerSecond)];
}

- (void)run {
  Launch* launch = [self createLauncher];
  [launch launch];
  
  [self installSigintHandler: launch];

  Timer* timer = [self createTimer:[self createProcess:launch]];
  [timer run];
  
  //printf("waiting for child to exit...");
  [launch wait];

  //printf("exited.\n");
  [timer stop];
}

@end
