require 'drb'    
require 'lib/query_executer.rb'

service = DRb.start_service("druby://localhost:4242", QueryExecuter.new) 
print "service started on port 4242\n"
DRb.thread.join