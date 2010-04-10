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
#import "Version.h"


@implementation ArgumentParser


- (id)initWithArgCount:(int)Argc Args:(char*[])Argv{
  if (self = [super init]) {
    argc = Argc;
    argv = Argv;
    
    percent = -1;
  }
  return self;
}

+ (ArgumentParser*)withArgCount:(int)argc Args:(char*[])argv {
  return [[ArgumentParser alloc] initWithArgCount:argc Args:argv];
}

- (int)parseNumber:(char*)arg {
  char* endptr = NULL;
  long value = strtol (arg, &endptr, 10);
  if (endptr == NULL) {
    return -1;
  }
  return value;
}

- (void)missingArg:(const char*)arg {
  fprintf (stderr, "slow: argument missing for option %s!\n", arg);
}

- (void)usage {
  printf ("usage: slow [-p cpu limit (0..100)] command\n");
}

- (void)version {
  printf (VersionString);
  printf ("\n");
}

- (BOOL)parse {
  if (argc < 2) {
    [self usage];
    return NO;
  }
  
  int idx = 1;
  while (idx < argc) {
    if (strcmp (argv[idx], "-v") == 0) {
      [self version];
      return NO;
    }
    if (strcmp (argv[idx], "-p") == 0) {
      if (idx+1 < argc) {
        percent = [self parseNumber:argv[idx+1]];
      }
      else {
        [self missingArg:argv[idx]];
        return NO;
      }
    }
    idx++;
  }
  return YES;
}

- (int)percent {
  return percent;
}

@end
