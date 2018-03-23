#!/usr/bin/ruby
require 'json/ext'
require 'json'
require 'eventmachine'


#--- configuration-----------------------------------------
class Config
  class << self    
    def appName
      return 'amqp'
    end    
  end
end

class Util
  class << self    
    def write(data)
      print data
      $stdout.flush
    end    
    def waitNextCmd
      Util::write "\rtools-cli$>"  
    end  
  end
end

class KeyboardHandler < EM::Connection
  include EM::Protocols::LineText2

  #attr_reader :queue

  def initialize()

  end

  def receive_line(data)
    case data
    when 'exit', 'quit', '^['
      puts "\r\n"
      EM.stop { exit } 
    when 'help', '?'
    when ''        

    else
      if ([27, 29].include?data[0].ord) 
      then 
        EM.stop { exit }
      else 
        puts "Usage : help | exit | quit  #{data.length}"      
      end
    end         
    Util::waitNextCmd    
  end
end

EM.run do
  Signal.trap("INT")  { EM.stop }
  Signal.trap("TERM") { EM.stop }  
  puts "Escape character is '^]'."
  Util::waitNextCmd
  EM.open_keyboard(KeyboardHandler)
end  
