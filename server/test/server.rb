require 'drb'

class Incrementer
  
  def initialize 
    @value = 0
  end
   
  def incremnet   
    @value += 1
    p "server called, new value: #{@value}"             
    @value
  end       
 
end

service = DRb.start_service("druby://localhost:4242", Incrementer.new) 
print "service started on port 4242\n"
DRb.thread.join