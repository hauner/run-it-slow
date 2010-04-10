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
#import "ArgumentParser.h"

// libs
#import <SenTestingKit/SenTestingKit.h>


@interface ArgumentParserTest : SenTestCase {
  
}

@end


@implementation ArgumentParserTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testParseFailsWithoutArguments {
  int   argc = 1;
  char* argv[] = {
    "slow"
  };
  
  id args = [ArgumentParser withArgCount:argc Args:argv];

  BOOL result = [args parse];
  STAssertEquals (result, NO, @"should be NO but was YES!");
}

- (void)testParseFailsWithVersionArguments {
  int   argc = 2;
  char* argv[] = {
    "slow", "-v"
  };
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  
  BOOL result = [args parse];
  STAssertEquals (result, NO, @"should be NO but was YES!");
}

- (void)testPercentWithNoArguments {
  int   argc = 1;
  char* argv[] = {
    "slow"
  };
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  [args parse];
  
  int percent = [args percent];
  STAssertEquals (percent, -1, @"");
}

- (void)testPercentWithOptionButNoValue {
  int   argc = 2;
  char* argv[] = {
    "slow", "-p"
  };
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  [args parse];

  int percent = [args percent];
  STAssertEquals (percent, -1, @"");
}

- (void)testPercentWithOptionAndValue {
  int   argc = 3;
  char* argv[] = {
    "slow", "-p", "10"
  };
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  [args parse];

  int percent = [args percent];
  STAssertEquals (percent, 10, @"");
}



@end
