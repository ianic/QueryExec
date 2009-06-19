app_root = File.expand_path(File.join(File.dirname(__FILE__))) 
$: << "#{app_root}"
$: << "#{app_root}/lib"                                        

require 'query_executer.rb'

query = File.read("/tmp/request.sql")
qe = QueryExecuter.new
result = qe.exec(query)

File.open("/tmp/response.drb", "w+") do |f|
  Marshal.dump(result, f)
end