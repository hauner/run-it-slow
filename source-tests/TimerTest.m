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

// libs
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


@interface TimerTest : SenTestCase {
  
}

@end


@implementation TimerTest

- (void)setUp {
}

- (void)tearDown {
}


- (void)testTimerCallsTickCounter {
  id tick = [OCMockObject mockForProtocol:@protocol(TimerTick)];
  [[tick expect] tick];
  
  id timer = [Timer withTimerTick:tick Interval:0.1];
  [timer tick];

  [tick verify];
}

@end
