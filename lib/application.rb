require 'hotcocoa'  
require 'drb'                 
require 'date'

require 'lib/mappings'
require 'lib/table_view_controller'

class Application

  include HotCocoa   
  
  def draw_query_view
    @query_view = layout_view(:frame => @query_view_frame, :mode => :horizontal, :spacing => 0, :margin => 0, :layout => {:start => false, :expand => [:width]}) do |horiz|      
      horiz << @query_field = text_field(:text => "exec sp_help Users --select top 100 * from Users", :layout => {:expand => [:width, :height], :left_padding => 10, :right_padding => 10, :top_padding => 10 })
    end
  end    
      
    
  def exec_query		  
    clear_result_tables
    NSLog "exec_query query: #{@query_field.stringValue}"
		                            
		File.open("/tmp/request.sql", "w+") do |f|
		  f.puts @query_field.stringValue
	  end		                       				        
		NSLog(`ruby ./server/shell_server.rb`)
		@results = Marshal.load(File.open("/tmp/response.drb"))
		
    # DRb.start_service()
    # server = DRbObject.new_with_uri('druby://localhost:4242')   
    # @results = server.exec(@query_field.stringValue)    
    # DRb.stop_service()        
		clear_result_tables
		if @results.kind_of?(Array)		
  		@results.each do |result|
  		  create_results_table(result)						
  		end                      
  	else
  	  NSLog("ERROR: #{@results}")
	  end      
	  calc_tables_placeholder_frame
  end       
  
  def clear_result_tables
    @tables_placeholder.subviews.each do |subview|
      subview.removeFromSuperview
    end
  end
  
  def create_results_table(result)
    @tables_placeholder << scroll_view(:layout => {:spacing => 0, :margin => 0, :start => false, :expand => [:width, :height]}) do |scroll|
      scroll.setAutohidesScrollers(true)
      scroll << table_view() do |table|        
        TableViewController.new(result, table)
      end
    end
  end
          	      
  def calc_tables_placeholder_frame
    frame = @results_view.frame    
    @tables_placeholder.frame =  [0,0, frame.size.width, frame.size.height] 
  end
  
  def start                                                 
    @query_view_frame = [0, 0, 0, 250]                    
    @results_view_frame = [0, 0, 0, 500]                    
    
    application(:name => "QueryExec") do |app|
      app.delegate = self
      @main_window = window(:size => [1024, 768], :center => true, :title => "QueryExec", :view => :nolayout) do |win|
        win.will_close { exit }
        win.view = split_view(:frame => [0,0,1024,768], :horizontal => true, :layout => {:expand => [:width, :height], :spacing => 0, :margin => 0}) do |vert|
          vert << draw_query_view  
          vert << @results_view = scroll_view(:frame => @results_view_frame, :layout => {:spacing => 0, :margin => 0, :padding => 0, :start => false, :expand => [:width, :height]}) do |scroll|   
            scroll.setAutohidesScrollers(true) 
            scroll << @tables_placeholder = layout_view(:frame => [0, 0, 640, 480], :spacing => 0, :margin => 0, :layout => {:start => false, :expand => [:width, :height], :padding => 0}) do |horiz|
            end
          end 
          vert.will_resize_subviews{ calc_tables_placeholder_frame }
        end          
        win.did_resize { calc_tables_placeholder_frame }     
        #win.on_notification { |notification| NSLog("Received notification of #{notification.name} on win") }                      
      end
      calc_tables_placeholder_frame
    end
    
  end 
  
  def on_execute(menu)
    exec_query              
    calc_tables_placeholder_frame
  end                   
                                   
  def on_hide_query(menu)    
    on_show_both(menu)
    if @query_view.frame.size.height > 0
      @query_view_frame = @query_view.frame
      @query_view.frame = [0,0,0,0]            
    end                          
    calc_tables_placeholder_frame
  end 
                                  
  def on_hide_results(menu)
    on_show_both(menu)
    if @results_view.frame.size.height > 0
      @results_view_frame = @results_view.frame
      @results_view.frame = [0,0,0,0]            
    end 
    calc_tables_placeholder_frame
  end                                             
  
  def on_show_both(menu)
    @query_view.frame = @query_view_frame 
    @results_view.frame = @results_view_frame  
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