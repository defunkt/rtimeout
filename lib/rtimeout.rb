require 'rubygems'
require 'open4'

class Rtimeout
  def initialize(timeout, command)
    @timeout = timeout.to_i
    @command = command
    @pid, _, @io, _ = Open4.popen4(command)
  end

  def read
    while result = IO.select([@io], nil, nil, @timeout)
      out = @io.read(1)
      break if out.nil?
      $stdout.print out
    end

    if result.nil?
      system "kill -9 #{@pid}"
      $stderr.puts "rtimeout: Command `#{@command}` timed out." 
    end
  end

  def self.read(timeout, command)
    new(timeout, command).read
  end
end
