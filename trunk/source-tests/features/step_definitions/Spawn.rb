#  ==========================================================================
#  Copyright (c) 2010  Martin Hauner
#                     http://code.google.com/p/run-it-slow
#
#  This file is part of "run it slow".
#  
#  "run it slow" is free software: you  can redistribute  it and/or modify it
#  under the terms of the GNU General Public License as published by the Free
#  Software Foundation, either version 3 of the License,  or (at your option)
#  any later version.
#
#  "run it slow" is  distributed  in  the  hope  that  it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#  or FITNESS  FOR A  PARTICULAR PURPOSE. See the  GNU General Public License
#  for more details.
#
#  You should have  received a copy of the  GNU General Public License  along
#  with "run it slow". If not, see <http://www.gnu.org/licenses/>.
#  ==========================================================================


Given /^a command argument$/ do
  @command = "ruby #{@burn}"
end

Given /^a command argument that spawns other processes$/ do
  @command = "ruby #{@burn} 2"
end


When /^the user runs slow$/ do
  @pid = fork do
    exec(@slow, @command)
  end
  @childpids = waitForRunningChildsOf @pid
  @childpgid = getChildProcessGroupOf @pid
end


Then /^the command should be spawned as a child process$/ do
  @childpids.length.should == 1
end
