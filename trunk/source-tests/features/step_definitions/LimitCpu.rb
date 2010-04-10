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


Then /^it should limit the command group cpu usage to 50%$/ do

end


Then /^it should limit the commands cpu usage to 50%$/ do

  samples  = 20      # number of samples
  interval = 0.5     # sample interval (seconds)
  percent  = 70      # percent of valid entries to pass
    
  cpusamples = [] 
  samples.times do |i|
    cpusamples << 0.0
    
    ps = ProcessStatus.ps
    ps.each do |entry|
      if @childpgid == entry.pgid
      #if @pid == entry.ppid
        # @pid = slow 
        cpusamples[i] += entry.cpu
        #puts @pid, entry, cpusamples[i]
      end
    end
    
    sleep interval
  end

  print "      original samples: "
  cpusamples.each {|v| print v, " "}
  print "\n"

  cpuaverage = [];
  cpusamples.each_index do |idx|
    if idx.modulo(2) == 1
      cpuaverage << (cpusamples[idx-1] + cpusamples[idx]) / 2
    end
  end
  
  print "      average  samples: "
  cpuaverage.each {|v| print v, " "}
  print "\n"
  
  cnt = 0
  cpuaverage.each do |val|
    if val <= 55.0 and val >= 45.0
      cnt += 1
    end
  end
 
  cnt.should >= samples * (percent / 100);
  

#def snapshotChildsOf(pid)
#  ps = ProcessStatus.ps

#  childpids = []
#  ps.each do |entry|
#    if pid == entry.ppid
#      childpids << entry.ppid
#    end
#  end
#  childpids
#end

#  def waitForChildsOf(pid)
#  childpids = []
#  10.times do |i|
#    childpids = snapshotChildsOf(pid)
#    break if yield childpids.length
#    sleep 0.1
#  end
#  childpids
#end

  #true.should == false
end
