require 'hotcocoa'  
require 'drb'                 
require 'date'

require 'lib/mappings'

class Application

  include HotCocoa   
  
  def draw_query_view
    layout_view(:frame => [0, 0, 0, 10], :mode => :horizontal, :spacing => 0, :margin => 0, :layout => {:start => false, :expand => [:width]}) do |horiz|      
      horiz << @query_field = text_field(:text => "exec sp_help Users --select top 100 * from Users", :layout => {:expand => [:width, :height], :left_padding => 10, :right_padding => 10, :top_padding => 10 })
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
      	      
  def calc_tables_placeholder_frame
    frame = @tables_scroll_view.frame    
    @tables_placeholder.frame =  [0,0, frame.size.width, frame.size.height] 
  end
  
  def start                    
    application(:name => "QueryExec") do |app|
      app.delegate = self
      @main_window = window(:size => [1024, 768], :center => true, :title => "QueryExec", :view => :nolayout) do |win|
        win.will_close { exit }
        win.view = split_view(:frame => [0,0,1024,768], :horizontal => true, :layout => {:expand => [:width, :height]}, :spacing => 0, :margin => 0) do |vert|
          vert << draw_query_view  
          vert << @tables_scroll_view = scroll_view(:frame => [0, 0, 0, 30], :layout => {:spacing => 0, :margin => 0, :padding => 0, :start => false, :expand => [:width, :height]}) do |scroll|   
            scroll.setAutohidesScrollers(true) 
            scroll << @tables_placeholder = layout_view(:frame => [0, 0, 640, 480], :spacing => 0, :margin => 0, :padding => 0, :layout => {:start => false, :expand => [:width, :height]}) do |horiz|
            end
          end 
          vert.will_resize_subviews{ calc_tables_placeholder_frame }
        end          
        win.did_resize { calc_tables_placeholder_frame }     
        win.on_notification { |notification| NSLog("Received notification of #{notification.name} on win") }                      
      end
      calc_tables_placeholder_frame
    end
    
  end 
  
  def on_execute(menu)
    exec_query              
    calc_tables_placeholder_frame
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