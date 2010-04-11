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
#import "ArgumentParser.h"

// sys
#import <objc/objc-auto.h>



/**
TODO
 
 - print warning if not running suid root!
 - accept command without ""
 - test runnig overhead and adjust timer settings??
**/


int main (int argc, const char * argv[]) {
  objc_startCollectorThread();

  id args = [ArgumentParser withArgCount:argc Args:argv];
  if (! [args parse]) {
    exit (1);
  };
  
  Main* main = [Main withPercent:[args percent] Command:[args command]];
  [main run];
 
  return 0;
}
