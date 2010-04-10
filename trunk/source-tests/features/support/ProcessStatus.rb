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

class ProcessStatus
  attr_reader :pid, :ppid, :pgid, :cpu

  def initialize(pid,ppid,pgid,cpu,cmd)
    @pid = pid
    @ppid = ppid
    @pgid = pgid
    @cpu = cpu
    @cmd = cmd
    #puts @pid, @ppid, @pgid, @cpu
  end
  
  def to_s
    "ProcessStatus: pid(#{@pid}) ppid(#{@ppid}) pgid(#{@pgid}) cpu(#{cpu}) cmd(#{@cmd})"
  end
  
  def ProcessStatus.ps
    psinfo = [];
    psout = run;
    psout.each do |line|
      pid, ppid, pgid, cpu, flags, state, cmd = line.chomp.split
      psinfo << ProcessStatus.new(pid.to_i, ppid.to_i, pgid.to_i, cpu.to_i, cmd)
    end
    psinfo
  end
  
private
  def ProcessStatus.run
    psout = `ps -e -o pid,ppid,pgid,pcpu,flags,state,comm=CMD`
    lines = psout.split(/$/)
    dropNoise lines
  end
  
  def ProcessStatus.dropNoise(lines)
    lines.shift # header top line
    lines.pop   # empty last line 
    lines
  end
end
