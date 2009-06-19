require 'rubygems'     
gem 'odbc_helper', '=0.0.4'   
require 'odbc_helper'

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
   ODBC.error.map {|error| error.to_s }.join('\n')                   
 end       
 
 def get_result(stm)   
   {:columns => columns(stm), :data => read_array(stm)}
 end                                           
 
 def columns(stm)  
   stm.columns(true).map do |column|
     { :name => column.name,
       :type => column.type,
       :length  => column.length
       }
   end
 end
   
end