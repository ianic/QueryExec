require 'rubygems'     
gem 'odbc_helper', '=0.0.4'   
require 'odbc_helper'
require 'drb'


class QueryExecuter
  
  include OdbcHelper
  
  def initialize
   super  
   @connection_params = {:dsn => 'staging', :dsn_mirror => nil, :username => 'ianic', :password => 'string'}
 end                                                                                                      
 
 def exec(query)     
   print "executing query: #{query}\n" 
   with_query(query) do |stm| 
     results = []
     results << get_result(stm)
     while stm.more_results do
       results << get_result(stm)
     end                         
     results
   end                               
 rescue => e
  print "error #{e}\n"                                 
 end       
 
 def get_result(stm)
   {:columns => stm.columns.map{|key, value| value.name }, :data => read_array(stm)}
 end
   
end

service = DRb.start_service("druby://localhost:4242", QueryExecuter.new) 
print "service started on port 4242\n"
DRb.thread.join