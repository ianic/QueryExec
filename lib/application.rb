require 'hotcocoa'  
require 'drb'                 
require 'date'

# Replace the following code with your own hotcocoa code

class Application

  include HotCocoa   
  
  def draw_query_view
    layout_view(:frame => [0, 0, 0, 150], :mode => :horizontal, :spacing => 0, :margin => 10, :layout => {:start => false, :expand => [:width]}) do |horiz|      
      horiz << @query_field = text_field(:text => "exec sp_help Users --select top 100 * from Users", :layout => {:expand => [:width, :height], :align => :center})
    end
  end    
    
  def exec_query		
		NSLog "exec_query query: #{@query_field.stringValue}"
		
		DRb.start_service()
		server = DRbObject.new_with_uri('druby://localhost:4242')		
		@results = server.exec(@query_field.stringValue)		
		DRb.stop_service() 
		
		@results.each do |result|
		  add_results_table(result[:columns], result[:data])						
		end
	rescue => e
	  NSLog "exec_query error #{e}"
  end  
  
  def add_results_table(column_names, data)
    columns = column_names.map{|name| column(:id => name, :title => name)}  
    data.map do |row| 
      row.each do |key, value|
        row[key] = value.to_s if value.kind_of?(Data) || value.kind_of?(Time)          
      end
    end
    add_table(columns, data)
  end  
  
  def add_table(columns, data) 
     @tables_placeholder << scroll_view(:layout => {:spacing => 0, :margin => 0, :start => false, :expand => [:width, :height]}) do |scroll|
      scroll.setAutohidesScrollers(true)
      scroll << table_view(:columns => columns, :data => data) do |table|
         table.setUsesAlternatingRowBackgroundColors(true)  
      end
    end
  end
      	      
  def update_window_geometry
    frame = @main_window.frame
    NSLog "x=#{frame.origin.x}, y=#{frame.origin.y}, width=#{frame.size.width}, height=#{frame.size.height}"     
    @tables_placeholder.frame =  [0,0, frame.size.width-15, frame.size.height - 200] 
  end
  
  def start            
    
    
    application(:name => "QueryExec") do |app|
      app.delegate = self
      @main_window = window(:size => [1024, 768], :center => true, :title => "QueryExec", :view => :nolayout) do |win|
        win.will_close { exit }
        win.view = layout_view(:layout => {:expand => [:width, :height]}, :spacing => 0, :margin => 0) do |vert|
          vert << draw_query_view
          vert << scroll_view(:layout => {:spacing => 0, :margin => 0, :padding => 0, :start => false, :expand => [:width, :height]}) do |scroll|   
            scroll.setAutohidesScrollers(true) 
            scroll << @tables_placeholder = layout_view(:frame => [0, 0, 640, 480], :spacing => 0, :margin => 0, :padding => 0, :layout => {:start => false, :expand => [:width, :height]}) do |horiz|
            end
          end    
        end          
        win.did_resize { update_window_geometry }                           
      end
      update_window_geometry 
      exec_query    
      update_window_geometry
    end
    
  end 
                     
  
  # file/open
  def on_open(menu)
  end
  
  # file/new 
  def on_new(menu)
  end
  
  # help menu item
  def on_help(menu)
  end
  
  # This is commented out, so the minimize menu item is disabled
  #def on_minimize(menu)
  #end
  
  # window/zoom
  def on_zoom(menu)
  end
  
  # window/bring_all_to_front
  def on_bring_all_to_front(menu)
  end
end

Application.new.start