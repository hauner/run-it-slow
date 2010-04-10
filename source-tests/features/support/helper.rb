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
 
def getSlowDir
  path = ENV['SLOW_DIR']
  path.length.should > 0
  path  
end

def getSlowPath
  slow = getSlowDir + "/slow"
  test(?u,slow).should == true
  slow
end

def createCmdScript
  burnscript = <<BURN
#catch ctrl+c
intrap = false

trap("INT") do
  if intrap == false
    intrap = true
    Process.kill("-INT", Process.getpgrp)
    exit
  end
end

#fork burning sub process?
if ARGV.length == 1
  f = ARGV[0].to_i
  f.times do |i|
    print "forked... ", i, "\n"
    fork do
      while true do
      end
    end
  end
end

# just burn cpu cycles..
print "burning...\n"
while true do
end
BURN

  burn = getSlowDir + "/burn.rb"
  File.open(burn,"w") do |f|
    f << burnscript
  end
  burn
end


def waitForRunningChildsOf(pid)
  waitForChildsOf(pid) {|cnt| cnt > 0}
end

def waitForNoChildsOf(pid)
  waitForChildsOf(pid) {|cnt| cnt == 0}
end

def waitForChildsOf(pid)
  childpids = []
  10.times do |i|
    childpids = snapshotChildsOf(pid)
    break if yield childpids.length
    sleep 0.1
  end
  childpids
end

def snapshotChildsOf(pid)
  ps = ProcessStatus.ps

  childpids = []
  ps.each do |entry|
    if pid == entry.ppid
      childpids << entry.ppid
    end
  end
  childpids
end

def getChildProcessGroupOf(pid)
  ps = ProcessStatus.ps
  ps.each do |entry|
    if pid == entry.ppid
       return entry.pgid
    end
  end
end
