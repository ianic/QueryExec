require 'hotcocoa'

class TableViewController  
  
  def initialize(result, table_view)                  
    @table_view = table_view
    @columns = result[:columns]
    @data = result[:data]
    
    init              
    remove_all_columns
    add_columns
  end  
           
  def numberOfRowsInTableView(tableView)    
    NSLog("numberOfRowsInTableView: #{@data.size}")
    @data.size
	end
	
	def tableView(tableView, objectValueForTableColumn:column, row:row)				
	  return (row + 1) if column.identifier == ""	    
	  
		value = @data[row][column.identifier.to_sym]
		if value.kind_of?(Time) || value.kind_of?(Date)	
			value.to_s
		else
			value
		end		
	end  
	
	def table_clicked
    NSLog("table_clicked") 
  end
  
  private
  
  def init
    @table_view.setUsesAlternatingRowBackgroundColors(true)    
    @table_view.target = self
    @table_view.setDelegate(self) 
    @table_view.dataSource = self 
    @table_view.setDoubleAction(:table_clicked) 
    @table_view.setColumnAutoresizingStyle(NSTableViewNoColumnAutoresizing)
  end

	def add_columns     
	  add_column({:name => ""})
		@columns.each { |column_data| add_column(column_data) }	
	end
	
	#TODO - alignment, width
	def add_column(column_data)
	  name = column_data[:name]
    table_column = NSTableColumn.new()          
    table_column.initWithIdentifier(name)   
    table_column.setIdentifier(name)
    table_column.headerCell.setStringValue(name)  	
		@table_view.addTableColumn(table_column)			
	end
	
	def remove_all_columns
		@table_view.tableColumns().each do |table_column|
			@table_view.removeTableColumn(table_column)
		end
	end
		         
end