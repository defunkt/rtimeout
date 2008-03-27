require 'rubygems'
require 'test/unit'
require 'mocha'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'rtimeout'

def context(*args, &block)
  return super unless (name = args.first) && block
  require 'test/unit'
  klass = Class.new(Test::Unit::TestCase) do
    def self.specify(name, &block) 
      define_method("test_#{name.gsub(/\W/,'_')}", &block) 
    end
    def self.xspecify(*args) end
    def self.setup(&block) define_method(:setup, &block) end
    def self.teardown(&block) define_method(:teardown, &block) end
  end
  klass.class_eval &block
end

module FakeIO
  def fake_stdout
    old_io = $stdout.dup
    tempio = StringIO.new

    $stdout = tempio
    yield
    tempio.string
  ensure
    $stdout = old_io
  end

  def fake_stderr
    old_io = $stderr.dup
    tempio = StringIO.new

    $stderr = tempio
    yield
    tempio.string
  ensure
    $stderr = old_io
  end
end

context "rtimeout" do
  include FakeIO

  setup do
    @test_script = 'ruby ' + File.dirname(__FILE__) + '/slow_script.rb'
  end

  specify "prints to stdout on success" do
    out = fake_stdout do
      Rtimeout.read(3, @test_script)
    end

    assert_equal "It worked!\n", out
  end

  specify "prints to stderr on timeout" do
    out = fake_stderr do
      Rtimeout.read(1, @test_script)
    end

    assert_equal "rtimeout: Command `#{@test_script}` timed out.\n", out
  end
end
