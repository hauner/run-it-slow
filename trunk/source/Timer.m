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
#import "Timer.h"


@implementation Timer

- (id)initWithTimerTick:(id <TimerTick>)aTick Interval:(double)anInterval {
  if (self = [super init]) {
    timer    = nil;
    tick     = aTick;
    interval = anInterval;
  }
  return self;
}

+ (Timer*)withTimerTick:(id <TimerTick>)tick Interval:(double)interval {
  return [[Timer alloc] initWithTimerTick:tick Interval:interval];
}
  
- (void)run {
  timer = [NSTimer 
           scheduledTimerWithTimeInterval:interval
           target:self
           selector:@selector(tick)
           userInfo:nil
           repeats:YES];
}

- (void)stop {
  [timer invalidate];
}

- (void)tick {
  [tick tick];
}

@end