require 'rubygems'
require 'rake'

version = '1.0'

begin
  require 'echoe'

  Echoe.new('rtimeout', version) do |p|
    p.rubyforge_name = 'rtimeout'
    p.summary      = "For timing out system commands."
    p.url          = "http://github.com/defunkt/rtimeout"
    p.author       = 'Chris Wanstrath'
    p.email        = "chris@ozmm.org"
  end

rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."
end
