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
#import "Times.h"

// libs
#import <SenTestingKit/SenTestingKit.h>

// sys
#import <time.h>


void nssleep (NanoSeconds ns) {
  struct timespec in;
  in.tv_sec = ns / 1000*1000*1000;
  in.tv_nsec = ns - in.tv_sec;
  nanosleep (&in, NULL);
}


const NanoSeconds us = 1000;


@interface TimeInfoTest : SenTestCase {
  
}

@end



@implementation TimeInfoTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testNowReturnsPlausibleNanoSeconds {
  for (int i = 0; i < 10; ++i ) {
    NanoSeconds ns1 = now ();
    nssleep (us);
    NanoSeconds ns2 = now ();
    STAssertEqualsWithAccuracy (ns1, ns2, 3*us, @"");
  }
}

@end
