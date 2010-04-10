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
#import "CpuController.h"
#import "CpuWatcher.h"
#import "Process.h"

// libs
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>


@interface CpuControllerActiveTest : SenTestCase {
  id signaler;  
  id watcher;
}

@end


@implementation CpuControllerActiveTest

/*
- (void)setUp {
  signaler = [OCMockObject mockForClass:[ProcessSignaler class]];
  watcher = [OCMockObject mockForClass:[CpuWatcher class]];
  [[watcher stub] initSampling];
  [[watcher stub] sample];
}

- (void)tearDown {
}

- (void)testDeactivateIfProcessHasReachedTheCpuLimit {
  BOOL retval = YES;
  [[[watcher stub] andReturnValue:OCMOCK_VALUE(retval)] hasReachedCpuLimit];
  [[signaler expect] deactivate];
  
  id controller = [CpuController withWatcher:watcher signaler:signaler];
  [controller tick];
  [controller tick];
  
  [signaler verify];
}

- (void)testDoNotDeactivateIfProcessHasNotReachedTheCpuLimit {
  BOOL retval = NO;
  [[[watcher stub] andReturnValue:OCMOCK_VALUE(retval)] hasReachedCpuLimit];
  // do NOT expect
  //[[signaler expect] deactivate];
  
  id controller = [CpuController withWatcher:watcher signaler:signaler];
  [controller tick];
  [controller tick];
  
  [signaler verify];
}
 */

@end
