class Rtimeout
  def initialize(timeout, command)
    @timeout = timeout.to_i
    @command = command
    @io = IO.popen(command, "r+")
  end

  def read
    while result = IO.select([@io], nil, nil, @timeout)
      out = @io.read(1)
      break if out.nil?
      $stdout.print out
    end

    $stderr.puts "rtimeout: Command `#{@command}` timed out." if result.nil?
  end

  def self.read(timeout, command)
    new(timeout, command).read
  end
end
