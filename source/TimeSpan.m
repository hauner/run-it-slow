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
#import "TimeSpan.h"


@implementation TimeSpan

@synthesize ns;

- (MicroSeconds)us {
  return ns/1000;
}

- (MilliSeconds)ms {
  return ns / 1000000;
};

- (id)init {
  if (self = [super init]) {
    ns = 0;
  }
  return self;
}

- (id)init:(NanoSeconds)Ns {
  if (self = [super init]) {
    ns = Ns;
  }
  return self;
}

+ (id)zero {
  return [TimeSpan new];
}

+ (id)withNanoSeconds:(NanoSeconds)ns {
  return [[TimeSpan alloc] init:ns];
}

- (TimeSpan*)sub:(TimeSpan*)span {
  return [TimeSpan withNanoSeconds:ns - [span ns]];
}

- (TimeSpan*)add:(TimeSpan*)span {
  return [TimeSpan withNanoSeconds:ns + [span ns]];
}


- (BOOL)isEqual:(id)object {
  if (object == self)
    return YES;
  if (![object isKindOfClass:[self class]])
    return NO;  
  
  return ns == [object ns];
}

@end
