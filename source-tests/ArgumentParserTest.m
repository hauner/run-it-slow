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
  const char* argv[] = {
    "slow"
  };
  int argc = 1;
  
  id args = [ArgumentParser withArgCount:argc Args:argv];

  BOOL result = [args parse];
  STAssertEquals (result, NO, @"should be NO but was YES!");
}

- (void)testParseFailsWithVersionArguments {
  const char* argv[] = {
    "slow", "-v"
  };
  int argc = 2;
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  
  BOOL result = [args parse];
  STAssertEquals (result, NO, @"should be NO but was YES!");
}

- (void)testPercentWithNoArguments {
  const char* argv[] = {
    "slow"
  };
  int argc = 1;
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  [args parse];
  
  int percent = [args percent];
  STAssertEquals (percent, -1, @"");
}

- (void)testPercentWithOptionButNoValue {
  const char* argv[] = {
    "slow", "-l"
  };
  int argc = 2;
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  [args parse];

  int percent = [args percent];
  STAssertEquals (percent, -1, @"");
}

- (void)testPercentWithOptionAndValue {
  const char* argv[] = {
    "slow", "-l", "10"
  };
  int argc = 3;
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  [args parse];

  int percent = [args percent];
  STAssertEquals (percent, 10, @"");
}

- (void)testCommandWithOption {
  const char* argv[] = {
    "slow", "make with parameter"
  };
  int argc = 2;
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  BOOL result = [args parse];
  STAssertEquals (result, YES, @"should be YES but was NO!");
  
  NSString* cmd = [args command];
  NSString* exp = [NSString stringWithFormat:@"%s", "make with parameter"];
  STAssertEqualObjects (cmd, exp, @"");
}

- (void)testParsePercentAndCommandOption {
  const char* argv[] = {
    "slow", "-l", "10", "make"
  };
  int argc = 4;
  
  id args = [ArgumentParser withArgCount:argc Args:argv];
  BOOL result = [args parse];
  STAssertEquals (result, YES, @"should be YES but was NO!");

  int percent = [args percent];
  STAssertEquals (percent, 10, @"");  
  
  NSString* cmd = [args command];
  NSString* exp = [NSString stringWithFormat:@"%s", "make"];
  STAssertEqualObjects (cmd, exp, @"");
}


@end
