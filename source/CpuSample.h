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


@interface CpuSample : NSObject {
  pid_t pid;
//  pid_t gpid;
  TimeSpan* cpu;
}

@property(readonly) pid_t pid;
//@property(readonly) pid_t gpid;
@property(readonly) TimeSpan* cpu;

+ (id)withPid:(pid_t)pid /*GPid:(pid_t)gpid*/ Cpu:(TimeSpan*)cpu;

- (BOOL)isEqual:(id)object;

@end
