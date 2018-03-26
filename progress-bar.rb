#!/usr/bin/ruby
require 'eventmachine'

#--- configuration-----------------------------------------
class Config
  class << self    
    def appName
      return 'Progress Bar'
    end
  end
end

class Util
  class << self    
    def write(data)
      print data
      $stdout.flush
    end    
  end
end

#-------------------------------------------------------'
class App
  def initialize    
    @appName = Config::appName 
    @abort   = false   
    @thr = Thread.new {      
      startTime = Time.now.to_i
      sleep 1            
      until @abort     
        str  = "[Running in:  #{Time.now.to_i - startTime} seconds]"        
        Util.write "\r#{str}"
        sleep 1
      end
    }
  end

  def quit
    @abort = true 
    puts ""
    EM.stop
  end  

  def run
    puts "Execute run .."
    @abort = false      
    @thr.run    

    EM.run do
                  
      #TODO: //main code here
      Signal.trap("INT")  { quit }
      Signal.trap("TERM") { quit }  
     
      
    end
    
    
  end

  def self.execute
    inst = App.new
    inst.run()
  end

end

# describe "Main" do
  # context "Exec" do
    App.execute()
  # end
# end



