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
		@columns.each do |name|
			add_column name
		end
	end
	
	#TODO - alignment, width
	def add_column(name)
    column = NSTableColumn.new()          
    column.initWithIdentifier(name)   
    column.setIdentifier(name)
    column.headerCell.setStringValue(name)  	
		@table_view.addTableColumn(column)			
	end
	
	def remove_all_columns
		@table_view.tableColumns().each do |column|
			@table_view.removeTableColumn(column)
		end
	end
		         
end