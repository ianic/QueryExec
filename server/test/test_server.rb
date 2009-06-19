require 'test/unit'      
require 'lib/query_executer.rb'

class TestPonuda < Test::Unit::TestCase 
  
  def setup         
    @executer = QueryExecuter.new
    @results = @executer.exec("sp_help Slips")
  end                            
  
  def test_is_working    
    assert_equal 8, @results.size            
  end                           
  
  def test_column_names
    columns = @results[0][:columns]
    assert_equal "Name", columns[0][:name]
    assert_equal "Owner", columns[1][:name]
    assert_equal "Type", columns[2][:name]
    assert_equal "Created_datetime", columns[3][:name]
  end   

  def test_column_types
    columns = @results[0][:columns]
    assert_equal 12, columns[0][:type]
    assert_equal 12, columns[1][:type]
    assert_equal 12, columns[2][:type]
    assert_equal 11, columns[3][:type]
  end   

  def test_column_length
    columns = @results[0][:columns]
    assert_equal 512, columns[0][:length]
    assert_equal 512, columns[1][:length]
    assert_equal 124, columns[2][:length]
    assert_equal 23, columns[3][:length]
  end              
  
  def test_query_with_error
    results = @executer.exec("select top 10 * from Slisp")
    
  end
      
end  